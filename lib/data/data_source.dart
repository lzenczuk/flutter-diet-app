import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataSource {
  Database _db;

  Database get db {
    if(_db == null){
      throw "Can not provide database. Data source not initialized.";
    }

    return _db;
  }

  void init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // open the database
    _db = await openDatabase(path,
        version: 1,
        readOnly: false,
        onCreate: createDb,
    );
  }

  void createDb(Database db, int version) async{
    var batch = db.batch();
    _initScripts.forEach((command){
      if(command!=null) {
        batch.execute(command);
      }
    });
    await batch.commit();
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
