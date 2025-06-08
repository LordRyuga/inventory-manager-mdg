part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  ProductLoaded(this.products);
}

class ProductDetailLoaded extends ProductState {
  final ProductEntity product;
  ProductDetailLoaded(this.product);
}

class CategoriesLoaded extends ProductState {
  final List<String> categories;
  CategoriesLoaded(this.categories);
}

class StatsLoaded extends ProductState {
  final Map<String, dynamic> stats;
  StatsLoaded(this.stats);
}

class ProductSuccess extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}