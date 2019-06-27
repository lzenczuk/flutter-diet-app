import 'package:diet_app/models/nutrition.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:optional/optional.dart';

class NutritionalProductsRepository {
  Database _db;

  void init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    _db = await openDatabase(path,
        version: 1,
        readOnly: false,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      var batch = db.batch();
      _initScripts.forEach((command){
        if(command!=null) {
          batch.execute(command);
        }
      });
      await batch.commit();
    });
  }

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

  Future<List<NutritionalProductSummary>> getAllProductsSummary() async {
    return await _db.query('products',
        columns: ['id', 'name', 'fat', 'carbs', 'protein']).then((maps) {
      if (maps.length > 0) {
        return maps
            .map((map) => NutritionalProductSummary.fromProductMap(map))
            .toList(growable: false);
      }
      return [];
    });
  }

  Future<List<NutritionalProductSummary>> getProductsByIds(
      Set<String> ids) async {

    var inQueryString = ids.map((_) => '?').join(", ");
    var inArgs = ids.toList(growable: false);

    return await _db.query('products',
        columns: ['id', 'name', 'fat', 'carbs', 'protein'],
        where: 'id in ($inQueryString)',
        whereArgs: inArgs)
        .then((maps) {
      if (maps.length > 0) {
        return maps
            .map((map) => NutritionalProductSummary.fromProductMap(map))
            .toList(growable: false);
      }
      return [];
    });
  }

  Future<Optional<Product>> getProductById(String id) async {
    return await _db.query('products',
      columns: ['id', 'name', 'fat', 'carbs', 'protein'],
      where: 'id=?',
      whereArgs: [id]
    ).then((maps){
      if(maps.length==0){
        return Optional.empty();
      }else{
        return Optional.ofNullable(Product.fromMap(maps[0]));
      }
    });
  }

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

  Future<void> deleteProduct(String productId) async {
    return await _db.delete('products',
    where: 'id = ?', whereArgs: [productId]);
  }

  Future<void> insertProduct(Product product) async {
    return await _db.insert('products', product.toMap());
  }

  Future<void> insertRecipe(Recipe recipe) async {
    return await _db.insert('recipes', recipe.toMap());
  }

  Future<void> insertIngredient(String recipeId, Ingredient ingredient) async {
    print("=====> save ingredent: "+ingredient.toString());
    var map = ingredient.toMap();
    map['recipe_id'] = recipeId;

    map.forEach((k, v) => print("======> recipe_ingredient: $k -> $v"));

    return await _db.insert('recipe_ingredients', map);
  }

  Future<void> updateProduct(Product product) async {
    return await _db.update('products',
        product.toMap(),
      where: 'id=?',
      whereArgs: [product.id]
    );
  }

  Future<void> updateRecipe(Recipe recipe) async {
    return await _db.update('recipes',
        recipe.toMap(),
        where: 'id=?',
        whereArgs: [recipe.id]
    );
  }
  
  Future<List<Ingredient>> findIngredientsByRecipeId(String id) async {
    return await _db.rawQuery(SELECT_INGREDIENTS_BY_RECIPE_ID, [id, id]).then((maps){
      if(maps!=null && maps.length>0){
        return maps.map((m) => Ingredient.fromMap(m)).toList(growable: false);
      }else{
        return [];
      }
    });
  }

  Future<Optional<Nutrition>> calculateSummaryNutritionByRecipeId(String id) async {
    return await _db.rawQuery(SELECT_SUMMARY_NUTRITION_BY_RECIPE_ID, [id, id]).then((maps){
      if(maps!=null && maps.length>0){
        return Optional.ofNullable(Nutrition.fromMap(maps[0]));
      }else{
        return Optional.empty();
      }
    });
  }
}

