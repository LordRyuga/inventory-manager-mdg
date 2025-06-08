//Importing bloc
import 'package:flutter_bloc/flutter_bloc.dart';
// importing entities
import '../../domain/entities/product_entity.dart';
// importin usecases
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_by_stock_status_usecase.dart';
import '../../domain/usecases/search_product_usecase.dart';
import '../../domain/usecases/get_product_by_category.dart';
import '../../domain/usecases/get_stats_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUsecase getAllProducts;
  final GetProductByIdUsecase getProductById;
  final CreateProductUsecase createProduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase deleteProduct;
  final GetCategoriesUseCase getCategories;
  final GetProductByStockStatus getProductByStockStatus;
  final GetProductBySearch getProductBySearch;
  final GetProductByCategory getProductByCategory;
  final GetStatsUseCase getStats;

  ProductBloc({
    required this.getAllProducts,
    required this.getProductById,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.getCategories,
    required this.getProductByStockStatus,
    required this.getProductBySearch,
    required this.getProductByCategory,
    required this.getStats,
  }) : super(ProductInitial()) {
    on<GetAllProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await getAllProducts.call(NoParams());
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetProductByIdEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await getProductById.call(event.id);
        emit(ProductDetailLoaded(product));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<CreateProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await createProduct.call(event.product);
        emit(ProductSuccess());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await updateProduct.call(event.product);
        emit(ProductSuccess());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await deleteProduct.call(event.id);
        emit(ProductSuccess());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetCategoriesEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final categories = await getCategories.call(NoParams());
        emit(CategoriesLoaded(categories));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetStatsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final stats = await getStats.call(NoParams());
        emit(StatsLoaded(stats));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetProductsByCategoryEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await getProductByCategory.call(event.category);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<SearchProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final results = await getProductBySearch.call(event.query);
        emit(ProductLoaded(results));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<GetProductsByStockStatusEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await getProductByStockStatus.call(event.inStock);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }

}
