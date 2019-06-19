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
