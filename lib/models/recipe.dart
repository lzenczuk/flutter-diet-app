import 'ingredient.dart';

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
