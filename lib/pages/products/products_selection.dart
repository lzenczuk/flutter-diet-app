import 'package:diet_app/services/repositories.dart';
import 'package:diet_app/models/nutritional_product_summary.dart';
import 'package:diet_app/widgets/main_drawer.dart';
import 'package:diet_app/widgets/products/product_title.dart';
import 'package:flutter/material.dart';

class ProductListSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductListSelectionPageState();
  }
}

enum ProductListActions { selectAll }

class _ProductListSelectionPageState extends State<ProductListSelectionPage> {
  Set<String> _selected = new Set();
  List<NutritionalProductSummary> _products = [];

  @override
  void didChangeDependencies() {

    Object toSelect = ModalRoute.of(context).settings.arguments;
    if(toSelect != null && toSelect is Set<String>){
      setState(() {
        toSelect.forEach((id) => _selected.add(id));
      });
    }

    loadProducts();
  }

  void loadProducts() {
    ServicesProvider.of(context).recipesAndProductsService.getAllProducts().then((products){
      setState(() {
        _products = products;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          leading: buildAppBarLeading(context),
          title: buildAppBarTitle(context),
          actions: <Widget>[
            ...buildAppBarActions(context),
            ...buildAppBarPopupMenu(context),
          ],
        ),
        drawer: buildDrawer(context),
        body: buildBody(context),
      ),
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    if (_selected.length > 0) {
      return Text(_selected.length.toString() + " selected");
    } else {
      return Text("Select products");
    }
  }

  IconButton buildAppBarLeading(BuildContext context) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, _selected);
        },
      );
  }

  Center buildBody(BuildContext context) {
    return Center(
      child: ProductsList(
        products: _products,
        selected: _selected,
        selectable: true,
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
    );
  }

  MainDrawer buildDrawer(BuildContext context) {
    return MainDrawer(
      active: "Products",
    );
  }

  List<Widget> buildAppBarPopupMenu(BuildContext context) {
    var numberOfAvailableProducts = _products.length;

    if (numberOfAvailableProducts > 0) {
      return [
        PopupMenuButton<ProductListActions>(
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<ProductListActions>> items = [];


              items.add(PopupMenuItem(
                child: Text("Select all"),
                value: ProductListActions.selectAll,
              ));

            return items;
          },
          onSelected: (action) {
            if (ProductListActions.selectAll == action) {
              setState(() {
                _selected = _products
                    .map((p) => p.id)
                    .toSet();
              });
            }
          },
        )
      ];
    } else {
      return [];
    }
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    List<Widget> actionButtons = [];

      if (_selected.length > 0) {
        actionButtons.add(IconButton(
            icon: Icon(Icons.add_box), color: Colors.white, onPressed: null));
        actionButtons.add(Builder(
          // Dialog have it's own context. To show snackbar we need
          // to have access to page context.
          builder: (pageContext) => IconButton(
              icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Selected products will be removed."),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text("Delete"),
                            onPressed: () {
                              var futures = <Future>[];

                              _selected.forEach((id) =>
                                  futures.add(ServicesProvider.of(context)
                                  .recipesAndProductsService.deleteProduct(id))
                              );

                              Future.wait(futures).then((_){
                                Navigator.pop(context);

                              });
                            },
                          ),
                        ],
                      );
                    });
              }),
        ));
      }

    return actionButtons;
  }
}

class ProductsList extends StatelessWidget {
  final List<NutritionalProductSummary> products;
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
            child: NutritionTitle(
              name: products[index].name,
              nutrition: products[index].nutrition,
              inSelectMode: selectable,
              selected: selected.contains(products[index].id),
              onTap: () {
                Navigator.pushNamed(context, '/productView',
                    arguments: products[index].id);
              },
              onChanged: (_) => onChange(products[index].id),
            ),
          );
        });
  }
}
