import 'package:uuid/uuid.dart';

import 'nutrition.dart';

var productUuid = new Uuid();

class Product implements HasNutrition{
  String id;
  String name;
  double fat;
  double carbs;
  double protein;

  Product(){
    this.id=productUuid.v4();
  }

  Product.basic(this.name, this.fat);

  Product.create(this.name, this.fat, this.carbs, this.protein){
    this.id=productUuid.v4();
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, fat: $fat, carbohydrates: $carbs, protein: $protein}';
  }

  @override
  Nutrition get nutrition => Nutrition(fat, protein, carbs);


}