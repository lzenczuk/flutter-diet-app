import 'package:diet_app/data/product_repository.dart';
import 'package:flutter/widgets.dart';

class RepositoriesProvider extends InheritedWidget {

  final ProductRepository productRepository;

  const RepositoriesProvider({Key key, Widget child, this.productRepository}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static RepositoriesProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(RepositoriesProvider);
  }

}
