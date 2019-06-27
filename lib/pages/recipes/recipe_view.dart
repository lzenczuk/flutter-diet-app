import 'package:diet_app/models/ingredient.dart';
import 'package:diet_app/models/nutrition.dart';
import 'package:diet_app/services/repositories.dart';
import 'package:diet_app/models/recipe.dart';
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

    if (recipeId == null) {
      setState(() {
        _loaded = true;
      });
    } else {
      ServicesProvider.of(context)
          .recipesAndProductsService
          .getRecipeById(recipeId)
          .then((opRecipe) {
        setState(() {
          _loaded = true;
          opRecipe.ifPresent((recipe) => _recipe = recipe);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Text('Loading...');

    if (_loaded) {
      if (_recipe == null) {
        body = Text('Not found');
      }

      Nutrition totalNutrition = _recipe.ingredients
          .map((i) => i.nutritionalProductSummary.nutrition)
          .fold(Nutrition(0, 0, 0), (n1, n2) => n1 + n2);

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
                itemBuilder: (BuildContext context, int index) {
                  var ingredient = _recipe.ingredients[index];

                  return IngredientView(
                    ingredient: ingredient,
                    totalNutrition: totalNutrition,
                  );
                }),
          )
        ],
      );
    }

    return Scaffold(appBar: buildAppBar(context), body: Center(child: body));
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
    var title = _recipe == null ? Text("Recipe") : Text(_recipe.name);

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

class IngredientView extends StatelessWidget {
  final Ingredient ingredient;
  final Nutrition totalNutrition;

  const IngredientView({Key key, this.ingredient, this.totalNutrition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Nutrition nutritionPercentage =
        ingredient.nutritionalProductSummary.nutrition / totalNutrition * 100.0;

    var textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        // ------------- Title line
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                ingredient.nutritionalProductSummary.name,
                style: textTheme.subhead,
              ),
              flex: 3,
            ),
            Flexible(
              child: Text(ingredient.amount.toStringAsFixed(2)),
              flex: 1,
            )
          ],
        ),
        // ------------- Nutrition line
        Row(
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 4), child: Text("Fat")),
                  Text(ingredient.nutritionalProductSummary.nutrition.fat
                      .toStringAsFixed(2)),
                ],
              ),
              flex: 1,
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 4), child: Text("Carbs")),
                  Text(ingredient.nutritionalProductSummary.nutrition.carbs
                      .toStringAsFixed(2)),
                ],
              ),
              flex: 1,
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Text("Protein")),
                  Text(ingredient.nutritionalProductSummary.nutrition.protein
                      .toStringAsFixed(2)),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
        // ------------- Percentage line
        Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: PercentageBar(percentage: nutritionPercentage.fat)),
              flex: 1,
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: PercentageBar(percentage: nutritionPercentage.carbs)),
              flex: 1,
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child:
                      PercentageBar(percentage: nutritionPercentage.protein)),
              flex: 1,
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

class PercentageBar extends StatelessWidget {
  final double percentage;

  const PercentageBar({Key key, this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color barColor = Colors.green;
    if(percentage>20){
      barColor = Colors.lightGreen;
    }
    if(percentage>40){
      barColor = Colors.yellow;
    }
    if(percentage>60){
      barColor = Colors.orange;
    }
    if(percentage>80){
      barColor = Colors.red;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(percentage.toStringAsFixed(0) + '%'),
          flex: 1,
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
                flex: percentage.ceil(),
              ),
              Expanded(
                child: Container(
                  height: 8,
                ),
                flex: 100 - percentage.ceil(),
              )
            ],
          ),
          flex: 3,
        )
      ],
    );
  }
}
