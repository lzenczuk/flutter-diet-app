import 'package:diet_app/models/recipe.dart';
import "package:test/test.dart";

void main(){
  test("Recipe default constructor creates new recipe", (){
    var recipe = Recipe("test");

    expect(recipe.name, equals("test"));
    expect(recipe.id, isNotNull);
    expect(recipe.id, isNotEmpty);
    expect(recipe.ingredients, isNotNull);
    expect(recipe.ingredients, isEmpty);
  });

  test("Recipe allow to add ingredence", (){
    var recipe = Recipe("test");
    recipe.addIngredient(ProductIngredient("123-123-123", 25));

    expect(recipe.name, equals("test"));
    expect(recipe.id, isNotNull);
    expect(recipe.id, isNotEmpty);
    expect(recipe.ingredients, isNotNull);
    expect(recipe.ingredients.length, equals(1));
    expect(recipe.ingredients[0].amount, equals(25));
    expect((recipe.ingredients[0] as ProductIngredient).productId, equals("123-123-123"));
  });

  test("Recipe allow to add ingredence", (){
    var recipe = Recipe("test");
    recipe.addIngredient(ProductIngredient("123-123-123", 25));

    expect(recipe.name, equals("test"));
    expect(recipe.id, isNotNull);
    expect(recipe.id, isNotEmpty);
    expect(recipe.ingredients, isNotNull);
    expect(recipe.ingredients.length, equals(1));
    expect(recipe.ingredients[0].amount, equals(25));
    expect((recipe.ingredients[0] as ProductIngredient).productId, equals("123-123-123"));
  });

  test("Recipe from constructor copy data", (){
    var recipe1 = Recipe("test");

    var recipe = Recipe.from(recipe1);

    expect(recipe.name, equals("test"));
    expect(recipe.id, isNotNull);
    expect(recipe.id, isNotEmpty);
    expect(recipe.ingredients, isNotNull);
    expect(recipe.ingredients, isEmpty);
  });

  test("Recipe from constructor creates deep copy", (){
    var recipe1 = Recipe("test");

    var recipe = Recipe.from(recipe1);

    recipe1.addIngredient(ProductIngredient("123", 25));

    expect(recipe.name, equals("test"));
    expect(recipe.id, isNotNull);
    expect(recipe.id, isNotEmpty);
    expect(recipe.ingredients, isNotNull);
    expect(recipe.ingredients, isEmpty);
  });
}