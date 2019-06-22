import 'package:diet_app/data/product_repository.dart';
import 'package:diet_app/data/recipes_repository.dart';
import 'package:diet_app/services/nutritional_products_service.dart';
import 'package:flutter/widgets.dart';

class RepositoriesProvider extends InheritedWidget {

  final ProductRepository productRepository;
  final RecipesRepository recipesRepository;
  final NutritionalProductsService nutritionalProductsService;

  const RepositoriesProvider({Key key, Widget child, this.productRepository, this.recipesRepository, this.nutritionalProductsService}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static RepositoriesProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(RepositoriesProvider);
  }

}
