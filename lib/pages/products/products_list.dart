import 'package:diet_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage>{

  List<Product> products = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App"),
      ),
      body: Center(
        child: ProductsList(products: products),
      ),
      floatingActionButton:
      FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/product');

            if(result != null && result is Product){
              setState(() {
                products.add(result);
              });
            }
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
