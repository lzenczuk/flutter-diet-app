import 'nutritional_product_summary.dart';

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