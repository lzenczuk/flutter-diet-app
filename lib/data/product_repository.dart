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
