import 'package:diet_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class RecipesListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipesListPageState();
  }
}

class _RecipesListPageState extends State<RecipesListPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      drawer: MainDrawer(active: "Recipes",),
      body: Center(
        child: Text("Recipes list"),
      ),
    );
  }
}
