import 'package:uuid/uuid.dart';

var productUuid = new Uuid();

class Product {
  String id;
  String name;
  double fat;
  double carbohydrates;
  double protein;

  Product(){
    this.id=productUuid.v4();
  }

  Product.basic(this.name, this.fat);

  Product.create(this.name, this.fat, this.carbohydrates, this.protein){
    this.id=productUuid.v4();
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, fat: $fat, carbohydrates: $carbohydrates, protein: $protein}';
  }


}