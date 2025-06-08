import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product_entity.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';


class ProductRepositoryImpl implements ProductRepository
{
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createProduct(ProductEntity product) async
  {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      quantity: product.quantity,
    );

    await remoteDataSource.createProduct(productModel);
  }

  @override
  Future<void> deleteProduct(int id) async
  {
    await remoteDataSource.deleteProduct(id);
  }

  @override
  Future<ProductEntity> getProductById(int id) async
  {
    final productModel = await remoteDataSource.getProduct(id);
    return productModel;
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async
  {
    final productModels = await remoteDataSource.getAllProducts();
    return productModels.map((model) => ProductModel.fromJson(model.toJson())).toList();
  }

  @override
  Future<List<String>> getCategories() async
  {
    return await remoteDataSource.getCategories();
  }

  @override
  Future<void> updateProduct(ProductEntity product) async
  {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      quantity: product.quantity,
    );

    await remoteDataSource.updateProduct(productModel);
  }

  @override
  Future<Map<String, dynamic>> getStats() async
  {
    return await remoteDataSource.getProductStats();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async
  {
    final productModels = await remoteDataSource.getProductsByCategory(category);
    return productModels.map((model) => ProductModel.fromJson(model.toJson())).toList();
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async
  {
    final productModels = await remoteDataSource.searchProducts(query);
    return productModels.map((model) => ProductModel.fromJson(model.toJson())).toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByStockStatus(bool inStock) async
  {
    final productModels = await remoteDataSource.getProductsByStockStatus(inStock);
    return productModels.map((model) => ProductModel.fromJson(model.toJson())).toList();
  }

}


