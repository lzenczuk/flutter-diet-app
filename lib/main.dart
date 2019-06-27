import 'package:diet_app/pages/products/product_editor.dart';
import 'package:diet_app/pages/products/product_view.dart';
import 'package:diet_app/pages/products/products_list.dart';
import 'package:diet_app/pages/products/products_selection.dart';
import 'package:diet_app/pages/recipes/recipe_editor.dart';
import 'package:diet_app/pages/recipes/recipe_view.dart';
import 'package:diet_app/pages/recipes/recipes_list.dart';
import 'package:diet_app/services/recipes_and_products_service.dart';
import 'package:flutter/material.dart';

import 'data/data_source.dart';
import 'data/ingredients_repository.dart';
import 'data/product_repository.dart';
import 'data/recipes_repository.dart';
import 'package:diet_app/services/repositories.dart';

Future main() async {
  var dataSource = DataSource();
  await dataSource.init();

  var productRepository = ProductRepositoryImpl(dataSource.db);
  var recipesRepository = RecipesRepositoryImpl(dataSource.db);
  var ingredientsRepository = IngredientsRepositoryImpl(dataSource.db);
  
  var nutritionalProductsService = RecipesAndProductsService(productRepository, recipesRepository, ingredientsRepository);

  runApp(MyApp(nutritionalProductsService));
}

class MyApp extends StatelessWidget {
  final RecipesAndProductsService recipesAndProductsService;

  MyApp(this.recipesAndProductsService);

  @override
  Widget build(BuildContext context) {
    return ServicesProvider(
      recipesAndProductsService: recipesAndProductsService,
      child: MaterialApp(
        title: 'Diet app',
        initialRoute: '/',
        routes: {
          '/': (context) => ProductListPage(),
          '/productEditor': (context) => ProductEditorPage(),
          '/productView': (context) => ProductView(),
          '/productsSelect': (context) => ProductListSelectionPage(),
          '/recipes': (context) => RecipesListPage(),
          '/recipeView': (context) => RecipeViewPage(),
          '/recipeEditor': (context) => RecipeEditorPage(),
        },
      ),
    );
  }
}

