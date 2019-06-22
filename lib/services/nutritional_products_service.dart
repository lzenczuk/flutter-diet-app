import 'package:diet_app/data/nutritional_products_repository.dart';
import 'package:diet_app/models/nutrition.dart';
import 'package:optional/optional.dart';
import 'package:uuid/uuid.dart';

class NutritionalProductsService {

  final Uuid _productUuid = new Uuid();

  final NutritionalProductsRepository nutritionalProductsRepository;

  NutritionalProductsService(this.nutritionalProductsRepository);

  Future<List<NutritionalProductSummary>> getAllRecipes(){
    return nutritionalProductsRepository.getAllRecipesSummary();
  }

  Future<List<NutritionalProductSummary>> getAllProducts(){
    return nutritionalProductsRepository.getAllProductsSummary();
  }

  Future<void> deleteProduct(String productId){
    return nutritionalProductsRepository.deleteProduct(productId);
  }

  Future<Optional<Product>> getProductById(String id){
    return nutritionalProductsRepository.getProductById(id);
  }

  Future<String> saveProduct(Product product){
    //TODO - logic to update recipes having this product as ingredients
    if(product.id==null){
      var _id = _productUuid.v4();
      product.id = _id;
      return nutritionalProductsRepository.insertProduct(product).then((_) => _id);
    }else{
      var _id = product.id;
      return nutritionalProductsRepository.updateProduct(product).then((_) => _id);
    }
  }
}