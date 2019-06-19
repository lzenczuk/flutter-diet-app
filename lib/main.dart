import 'package:diet_app/pages/products/product_editor.dart';
import 'package:diet_app/pages/products/product_view.dart';
import 'package:diet_app/pages/products/products_list.dart';
import 'package:diet_app/pages/recipes/recipes_list.dart';
import 'package:flutter/material.dart';

import 'data/product_repository.dart';
import 'data/recipes_repository.dart';
import 'data/repositories.dart';
import 'models/product.dart';
import 'models/recipe.dart';

void main() {
  var productRepository = ProductRepositoryMemoryImpl();
  var recipesRepository = RecipesRepositoryMemoryImpl();

  setup(productRepository, recipesRepository);
  runApp(MyApp(productRepository, recipesRepository));
}

void setup(ProductRepository productRepository, RecipesRepository recipesRepository){
  var beefMinced = Product.create("Beef minced", 24.4, 16.2, 59.3);
  productRepository.save(beefMinced);

  var broccoli = Product.create("Broccoli", 0.4, 7, 2.8);
  productRepository.save(broccoli);

  var cheddar = Product.create("Cheddar", 35, 0.5, 26);
  productRepository.save(cheddar);

  var bfsth = Recipe("Beef something");
  bfsth.addIngredient(ProductIngredient(beefMinced.id, 720.0/3.0));
  bfsth.addIngredient(ProductIngredient(cheddar.id, 50));
  recipesRepository.save(bfsth);
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;
  final RecipesRepository recipesRepository;

  MyApp(this.productRepository, this.recipesRepository);

  @override
  Widget build(BuildContext context) {
    return RepositoriesProvider(
      productRepository: productRepository,
      recipesRepository: recipesRepository,
      child: MaterialApp(
        title: 'Diet app',
        initialRoute: '/',
        routes: {
          '/': (context) => ProductListPage(),
          '/productEditor': (context) => ProductEditorPage(),
          '/productView': (context) => ProductView(),
          '/recipes': (context) => RecipesListPage(),
        },
      ),
    );
  }
}

