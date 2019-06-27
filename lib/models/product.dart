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