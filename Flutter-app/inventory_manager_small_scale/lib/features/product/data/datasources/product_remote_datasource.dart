import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

//In this project it might feel like why are we defining a seperate datasource
// eventhough our ProductRemoteDataSource is going to look exactly same to
// the ProductRepository, but suppose we had multiple data sources like maybe
// a local database or cache, then defining all the data sources here is a good practice
// as it seperates all the data sources and then we use all those datasources in
// the repository implmentation making it much easier for us to debug.

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProduct(int id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<List<String>> getCategories();
  Future<Map<String, dynamic>> getProductStats();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getProductsByStockStatus(bool inStock);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(ApiConstants.product);
    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    final response = await client.get('${ApiConstants.product}/$id');
    return ProductModel.fromJson(response.data['data']);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    await client.post(ApiConstants.product, data: product.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await client.put(
      '${ApiConstants.product}/${product.id}',
      data: product.toJson(),
    );
  }

  @override
  Future<void> deleteProduct(int id) async {
    await client.delete('${ApiConstants.product}/$id');
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await client.get(ApiConstants.productCategories);
    final List data = response.data['data'];
    return data.map((e) => e.toString()).toList();
  }

  @override
  Future<Map<String, dynamic>> getProductStats() async {
    final response = await client.get(ApiConstants.productStats);
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await client.get(
      ApiConstants.product,
      queryParameters: {'category': category},
    );
    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await client.get(
      ApiConstants.product,
      queryParameters: {'search': query},
    );
    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByStockStatus(bool inStock) async {
    final response = await client.get(
      ApiConstants.product,
      queryParameters: {'inStock': inStock.toString()},
    );
    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
  
}