List<String> _initScripts = [
"drop table if exists recipe_ingredients",
"drop table if exists recipes",
"drop table if exists products",

"PRAGMA foreign_keys = ON",

'''create table products
(
    id      TEXT not null primary key,
    name    TEXT not null,
    fat     REAL default 0.0,
    carbs   REAL default 0.0,
    protein REAL default 0.0
)''',

"create index name_products_index ON products(name)",

'''create table recipes
(
    id      TEXT not null primary key,
    name    TEXT not null,
    fat     REAL default 0.0, -- sum of fat from ingredients - redundant but useful for performance
    carbs   REAL default 0.0, -- sum of carbs from ingredients - redundant but useful for performance
    protein REAL default 0.0 -- sum of protein from ingredients - redundant but useful for performance
)''',

"create index name_recipes_index ON recipes(name)",

'''create table recipe_ingredients
(
    id                    INTEGER NOT NULL PRIMARY KEY autoincrement,
    recipe_id             TEXT    not null,
    ingredient_recipe_id  TEXT,
    ingredient_product_id TEXT,
    amount                REAL default 0.0,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id),
    FOREIGN KEY (ingredient_recipe_id) REFERENCES recipes(id),
    FOREIGN KEY (ingredient_product_id) REFERENCES products(id)
)''',

"create index r_recipe_ingredients_index ON recipe_ingredients (recipe_id)",
"create index ir_recipe_ingredients_index ON recipe_ingredients (ingredient_recipe_id)",
"create index ip_recipe_ingredients_index ON recipe_ingredients (ingredient_product_id)",

'''insert into products (id, name, fat, protein, carbs)
VALUES ('28535b67-1d01-4b2c-8b55-1f694e10acdc', 'Beef minced', 24.4, 59.3, 16.2)''',
'''insert into products (id, name, fat, protein, carbs)
VALUES ('8f00f88e-22b4-4bc8-a186-e32e23979a32', 'Cheddar', 35, 26, 0.5)''',
'''insert into products (id, name, fat, protein, carbs)
VALUES ('841f5005-f140-4ce2-97d8-4b1bd3c549a1', 'American Beacon', 15.9, 14.3, 0.5)''',
'''insert into products (id, name, fat, protein, carbs)
VALUES ('e2cdba7a-b070-45ab-9ba7-8baa423fe60d', 'Chopped tomato', 0.1, 1, 3)''',
'''insert into products (id, name, fat, protein, carbs)
VALUES ('f8afdbb6-75a5-4483-a38a-4bbf1c01974a', 'Tomato puree', 0.8, 3.8, 11.5)''',

'''insert into products (id, name, fat, protein, carbs)
VALUES ('54da91dc-1e8a-4d00-90ff-752b158ab7fa', 'Mayo', 81.1, 0.05, 2.7)''',
'''insert into products (id, name, fat, protein, carbs)
VALUES ('ef4b18d9-a87d-40e6-9477-25c71b0c01f8', 'Ketchup', 0.1, 23, 1.2)''',
'''insert into products (id, name, fat, protein, carbs)
VALUES ('656cc428-971d-4959-9260-12f69317b221', 'Mustard', 8, 15, 5.4)''',

//-- Sauce recipe
'''insert into recipes (id, name, fat, protein, carbs)
values ('a67e8b07-66be-4f19-be7c-f6278836be2e', 'Sauce', 17.03, 1.2, 3.81)''',
'''insert into recipe_ingredients (recipe_id, ingredient_product_id, amount)
values ('a67e8b07-66be-4f19-be7c-f6278836be2e', '54da91dc-1e8a-4d00-90ff-752b158ab7fa', 20)''',
'''insert into recipe_ingredients (recipe_id, ingredient_product_id, amount)
values ('a67e8b07-66be-4f19-be7c-f6278836be2e', 'ef4b18d9-a87d-40e6-9477-25c71b0c01f8', 10)''',
'''insert into recipe_ingredients (recipe_id, ingredient_product_id, amount)
values ('a67e8b07-66be-4f19-be7c-f6278836be2e', '656cc428-971d-4959-9260-12f69317b221', 10)''',

//-- Beef something recipe
'''insert into recipes (id, name)
values ('fbfbae05-da33-46ea-8506-d16e8814e9d5', 'Beef sth')''',
'''insert into recipe_ingredients (recipe_id, ingredient_product_id, amount)
values ('fbfbae05-da33-46ea-8506-d16e8814e9d5', '28535b67-1d01-4b2c-8b55-1f694e10acdc', 720)''',
'''insert into recipe_ingredients (recipe_id, ingredient_product_id, amount)
values ('fbfbae05-da33-46ea-8506-d16e8814e9d5', '8f00f88e-22b4-4bc8-a186-e32e23979a32', 150)''',
'''insert into recipe_ingredients (recipe_id, ingredient_product_id, amount)
values ('fbfbae05-da33-46ea-8506-d16e8814e9d5', '841f5005-f140-4ce2-97d8-4b1bd3c549a1', 200)''',
'''insert into recipe_ingredients (recipe_id, ingredient_recipe_id, amount)
values ('fbfbae05-da33-46ea-8506-d16e8814e9d5', 'a67e8b07-66be-4f19-be7c-f6278836be2e', 40)''',
];

const String SELECT_INGREDIENTS_BY_RECIPE_ID = '''
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

const String SELECT_SUMMARY_NUTRITION_BY_RECIPE_ID = '''
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
