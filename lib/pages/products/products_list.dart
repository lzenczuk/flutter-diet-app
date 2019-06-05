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

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    ProductRepository productRepository =
        RepositoriesProvider.of(context).productRepository;

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      drawer: MainDrawer(
        active: "Products",
      ),
      body: Center(
        child: ProductsList(products: productRepository.getAll()),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/productEditor');
          },
          child: Icon(Icons.add)),
    );
  }
}

class ProductsList extends StatelessWidget {
  final List<Product> products;

  const ProductsList({Key key, this.products}) : super(key: key);

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
                onTap: () {
                  Navigator.pushNamed(context, '/productView',
                      arguments: products[index].id);
                },
              ),
            ),
          );
        });
  }
}
