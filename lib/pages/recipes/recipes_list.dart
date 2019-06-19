import 'package:diet_app/data/repositories.dart';
import 'package:diet_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class RecipesListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipesListPageState();
  }
}

class _RecipesListPageState extends State<RecipesListPage> {
  @override
  Widget build(BuildContext context) {
    var recipes = RepositoriesProvider
        .of(context)
        .recipesRepository
        .getAll();

    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      drawer: MainDrawer(active: "Recipes",),
      body: Center(
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (BuildContext ctx, int index) {

            var recipe = recipes[index];

            return Card(
              child: Text(recipe.name),
            );
          },
        ),
      ),
    );
  }
}
