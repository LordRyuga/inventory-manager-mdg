import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts(); 
  Future<ProductEntity> getProductById(int id); 
  Future<void> createProduct(ProductEntity product); 
  Future<void> updateProduct(ProductEntity product); 
  Future<void> deleteProduct(int id);
  Future<List<String>> getCategories(); 
  Future<Map<String, dynamic>> getStats();
  Future<List<ProductEntity>> getProductsByCategory(String category);
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<ProductEntity>> getProductsByStockStatus(bool inStock);
}

