import 'package:uuid/uuid.dart';

class Nutrition {
  double fat;
  double protein;
  double carbs;

  Nutrition(this.fat, this.protein, this.carbs);

  Nutrition.fromMap(Map<String, dynamic> map) {
    this.fat=map['fat'];
    this.carbs=map['carbs'];
    this.protein=map['protein'];
  }

  operator +(Nutrition other) {
    return Nutrition(this.fat + other.fat, this.protein + other.protein,
        this.carbs + other.carbs);
  }

  operator *(double n) {
    return Nutrition(this.fat * n, this.protein * n, this.carbs * n);
  }

  @override
  String toString() {
    return 'Nutrition{fat: $fat, protein: $protein, carbs: $carbs}';
  }


}

abstract class HasNutrition {
  Nutrition get nutrition;
}

enum NutritionalProductType {
  RECIPE, PRODUCT
}

class NutritionalProductSummary {
  NutritionalProductType type;
  String id;
  String name;
  Nutrition nutrition;

  NutritionalProductSummary(this.type, this.id, this.name, this.nutrition);

  NutritionalProductSummary.fromProductMap(Map<String, dynamic> map) {
    this.id=map['id'];
    this.name=map['name'];
    type=NutritionalProductType.PRODUCT;
    this.nutrition=Nutrition(map['fat'], map['protein'], map['carbs']);
  }

  NutritionalProductSummary.fromRecipeMap(Map<String, dynamic> map) {
    this.id=map['id'];
    this.name=map['name'];
    type=NutritionalProductType.RECIPE;
    this.nutrition=Nutrition(map['fat'], map['protein'], map['carbs']);
  }

  NutritionalProductSummary.fromMap(Map<String, dynamic> map) {
        this.id=map['id'];
        this.name=map['name'];

        map.forEach((k, v) => print("_____> $k"));

        if(map['ingredient_type']==NutritionalProductType.PRODUCT.toString()){
          this.type=NutritionalProductType.PRODUCT;
        }else{
          this.type=NutritionalProductType.RECIPE;
        }

        this.nutrition=Nutrition(map['fat'], map['protein'], map['carbs']);
  }

  @override
  String toString() {
    return 'NutritionalProductSummary{type: $type, id: $id, name: $name, nutrition: $nutrition}';
  }


}

class Ingredient {
  NutritionalProductSummary nutritionalProductSummary;
  double amount;

  Ingredient(this.nutritionalProductSummary, this.amount);

  Ingredient.fromMap(Map<String, dynamic> map) {
    nutritionalProductSummary = NutritionalProductSummary.fromMap(map);
    amount = map['amount'];
  }

  Map<String, dynamic> toMap(){
    if(NutritionalProductType.PRODUCT == nutritionalProductSummary.type){
      return {
        'ingredient_recipe_id': null,
        'ingredient_product_id': nutritionalProductSummary.id,
        'amount': amount
      };
    }else{
      return {
        'ingredient_recipe_id': nutritionalProductSummary.id,
        'ingredient_product_id': null,
        'amount': amount
      };
    }
  }

  @override
  String toString() {
    return 'Ingredient{nutritionalProductSummary: $nutritionalProductSummary, amount: $amount}';
  }


}

class Recipe {
  String id;
  String name;
  double fat;
  double carbs;
  double protein;

  List<Ingredient> ingredients = List();

  Recipe();

  Recipe.fromMap(Map<String, dynamic> map) {
    this.id=map['id'];
    this.name=map['name'];
    this.fat=map['fat'];
    this.carbs=map['carbs'];
    this.protein=map['protein'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'fat': fat,
      'carbs': carbs,
      'protein': protein
    };
  }

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, fat: $fat, carbs: $carbs, protein: $protein, ingredients: $ingredients}';
  }


}

class Product {
  String id;
  String name;
  double fat;
  double carbs;
  double protein;


  Product(){
    fat = 0.0;
    carbs = 0.0;
    protein = 0.0;
  }

  Product.fromMap(Map<String, dynamic> map) {
    this.id=map['id'];
    this.name=map['name'];
    this.fat=map['fat'];
    this.carbs=map['carbs'];
    this.protein=map['protein'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'fat': fat,
      'carbs': carbs,
      'protein': protein
    };
  }
}