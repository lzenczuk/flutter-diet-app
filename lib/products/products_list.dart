import 'package:diet_app/products/product_model.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App"),
      ),
      body: Center(
        child: ProductsList(),
      ),
      floatingActionButton:
          FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/product');

                if(result != null && result is Product){
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("$result")));
                }
              },
              child: Icon(Icons.add)),
    );
  }
}

class ProductsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductsListState();
  }
}

class _ProductsListState extends State<ProductsList> {
  List<Product> products = new List();

  @override
  void initState() {
    super.initState();
    for (int q = 0; q < 1000; q++) {
      products.add(Product.basic("Product", 10.0 + q));
    }
    /*products.add(Product("Beef", 120.0));
    products.add(Product("Egg", 50));
    products.add(Product("Carot", 120));*/
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        //padding: EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (BuildContext ctx, int index) {
          return new Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(products[index].name),
                Text(products[index].fat.toString())
              ],
            ),
          );
        });
  }
}
