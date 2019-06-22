import 'package:diet_app/data/nutritional_products_repository.dart';
import 'package:diet_app/models/nutrition.dart';
import 'package:optional/optional.dart';

class NutritionalProductsService {

  final NutritionalProductsRepository nutritionalProductsRepository;

  NutritionalProductsService(this.nutritionalProductsRepository);

  Future<List<NutritionalProductSummary>> getAllRecipes(){
    return nutritionalProductsRepository.getAllRecipesSummary();
  }

  Future<List<NutritionalProductSummary>> getAllProducts(){
    return nutritionalProductsRepository.getAllProductsSummary();
  }

  Future<void> deleteProduct(String productId){
    return nutritionalProductsRepository.deleteProduct(productId);
  }

  Future<Optional<Product>> getProductById(String id){
    return nutritionalProductsRepository.getProductById(id);
  }
}