import 'package:diet_app/data/product_repository.dart';
import 'package:diet_app/data/repositories.dart';
import 'package:diet_app/models/product.dart';
import 'package:diet_app/widgets/main_drawer.dart';
import 'package:diet_app/widgets/products/product_title.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

enum ProductListActions { select }

class _ProductListPageState extends State<ProductListPage> {
  bool _selectable = false;
  Set<String> _selected = new Set();

  @override
  Widget build(BuildContext context) {
    ProductRepository productRepository =
        RepositoriesProvider.of(context).productRepository;

    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Products"),
          actions: <Widget>[
            PopupMenuButton<ProductListActions>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: Text("Select"),
                  value: ProductListActions.select,
                )
              ],
              onSelected: (action) {
                switch(action){
                  case ProductListActions.select: setState(() {
                    _selectable = true;
                    _selected = new Set();
                  });
                }
              },
            ),
          ],
        ),
        drawer: MainDrawer(
          active: "Products",
        ),
        body: Center(
          child: ProductsList(
            products: productRepository.getAll(),
            selected: _selected,
            selectable: _selectable,
            onChange: (id) {
              setState(() {
                if (_selected.contains(id)) {
                  _selected.remove(id);
                } else {
                  _selected.add(id);
                }
              });
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/productEditor');
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  final List<Product> products;
  final Set<String> selected;
  final bool selectable;
  final ValueChanged<String> onChange;

  const ProductsList(
      {Key key,
      this.products,
      this.selected,
      this.selectable = false,
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: ProductTitle(
                product: products[index],
                selectable: selectable,
                selected: selected.contains(products[index].id),
                onTap: () {
                  Navigator.pushNamed(context, '/productView',
                      arguments: products[index].id);
                },
                onChanged: (_) => onChange(products[index].id),
              ),
            ),
          );
        });
  }
}
