import 'package:diet_app/models/nutrition.dart';
import 'package:diet_app/models/nutritional_product_summary.dart';
import 'package:diet_app/models/recipe.dart';
import 'package:optional/optional.dart';
import 'package:sqflite/sqflite.dart';

abstract class RecipesRepository {
  Future<List<NutritionalProductSummary>> getAllRecipesSummary();
  Future<Optional<Recipe>> getRecipeById(String id);

  Future<void> insertRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);

  Future<Optional<Nutrition>> calculateSummaryNutritionByRecipeId(String id);
}

class RecipesRepositoryImpl implements RecipesRepository{

  final Database _db;

  RecipesRepositoryImpl(this._db);

  @override
  Future<List<NutritionalProductSummary>> getAllRecipesSummary() async {
    return await _db.query('recipes',
        columns: ['id', 'name', 'fat', 'carbs', 'protein']).then((maps) {
      if (maps.length > 0) {
        return maps
            .map((map) => NutritionalProductSummary.fromRecipeMap(map))
            .toList(growable: false);
      }
      return [];
    });
  }

  @override
  Future<Optional<Recipe>> getRecipeById(String id) async {
    return await _db.query('recipes',
        columns: ['id', 'name', 'fat', 'carbs', 'protein'],
        where: 'id=?',
        whereArgs: [id]
    ).then((maps){
      if(maps.length==0){
        return Optional.empty();
      }else{
        return Optional.ofNullable(Recipe.fromMap(maps[0]));
      }
    });
  }

  @override
  Future<void> insertRecipe(Recipe recipe) async {
    return await _db.insert('recipes', recipe.toMap());
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    return await _db.update('recipes',
        recipe.toMap(),
        where: 'id=?',
        whereArgs: [recipe.id]
    );
  }

  @override
  Future<Optional<Nutrition>> calculateSummaryNutritionByRecipeId(String id) async {
    return await _db.rawQuery(SELECT_SUMMARY_NUTRITION_BY_RECIPE_ID, [id, id]).then((maps){
      if(maps!=null && maps.length>0){
        return Optional.ofNullable(Nutrition.fromMap(maps[0]));
      }else{
        return Optional.empty();
      }
    });
  }

  static const String SELECT_SUMMARY_NUTRITION_BY_RECIPE_ID = '''
select sum(fat) AS fat, sum(carbs) as carbs, sum(protein) as protein
from (
         select pi.fat * (i.amount / 100)     as fat,
                pi.carbs * (i.amount / 100)   as carbs,
                pi.protein * (i.amount / 100) as protein
         from recipe_ingredients as i
                  INNER JOIN recipes as r ON i.recipe_id = r.id
                  INNER JOIN products as pi ON i.ingredient_product_id = pi.id
         where i.recipe_id = ?
         union
         select ri.fat * (i.amount / 100)     as fat,
                ri.carbs * (i.amount / 100)   as carbs,
                ri.protein * (i.amount / 100) as protein
         from recipe_ingredients as i
                  INNER JOIN recipes as r ON i.recipe_id = r.id
                  INNER JOIN recipes as ri ON i.ingredient_recipe_id = ri.id
         where i.recipe_id = ?
     )
''';


}
