import 'package:diet_app/data/nutritional_products_repository.dart';
import 'package:diet_app/models/nutrition.dart';

class NutritionalProductsService {

  final NutritionalProductsRepository nutritionalProductsRepository;

  NutritionalProductsService(this.nutritionalProductsRepository);

  Future<List<NutritionalProductSummary>> getAllRecipes(){
    return nutritionalProductsRepository.getAllRecipes();
  }

  Future<List<NutritionalProductSummary>> getAllProducts(){
    return nutritionalProductsRepository.getAllProducts();
  }

  Future<void> deleteProduct(String productId){
    return nutritionalProductsRepository.deleteProduct(productId);
  }
}