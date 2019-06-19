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

enum ProductListActions { select, selectAll }

class _ProductListPageState extends State<ProductListPage> {
  bool _inSelectMode = false;
  Set<String> _selected = new Set();

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
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    if (_inSelectMode) {
      return null;
    } else {
      return FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/productEditor');
          },
          child: Icon(Icons.add));
    }
  }

  Widget buildAppBarTitle(BuildContext context) {
    if (_inSelectMode && _selected.length == 0) {
      return Text("Select products");
    } else if (_inSelectMode && _selected.length > 0) {
      return Text(_selected.length.toString() + " selected");
    } else {
      return Text("Products");
    }
  }

  IconButton buildAppBarLeading(BuildContext context) {
    if (_inSelectMode) {
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            _inSelectMode = false;
            _selected = new Set();
          });
        },
      );
    } else {
      return null;
    }
  }

  Center buildBody(BuildContext context) {
    return Center(
      child: ProductsList(
        products: RepositoriesProvider.of(context).productRepository.getAll(),
        selected: _selected,
        selectable: _inSelectMode,
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
    var numberOfAvailableProducts =
        RepositoriesProvider.of(context).productRepository.getAll().length;

    if (_inSelectMode || numberOfAvailableProducts > 0) {
      return [
        PopupMenuButton<ProductListActions>(
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<ProductListActions>> items = [];

            if (_inSelectMode) {
              items.add(PopupMenuItem(
                child: Text("Select all"),
                value: ProductListActions.selectAll,
              ));
            } else {
              if (numberOfAvailableProducts != 0) {
                items.add(PopupMenuItem(
                  child: Text("Select"),
                  value: ProductListActions.select,
                ));
              }
            }

            return items;
          },
          onSelected: (action) {
            if (ProductListActions.select == action) {
              setState(() {
                _inSelectMode = true;
                _selected = new Set();
              });
            } else if (ProductListActions.selectAll == action) {
              setState(() {
                _inSelectMode = true;
                _selected = RepositoriesProvider.of(context)
                    .productRepository
                    .getAll()
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

    if (_inSelectMode) {
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
                              var numberOfDeletedProducts = _selected.length;
                              _selected.forEach((id) =>
                                  RepositoriesProvider.of(context)
                                      .productRepository
                                      .remove(id));

                              setState(() {
                                _inSelectMode = false;
                                _selected = Set();
                              });
                              Navigator.of(context).pop();
                              var sbMessage =
                                  numberOfDeletedProducts.toString() +
                                      " products deleted";
                              if (numberOfDeletedProducts == 1) {
                                sbMessage = "1 product deleted";
                              }
                              Scaffold.of(pageContext).showSnackBar(SnackBar(
                                content: Text(sbMessage),
                                duration: Duration(seconds: 3),
                              ));
                            },
                          ),
                        ],
                      );
                    });
              }),
        ));
      }
    }

    /*

     */

    return actionButtons;
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
            child: NutritionTitle(
              name: products[index].name,
              nutrition: products[index].nutrition,
              selectable: selectable,
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
