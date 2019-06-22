import 'package:diet_app/data/repositories.dart';
import 'package:diet_app/models/nutrition.dart';
import 'package:diet_app/widgets/main_drawer.dart';
import 'package:diet_app/widgets/products/product_title.dart';
import 'package:flutter/material.dart';

class RecipeViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipeViewPageState();
  }
}

class _RecipeViewPageState extends State<RecipeViewPage> {

  bool _loaded = false;
  Recipe _recipe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String recipeId = ModalRoute.of(context).settings.arguments;

    if(recipeId==null){
      setState(() {
        _loaded = true;
      });
    }else{
      RepositoriesProvider
          .of(context)
          .nutritionalProductsService.getRecipeById(recipeId).then((opRecipe){
            setState(() {
              _loaded = true;
              opRecipe.ifPresent((recipe) => _recipe=recipe);
            });
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    Widget body = Text('Loading...');

    if(_loaded){
      if(_recipe == null){
        body = Text('Not found');
      }

      body = Column(
        children: <Widget>[
          Text(
            _recipe.name,
            style: Theme.of(context).textTheme.title,
          ),
          Divider(),
          Table(
            //border: TableBorder.all(),
            columnWidths: {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(1.0),
            },
            children: [
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                        alignment: Alignment.centerRight, child: Text('Fat'))),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(_recipe.fat.toString()),
                )
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Carbohydrate'))),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(_recipe.carbs.toString()))
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                      alignment: Alignment.centerRight, child: Text('Protein')),
                ),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(_recipe.protein.toString()))
              ])
            ],
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _recipe.ingredients.length,
                itemBuilder: (BuildContext context, int index){

                var ingredient = _recipe.ingredients[index];

              return IngredientTile(
                name: ingredient.nutritionalProductSummary.name,
                nutrition: ingredient.nutritionalProductSummary.nutrition,
                amount: ingredient.amount,
              );
            }),
          )
        ],
      );
    }

    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
          child: body
      )
    );
  }

  AppBar buildAppBar(BuildContext context) {
    // Leading (drawer button or other)
    /*var leading;
    if (_inSelectMode) {
      leading = IconButton(
        icon: Icon(Icons.close),
        onPressed: onCancelSelectionPress,
      );
    }*/

    // Title or message
    var title = _recipe==null ? Text("Recipe") : Text(_recipe.name);

    var actions = <Widget>[];

    // Popup menu
    /*if (!_inSelectMode) {
      actions.add(SimpleMenu(
        entries: [
          SimpleMenuAction("select", this.onSelectPressed),
          SimpleMenuAction("select all", this.onSelectAllPressed),
        ],
      ));
    } else if (_inSelectMode && _selectedRecipes.length == 0) {
      actions.add(SimpleMenu(
        entries: [
          SimpleMenuAction("select all", this.onSelectAllPressed),
        ],
      ));
    } else if (_inSelectMode && _selectedRecipes.length > 0) {
      actions.add(SimpleMenu(
        entries: [
          SimpleMenuAction("select all", this.onSelectAllPressed),
          SimpleMenuAction("delete", this.onDeletePressed),
        ],
      ));
    }*/

    return AppBar(
      title: title,
      actions: actions,
    );
  }

}