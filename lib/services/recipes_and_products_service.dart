import 'package:diet_app/data/ingredients_repository.dart';
import 'package:diet_app/data/product_repository.dart';
import 'package:diet_app/data/recipes_repository.dart';
import 'package:diet_app/models/ingredient.dart';
import 'package:diet_app/models/nutrition.dart';
import 'package:diet_app/models/nutritional_product_summary.dart';
import 'package:diet_app/models/product.dart';
import 'package:diet_app/models/recipe.dart';
import 'package:optional/optional.dart';
import 'package:uuid/uuid.dart';

class RecipesAndProductsService {

  final Uuid _uuidGenerator = new Uuid();

  final ProductsRepository productsRepository;
  final RecipesRepository recipesRepository;
  final IngredientsRepository ingredientsRepository;

  RecipesAndProductsService(this.productsRepository, this.recipesRepository, this.ingredientsRepository);

  Future<List<NutritionalProductSummary>> getAllRecipes(){
    return recipesRepository.getAllRecipesSummary();
  }

  Future<List<NutritionalProductSummary>> getAllProducts(){
    return productsRepository.getAllProductsSummary();
  }

  Future<List<NutritionalProductSummary>> getProductsSummaries(Set<String> ids){
    return productsRepository.getProductsByIds(ids);
  }

  Future<void> deleteProduct(String productId){
    return productsRepository.deleteProduct(productId);
  }

  Future<Optional<Product>> getProductById(String id){
    return productsRepository.getProductById(id);
  }

  Future<Optional<Recipe>> getRecipeById(String id) async {
    Optional<Recipe> opRecipe =  await recipesRepository.getRecipeById(id);
    
    if(opRecipe.isPresent){
      Recipe recipe = opRecipe.value;

      List<Ingredient> ingredients = await ingredientsRepository.findIngredientsByRecipeId(recipe.id);
      recipe.ingredients = ingredients;

      return Optional.of(recipe);
    }
    
    return opRecipe;
  }

  Future<String> saveProduct(Product product){
    //TODO - logic to update recipes having this product as ingredients
    if(product.id==null){
      var _id = _uuidGenerator.v4();
      product.id = _id;
      return productsRepository.insertProduct(product).then((_) => _id);
    }else{
      var _id = product.id;
      return productsRepository.updateProduct(product).then((_) => _id);
    }
  }
  
  Future<String> saveRecipe(Recipe recipe) async {

    if(recipe.id==null){
      var _id = _uuidGenerator.v4();
      recipe.id = _id;
      await recipesRepository.insertRecipe(recipe);
      recipe.ingredients.forEach((i) async => await ingredientsRepository.insertIngredient(_id, i));

      Optional<Nutrition> opNutrition = await recipesRepository.calculateSummaryNutritionByRecipeId(_id);
      opNutrition.ifPresent((n) async {

        recipe.fat = n.fat;
        recipe.carbs = n.carbs;
        recipe.protein = n.protein;

        await recipesRepository.updateRecipe(recipe);
      });

      return _id;
    }else{
      return recipe.id;
    }
  }
}