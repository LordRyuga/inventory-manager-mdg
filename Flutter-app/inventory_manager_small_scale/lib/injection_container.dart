import 'package:get_it/get_it.dart';
import 'package:inventory_manager_small_scale/features/product/presentation/bloc/category_bloc.dart';
import 'features/product/domain/usecases/get_all_products_usecase.dart';
import 'features/product/domain/usecases/create_product_usecase.dart';
import 'features/product/domain/usecases/delete_product_usecase.dart';
import 'features/product/domain/usecases/get_by_stock_status_usecase.dart';
import 'features/product/domain/usecases/get_categories_usecase.dart';
import 'features/product/domain/usecases/get_product_by_category.dart';
import 'features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'features/product/domain/usecases/get_stats_usecase.dart';
import 'features/product/domain/usecases/search_product_usecase.dart';
import 'features/product/domain/usecases/update_product_usecase.dart';

import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/data/datasources/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';

import './core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {

  //API client
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Blocs
  sl.registerFactory(() => ProductBloc(
        getAllProducts: sl(),
        getProductById: sl(),
        createProduct: sl(),
        updateProduct: sl(),
        deleteProduct: sl(),
        getProductByStockStatus: sl(),
        getProductBySearch: sl(),
        getProductByCategory: sl(),
        getStats: sl(),
      ));

  sl.registerFactory(() => CategoryBloc(getCategories: sl()));

  // Usecases
  sl.registerLazySingleton(() => GetAllProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUsecase(sl()));
  sl.registerLazySingleton(() => CreateProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByStockStatus(sl()));
  sl.registerLazySingleton(() => GetProductBySearch(sl()));
  sl.registerLazySingleton(() => GetProductByCategory(sl()));
  sl.registerLazySingleton(() => GetStatsUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(sl()));
}
