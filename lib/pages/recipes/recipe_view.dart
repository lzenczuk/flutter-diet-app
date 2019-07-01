import 'package:diet_app/models/ingredient.dart';
import 'package:diet_app/models/nutrition.dart';
import 'package:diet_app/services/repositories.dart';
import 'package:diet_app/models/recipe.dart';
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _recipe.name,
              style: Theme.of(context).textTheme.title.apply(fontSizeDelta: 5),
              textAlign: TextAlign.left,
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                  child: NutritionEntry(name: 'Fat', value: _recipe.fat),
                  flex: 1),
              Expanded(
                  child: NutritionEntry(name: 'Carbs', value: _recipe.carbs),
                  flex: 1),
              Expanded(
                  child:
                      NutritionEntry(name: 'Protein', value: _recipe.protein),
                  flex: 1),
              Expanded(
                  child: NutritionEntry(
                      name: 'Calories', value: 500, unit: 'kcal', precision: 0),
                  flex: 1),
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

    return Scaffold(
        appBar: buildAppBar(context),
        body: Center(
            child: Padding(
                padding: EdgeInsets.only(left: 4.0, right: 4.0), child: body)));
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
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  ingredient.nutritionalProductSummary.name,
                  style: textTheme.subhead,
                ),
                flex: 3,
              ),
              Flexible(
                child: Text(
                  ingredient.amount.toStringAsFixed(2) + 'g',
                  textAlign: TextAlign.right,
                  style: textTheme.subhead.apply(fontWeightDelta: 3),
                ),
                flex: 1,
              )
            ],
          ),
        ),
        // ------------- Nutrition line
        Row(
          children: <Widget>[
            Flexible(
              child: SmallNutritionEntry(
                name: 'Fat',
                value: ingredient.nutritionalProductSummary.nutrition.fat,
              ),
              flex: 1,
            ),
            Flexible(
              child: SmallNutritionEntry(
                name: 'Carbs',
                value: ingredient.nutritionalProductSummary.nutrition.carbs,
              ),
              flex: 1,
            ),
            Flexible(
              child: SmallNutritionEntry(
                name: 'Protein',
                value: ingredient.nutritionalProductSummary.nutrition.protein,
              ),
              flex: 1,
            ),
            Flexible(
              child: SmallNutritionEntry(
                name: 'Cal',
                value: 200,
                precision: 0,
                unit: 'kcal',
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
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: PercentageBar(percentage: 99)),
              flex: 1,
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

class NutritionEntry extends StatelessWidget {
  final String name;
  final double value;
  final int precision;
  final String unit;

  const NutritionEntry(
      {Key key, this.name, this.value, this.precision = 2, this.unit = 'g'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              name,
              style: Theme.of(context).textTheme.caption.apply(fontSizeDelta: 5.0),
            )),
        Text(
          value.toStringAsFixed(precision) + unit,
          style: Theme.of(context).textTheme.subhead.apply(fontWeightDelta: 3),
        ),
      ],
    );
  }
}

class SmallNutritionEntry extends StatelessWidget {
  final String name;
  final double value;
  final int precision;
  final String unit;

  const SmallNutritionEntry(
      {Key key, this.name, this.value, this.precision = 2, this.unit = 'g'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              name,
              style: Theme.of(context).textTheme.caption,
            )),
        Text(
          value.toStringAsFixed(precision) + unit,
          style: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 3),
        ),
      ],
    );
  }
}

class PercentageBar extends StatelessWidget {
  final double percentage;
  final double height;
  final double radius;

  const PercentageBar(
      {Key key, this.percentage, this.height = 8.0, this.radius = 4.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color barColor = Colors.green;
    if (percentage > 20) {
      barColor = Colors.lightGreen;
    }
    if (percentage > 40) {
      barColor = Colors.yellow;
    }
    if (percentage > 60) {
      barColor = Colors.orange;
    }
    if (percentage > 80) {
      barColor = Colors.red;
    }

    int barLengthAsPercentage;
    if (percentage == 0) {
      barLengthAsPercentage = 0;
    } else if (percentage < 1) {
      barLengthAsPercentage = 1;
    } else if (percentage > 100) {
      barLengthAsPercentage = 100;
    } else {
      barLengthAsPercentage = percentage.ceil();
    }

    if (barLengthAsPercentage != 0 && barLengthAsPercentage < height) {
      barLengthAsPercentage = height.ceil();
    }

    String percentageString;
    if (percentage < 1) {
      percentageString = '<1%';
    } else if (percentage > 100) {
      percentageString = '100%';
    } else {
      percentageString = percentage.toStringAsFixed(0) + '%';
    }

    return Stack(
      children: <Widget>[
        Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(radius))),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.all(Radius.circular(radius))),
              ),
              flex: barLengthAsPercentage,
            ),
            Expanded(
              child: Container(
                height: height,
              ),
              flex: 100 - barLengthAsPercentage,
            )
          ],
        ),
      ],
    );
  }
}
