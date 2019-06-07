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
    if(_selectable){
      return null;
    }else{
      return FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/productEditor');
          },
          child: Icon(Icons.add));
    }
  }

  Widget buildAppBarTitle(BuildContext context){
    if(_selectable && _selected.length==0){
      return Text("Select products");
    }else if(_selectable && _selected.length>0){
      return Text(_selected.length.toString()+" selected");
    }else{
      return Text("Products");
    }
  }

  IconButton buildAppBarLeading(BuildContext context) {
    if(_selectable){
      return IconButton(
          icon: Icon(Icons.close),
        onPressed: (){
            setState(() {
              _selectable = false;
              _selected = new Set();
            });
        },
      );
    }else{
      return null;
    }
  }

  Center buildBody(BuildContext context) {
    return Center(
      child: ProductsList(
        products: RepositoriesProvider.of(context).productRepository.getAll(),
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
    );
  }

  MainDrawer buildDrawer(BuildContext context) {
    return MainDrawer(
      active: "Products",
    );
  }

  List<Widget> buildAppBarPopupMenu(
      BuildContext context) {
    if(_selectable){
      return [];
    }else{
      return [PopupMenuButton<ProductListActions>(
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            child: Text("Select"),
            value: ProductListActions.select,
          )
        ],
        onSelected: (action) {
          switch (action) {
            case ProductListActions.select:
              setState(() {
                _selectable = true;
                _selected = new Set();
              });
          }
        },
      )];
    }
  }

  List<Widget> buildAppBarActions(BuildContext context){

    List<Widget> actionButtons = [];

    if(_selectable){
      if(_selected.length>0){
        actionButtons.add(IconButton(icon: Icon(Icons.add_box), onPressed: null));
        actionButtons.add(IconButton(icon: Icon(Icons.delete), onPressed: null));
      }
    }

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
          );
        });
  }
}
