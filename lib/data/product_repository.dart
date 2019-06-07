import 'package:diet_app/models/product.dart';

abstract class ProductRepository {
  List<Product> getAll();
  Product save(Product p);
  Product getProductById(String id);
  bool remove(String id);
}


class ProductRepositoryMemoryImpl implements ProductRepository{
  List<Product> _products_list = [];
  Map<String, Product> _products_by_id_map = {};

  ProductRepositoryMemoryImpl(){
    save(new Product.create("Test 1", 25.3, 0, 17.5));
    save(new Product.create("Test 2", 100, 0, 0));
    save(new Product.create("Test 3", 5, 38.4, 4.2));
    save(new Product.create("Test 4", 85, 0, 12));
    save(new Product.create("Test 5", 3, 4.9, 8.2));
    save(new Product.create("Test 6", 23, 0, 5));
    save(new Product.create("Test 7", 0, 56, 21));
    save(new Product.create("Test 8", 0.5, 0, 22.3));
    save(new Product.create("Test 10", 0, 22, 7.4));
    save(new Product.create("Test 11", 75.5, 3.4, 3));
    save(new Product.create("Test 12", 18, 17, 0));
    save(new Product.create("Test 13", 0, 88.3, 0));
    save(new Product.create("Test 14", 3.3, 2.4, 1.22));
    save(new Product.create("Test 1", 25.3, 0, 17.5));
    save(new Product.create("Test 2", 100, 0, 0));
    save(new Product.create("Test 3", 5, 38.4, 4.2));
    save(new Product.create("Test 4", 85, 0, 12));
    save(new Product.create("Test 5", 3, 4.9, 8.2));
    save(new Product.create("Test 6", 23, 0, 5));
    save(new Product.create("Test 7", 0, 56, 21));
    save(new Product.create("Test 8", 0.5, 0, 22.3));
    save(new Product.create("Test 10", 0, 22, 7.4));
    save(new Product.create("Test 11", 75.5, 3.4, 3));
    save(new Product.create("Test 12", 18, 17, 0));
    save(new Product.create("Test 13", 0, 88.3, 0));
    save(new Product.create("Test 14", 3.3, 2.4, 1.22));
  }

  @override
  List<Product> getAll() {
    return _products_list.getRange(0, _products_list.length).toList(growable: false);
  }

  @override
  Product save(Product p) =>
      _products_by_id_map.update(p.id, (Product oldValue) => p, ifAbsent: () {
        _products_list.add(p);
        return p;
      });

  @override
  Product getProductById(String id) => _products_by_id_map[id];

  @override
  bool remove(String id) {
    var removed = _products_by_id_map.containsKey(id);

    _products_list.removeWhere((Product p) => p.id==id);
    _products_by_id_map.removeWhere((String key, Product p) => key==id);

    return removed;
  }


}
