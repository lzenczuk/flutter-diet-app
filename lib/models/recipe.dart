
import 'package:uuid/uuid.dart';

class Nutrition {
  final double fat;
  final double protein;
  final double carbohydrate;
  
  Nutrition(this.fat, this.protein, this.carbohydrate);
}

abstract class Ingredient {
  double _amount;

  Ingredient(this._amount);

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  Ingredient copy();
}

class ProductIngredient extends Ingredient {
  final String _productId;

  ProductIngredient(this._productId, double amount) : super(amount);

  String get productId => _productId;

  @override
  Ingredient copy() {
    return ProductIngredient(_productId, amount);
  }
}

var productUuid = new Uuid();

class Recipe {
  String _id;
  String name;
  List<Ingredient> _ingredients = List();

  Recipe(this.name){
    this._id=productUuid.v4();
  }

  Recipe.from(Recipe recipe){
    this._id = recipe.id;
    this.name = recipe.name;
    recipe.ingredients.forEach((ingredient) => this._ingredients.add(ingredient));
  }

  Recipe.create(this.name, List<Ingredient> ingredients){
    this._id=productUuid.v4();
    ingredients.forEach((ingredient) => this._ingredients.add(ingredient));
  }

  String get id => _id;

  List<Ingredient> get ingredients => _ingredients.map((i) => i.copy()).toList(growable: false);

  void addIngredient(Ingredient ingredient){
    _ingredients.add(ingredient);
  }
}