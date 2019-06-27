import 'nutrition.dart';

enum NutritionalProductType {
  RECIPE, PRODUCT
}

String nutritionalProductTypeAsString(NutritionalProductType npt){
  return npt.toString().split('.')[1];
}

class NutritionalProductSummary {
  NutritionalProductType type;
  String id;
  String name;
  Nutrition nutrition;

  NutritionalProductSummary(this.type, this.id, this.name, this.nutrition);

  void _mainFieldsFromMap(Map<String, dynamic> map) {
    this.id=map['id'];
    this.name=map['name'];
    this.nutrition=Nutrition(map['fat'], map['protein'], map['carbs']);
  }

  NutritionalProductSummary.fromProductMap(Map<String, dynamic> map) {
    _mainFieldsFromMap(map);
    type=NutritionalProductType.PRODUCT;
  }

  NutritionalProductSummary.fromRecipeMap(Map<String, dynamic> map) {
    _mainFieldsFromMap(map);
    type=NutritionalProductType.RECIPE;
  }

  NutritionalProductSummary.fromMap(Map<String, dynamic> map) {
    _mainFieldsFromMap(map);

    if(nutritionalProductTypeAsString(NutritionalProductType.PRODUCT) == map['ingredient_type'].toString()){
      this.type=NutritionalProductType.PRODUCT;
    }else if(nutritionalProductTypeAsString(NutritionalProductType.RECIPE) == map['ingredient_type'].toString()){
      this.type=NutritionalProductType.RECIPE;
    }else{
      throw "Can not create NutritionalProductSummary from map. Missing 'ingredient_type'.";
    }

  }

  @override
  String toString() {
    return 'NutritionalProductSummary{type: $type, id: $id, name: $name, nutrition: $nutrition}';
  }
}