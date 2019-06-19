import 'package:diet_app/models/recipe.dart';

abstract class RecipesRepository {
  List<Recipe> getAll();
  void save(Recipe p);
  Recipe getRecipeById(String id);
  bool remove(String id);
}

class RecipesRepositoryMemoryImpl implements RecipesRepository{

  RecipesRepositoryMemoryImpl.withTestData(){
    save(Recipe.create("Test recipe 1", [ProductIngredient("0", 25), ProductIngredient("1", 88)]));
    save(Recipe.create("Test recipe 2", [ProductIngredient("0", 33), ProductIngredient("2", 120)]));
    save(Recipe.create("Test recipe 3", [ProductIngredient("1", 55), ProductIngredient("6", 15)]));
    save(Recipe.create("Test recipe 4", [ProductIngredient("0", 25), ProductIngredient("1", 88)]));
  }

  RecipesRepositoryMemoryImpl();

  List<Recipe> _recipes_list = List();
  Map<String, Recipe> _recipe_by_id = Map();

  @override
  List<Recipe> getAll() {
    return _recipes_list.map((recipe) => Recipe.from(recipe)).toList(growable: false);
  }

  @override
  Recipe getRecipeById(String id) {
    var recipe = _recipe_by_id[id];

    if(recipe == null) return null;

    return Recipe.from(recipe);
  }

  @override
  bool remove(String id) {
    bool removed = _recipe_by_id.containsKey(id);

    _recipes_list.removeWhere((recipe) => recipe.id==id);
    _recipe_by_id.removeWhere((key, _) => key==id);

    return removed;
  }

  @override
  void save(Recipe recipe) {
    var r = Recipe.from(recipe);

    remove(recipe.id);
    _recipes_list.add(r);
    _recipe_by_id.putIfAbsent(recipe.id, () => r);
  }
}
