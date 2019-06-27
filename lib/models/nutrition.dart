
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

  operator /(Nutrition other) {
    return Nutrition(this.fat / other.fat, this.protein / other.protein, this.carbs / other.carbs);
  }

  @override
  String toString() {
    return 'Nutrition{fat: $fat, protein: $protein, carbs: $carbs}';
  }


}
