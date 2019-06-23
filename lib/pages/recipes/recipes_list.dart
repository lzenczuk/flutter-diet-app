import 'package:diet_app/data/repositories.dart';
import 'package:diet_app/models/nutrition.dart';
import 'package:diet_app/services/nutritional_products_service.dart';
import 'package:diet_app/widgets/main_drawer.dart';
import 'package:diet_app/widgets/products/product_title.dart';
import 'package:diet_app/widgets/simple_popup_menu.dart';
import 'package:flutter/material.dart';

class RecipesListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipesListPageState();
  }
}

class _RecipesListPageState extends State<RecipesListPage> {
  bool _inSelectMode = false;
  Set<String> _selectedRecipes = Set();
  List<NutritionalProductSummary> _recipes = [];

  NutritionalProductsService _nutritionalProductsService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _nutritionalProductsService = RepositoriesProvider
        .of(context)
        .nutritionalProductsService;
    _nutritionalProductsService.getAllRecipes().then((recipes) {
      setState(() {
        _recipes = recipes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: MainDrawer(
        active: "Recipes",
      ),
      body: Center(
          child: _RecipesList(
              inSelectMode: _inSelectMode,
              selectedRecipes: _selectedRecipes,
              onRecipeSelectionChange: onRecipeSelectionChange,
              recipes: _recipes
          )
      ),
      floatingActionButton: _inSelectMode ? null : FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/productEditor');
          },
          child: Icon(Icons.add)
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    // Leading (drawer button or other)
    var leading;
    if (_inSelectMode) {
      leading = IconButton(
        icon: Icon(Icons.close),
        onPressed: onCancelSelectionPress,
      );
    }

    // Title or message
    var title = Text("Recipes");
    if (_inSelectMode && _selectedRecipes.length == 0) {
      title = Text("Select recipes");
    } else if (_inSelectMode && _selectedRecipes.length > 0) {
      title = Text(_selectedRecipes.length.toString() + " selected");
    }

    var actions = <Widget>[];

    // Popup menu
    if (!_inSelectMode) {
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
    }

    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
    );
  }

  void onCancelSelectionPress() {
    if (_inSelectMode) {
      setState(() {
        _inSelectMode = false;
        _selectedRecipes = Set();
      });
    }
  }

  void onSelectPressed() {
    if (!_inSelectMode) {
      setState(() {
        _inSelectMode = true;
        _selectedRecipes = Set();
      });
    }
  }

  void onSelectAllPressed() {
    setState(() {
      if (!_inSelectMode) {
        _inSelectMode = true;
        _selectedRecipes = Set();
      }

      _recipes.forEach((NutritionalProductSummary n) =>
          _selectedRecipes.add(n.id));
    });
  }

  void onDeletePressed() {
    if (_inSelectMode) {
      var repository = RepositoriesProvider
          .of(context)
          .recipesRepository;

      setState(() {
        _inSelectMode = false;
        _selectedRecipes.forEach((id) => repository.remove(id));
        _selectedRecipes = Set();
      });
    }
  }

  void onRecipeSelectionChange(String id) {
    setState(() {
      if (_selectedRecipes.contains(id)) {
        _selectedRecipes.remove(id);
      } else {
        _selectedRecipes.add(id);
      }
    });
  }
}

class _RecipesListFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

typedef void IdCallback(String id);

class _RecipesList extends StatelessWidget {

  final List<NutritionalProductSummary> recipes;
  final bool inSelectMode;
  final Set<String> selectedRecipes;
  final IdCallback onRecipeSelectionChange;

  const _RecipesList(
      {Key key, this.recipes, this.inSelectMode, this.selectedRecipes, this.onRecipeSelectionChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          var recipe = recipes[index];

          return NutritionTitle(
            inSelectMode: inSelectMode,
            selected: selectedRecipes.contains(recipe.id),
            onChanged: (_) => onRecipeSelectionChange(recipe.id),
            name: recipe.name,
            nutrition: recipe.nutrition,
            onTap: () {
              Navigator.pushNamed(context, '/recipeView',
                  arguments: recipe.id);
            },
          );
        });
  }
}

