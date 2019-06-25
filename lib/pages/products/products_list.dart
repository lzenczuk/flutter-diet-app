import 'package:diet_app/data/repositories.dart';
import 'package:diet_app/models/nutrition.dart';
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
  List<NutritionalProductSummary> _products = [];

  @override
  void didChangeDependencies() {
    loadProducts();
  }

  void loadProducts() {
    RepositoriesProvider.of(context)
        .nutritionalProductsService
        .getAllProducts()
        .then((products) {
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
          title: buildAppBarTitle(context),
          actions: buildAppBarPopupMenu(context),
        ),
        drawer: buildDrawer(context),
        body: buildBody(context),
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, '/productEditor');
        },
        child: Icon(Icons.add));
  }

  Widget buildAppBarTitle(BuildContext context) {
    return Text("Products");
  }

  Center buildBody(BuildContext context) {
    return Center(
      child: ProductsList(
        products: _products,
        //TODO - on long press switch view to select (scroll?)
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

            items.add(PopupMenuItem(
              child: Text("Select"),
              value: ProductListActions.select,
            ));

            return items;
          },
          onSelected: (action) {
            if (ProductListActions.select == action) {
              Navigator.pushNamed(context, '/productsSelect');
            } else if (ProductListActions.selectAll == action) {
              Set<String> selected = Set();
              _products.forEach((np) => selected.add(np.id));
              Navigator.pushNamed(context, '/productsSelect',
                  arguments: selected);
            }
          },
        )
      ];
    } else {
      return [];
    }
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
