import 'package:diet_app/data/recipes_repository.dart';
import 'package:diet_app/models/recipe.dart';
import 'package:test/test.dart';

void main(){
  test("New repository returns empty list of recipes", (){
    var repository = RecipesRepositoryMemoryImpl();

    expect(repository.getAll(), isNotNull);
    expect(repository.getAll(), isEmpty);
  });

  test("Repository allows adding recipes", (){
    var repository = RecipesRepositoryMemoryImpl();
    var recipe = Recipe.create("test", [ProductIngredient("0", 10), ProductIngredient("1", 11)]);
    repository.save(recipe);

    expect(repository.getAll(), isNotNull);
    expect(repository.getAll(), isNotEmpty);
    expect(repository.getAll().length, equals(1));
    expect(repository.getAll()[0].id, equals(recipe.id));
    expect(repository.getAll()[0].name, equals(recipe.name));
  });

  test("Repository on adding do deep copy", (){
    var repository = RecipesRepositoryMemoryImpl();
    var recipe = Recipe.create("test", [ProductIngredient("0", 10), ProductIngredient("1", 11)]);
    repository.save(recipe);
    recipe.name="test2";

    expect(repository.getAll(), isNotNull);
    expect(repository.getAll(), isNotEmpty);
    expect(repository.getAll().length, equals(1));
    expect(repository.getAll()[0].id, equals(recipe.id));
    expect(repository.getAll()[0].name, equals("test"));
  });

  test("Repository allow getting recipes by id", (){
    var repository = RecipesRepositoryMemoryImpl();
    var recipe1 = Recipe.create("test", [ProductIngredient("0", 10), ProductIngredient("1", 11)]);
    repository.save(recipe1);

    var recipe = repository.getRecipeById(recipe1.id);


    expect(recipe, isNotNull);
    expect(recipe.id, equals(recipe1.id));
    expect(recipe.name, equals(recipe1.name));
  });
}