import 'package:diet_app/services/repositories.dart';
import 'package:diet_app/models/ingredient.dart';
import 'package:diet_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';


class RecipeEditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipeEditorPageState();
  }
}

class _RecipeEditorPageState extends State<RecipeEditorPage>{

  final _recipeFormKey = GlobalKey<_RecipeFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("Recipe"),
        actions: <Widget>[
          FlatButton(
            child: Text("save"),
            onPressed: () {
              validateAndSave(context);
            },
          )
        ],
      ),
      body: Center(
        child: _RecipeForm(key: _recipeFormKey),
      ),
    );
  }

  void validateAndSave(BuildContext context) {
    _recipeFormKey.currentState.save().ifPresent((recipe){
      print("------> new recipe "+recipe.name);
      ServicesProvider.of(context).recipesAndProductsService.saveRecipe(recipe).then((_){
        Navigator.pop(context);
      });
    });
  }
}

class _RecipeForm extends StatefulWidget {

  _RecipeForm({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _RecipeFormState();
  }
}


class _RecipeFormState extends State<_RecipeForm>{

  final GlobalKey<FormState> _formKey = GlobalKey();

  String _recipe_name;
  List<Ingredient> _ingredients = [];

  @override
  Widget build(BuildContext context) {

    //TODO - refactor product title to use as component here
    var ingredients = _ingredients.map((ina){
      return Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    ina.nutritionalProductSummary.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      _NutritionInfo(
                        name: 'Fat',
                        value: ina.nutritionalProductSummary.nutrition.fat,
                      ),
                      VerticalDivider(),
                      _NutritionInfo(
                        name: 'Carbs',
                        value: ina.nutritionalProductSummary.nutrition.carbs,
                      ),
                      VerticalDivider(),
                      _NutritionInfo(
                        name: 'Protein',
                        value: ina.nutritionalProductSummary.nutrition.protein,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              initialValue: ina.amount.toString(),
              onSaved: (String v) => ina.amount = double.tryParse(v),
            ),
          )
        ],
      );
    }).toList(growable: false);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Recipe name"),
            validator: (String v) => v.isEmpty ? "Recipe name can not be empty": null,
            onSaved: (String v) => setState(() => _recipe_name = v),
          ),
          Row(
          children: <Widget>[
            Expanded(
                child: Text("Ingredients")
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: () => Navigator.pushNamed(context, '/productsSelect').then((selectedProducts){
                if(selectedProducts != null && selectedProducts is Set<String>){
                  ServicesProvider.of(context).recipesAndProductsService.getProductsSummaries(selectedProducts).then((nps){
                    setState(() {
                      nps.forEach((nps)=> _ingredients.add(Ingredient(nps, 0.0)));
                    });
                  });
                }
              }),
            )
          ],
          ),
          ...ingredients
        ],
      ),
    );
  }

  Optional<Recipe> save(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Recipe recipe = Recipe();
      recipe.name = _recipe_name;
      recipe.ingredients = _ingredients;

      return Optional.of(recipe);
    }

    return Optional.empty();
  }

}

class _NutritionInfo extends StatelessWidget {
  final String name;
  final double value;

  const _NutritionInfo({Key key, this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          child: Text(
            name,
            style: Theme.of(context).textTheme.caption,
          ),
          padding: EdgeInsets.only(right: 4.0),
        ),
        Text(
          value.toStringAsFixed(2),
          style: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 100),
        ),
      ],
    );
  }
}