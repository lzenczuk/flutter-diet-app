import 'package:diet_app/data/product_repository.dart';
import 'package:diet_app/data/repositories.dart';
import 'package:diet_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Product _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String _productId = ModalRoute.of(context).settings.arguments;

    ProductRepository productRepository = RepositoriesProvider
        .of(context)
        .productRepository;

    if (_productId != null) {
      _product = productRepository.getProductById(_productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_product != null) {
      body = ListView(
        children: <Widget>[
          ListTile(
            title: Text(_product.name),
          ),
          Divider(),
          Table(
            //border: TableBorder.all(),
            columnWidths: {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(1.0),
            },
            children: [
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                        alignment: Alignment.centerRight, child: Text('Fat'))),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(_product.fat.toString()),
                )
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Carbohydrate'))),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(_product.carbohydrates.toString()))
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                      alignment: Alignment.centerRight, child: Text('Protein')),
                ),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(_product.protein.toString()))
              ])
            ],
          ),
          Divider(),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, "/productEditor",
                  arguments: _product.id);
            },
          )
        ],
      ),
      body: body,
    );
  }
}
