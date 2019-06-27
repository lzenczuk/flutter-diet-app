import 'package:diet_app/models/nutritional_product_summary.dart';
import 'package:diet_app/models/product.dart';
import 'package:optional/optional.dart';
import 'package:sqflite/sqflite.dart';

abstract class ProductsRepository {
  Future<List<NutritionalProductSummary>> getAllProductsSummary();
  Future<List<NutritionalProductSummary>> getProductsByIds(Set<String> ids);

  Future<Optional<Product>> getProductById(String id);

  Future<void> insertProduct(Product product);
  Future<void> updateProduct(Product product);

  Future<void> deleteProduct(String productId);
}

class ProductRepositoryImpl implements ProductsRepository{

  final Database _db;

  ProductRepositoryImpl(this._db);

  @override
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

  @override
  Future<List<NutritionalProductSummary>> getProductsByIds(Set<String> ids) async {

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

  @override
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

  @override
  Future<void> insertProduct(Product product) async {
    return await _db.insert('products', product.toMap());
  }

  @override
  Future<void> updateProduct(Product product) async {
    return await _db.update('products',
        product.toMap(),
        where: 'id=?',
        whereArgs: [product.id]
    );
  }

  @override
  Future<void> deleteProduct(String productId) async {
    return await _db.delete('products',
        where: 'id = ?', whereArgs: [productId]);
  }
}
