import 'package:diet_app/models/ingredient.dart';
import 'package:sqflite/sqflite.dart';

abstract class IngredientsRepository {
  Future<List<Ingredient>> findIngredientsByRecipeId(String id);
  Future<void> insertIngredient(String recipeId, Ingredient ingredient);
}

class IngredientsRepositoryImpl implements IngredientsRepository {

  final Database _db;

  IngredientsRepositoryImpl(this._db);

  @override
  Future<void> insertIngredient(String recipeId, Ingredient ingredient) async {
    var map = ingredient.toMap();
    map['recipe_id'] = recipeId;

    return await _db.insert('recipe_ingredients', map);
  }

  @override
  Future<List<Ingredient>> findIngredientsByRecipeId(String id) async {
    return await _db
        .rawQuery(SELECT_INGREDIENTS_BY_RECIPE_ID, [id, id]).then((maps) {
      if (maps != null && maps.length > 0) {
        return maps.map((m) => Ingredient.fromMap(m)).toList(growable: false);
      } else {
        return [];
      }
    });
  }

  static const String SELECT_INGREDIENTS_BY_RECIPE_ID = '''
select pi.id                         as id,
       'PRODUCT'                     as ingredient_type,
       pi.name                       as name,
       i.amount                      as amount,
       pi.fat * (i.amount / 100)     as fat,
       pi.carbs * (i.amount / 100)   as carbs,
       pi.protein * (i.amount / 100) as protein
from recipe_ingredients as i
         INNER JOIN recipes as r ON i.recipe_id = r.id
         INNER JOIN products as pi ON i.ingredient_product_id = pi.id
where i.recipe_id = ?
union
select ri.id                         as id,
       'RECIPE'                      as ingredient_type,
       ri.name                       as name,
       i.amount                      as amount,
       ri.fat * (i.amount / 100)     as fat,
       ri.carbs * (i.amount / 100)   as carbs,
       ri.protein * (i.amount / 100) as protein
from recipe_ingredients as i
         INNER JOIN recipes as r ON i.recipe_id = r.id
         INNER JOIN recipes as ri ON i.ingredient_recipe_id = ri.id
where i.recipe_id = ?
''';
}
