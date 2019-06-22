import 'package:uuid/uuid.dart';

class Nutrition {
  final double fat;
  final double protein;
  final double carbohydrate;

  Nutrition(this.fat, this.protein, this.carbohydrate);

  operator +(Nutrition other) {
    return Nutrition(this.fat + other.fat, this.protein + other.protein,
        this.carbohydrate + other.carbohydrate);
  }

  operator *(double n) {
    return Nutrition(this.fat * n, this.protein * n, this.carbohydrate * n);
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

  NutritionalProductSummary.fromMap(Map<String, dynamic> map) {
        this.id=map['id'];
        this.name=map['name'];
        this.type=NutritionalProductType.RECIPE;
        this.nutrition=Nutrition(map['fat'], map['protein'], map['carbs']);
  }
}

class Ingredient {
  NutritionalProductSummary nutritionalProductSummary;
  double amount;
}

class Recipe {
  String id;
  String name;
  double fat;
  double carbs;
  double protein;

  List<Ingredient> ingredients = List();
}

class Product {
  String id;
  String name;
  double fat;
  double carbs;
  double protein;

  Product.fromMap(Map<String, dynamic> map) {
    this.id=map['id'];
    this.name=map['name'];
    this.fat=map['fat'];
    this.carbs=map['carbs'];
    this.protein=map['protein'];
  }
}