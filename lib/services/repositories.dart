import 'package:diet_app/services/recipes_and_products_service.dart';
import 'package:flutter/widgets.dart';

class ServicesProvider extends InheritedWidget {

  final RecipesAndProductsService recipesAndProductsService;

  const ServicesProvider({Key key, Widget child, this.recipesAndProductsService}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ServicesProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ServicesProvider);
  }

}
