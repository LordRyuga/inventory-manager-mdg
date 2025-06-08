part of 'product_bloc.dart';

abstract class ProductEvent 
{}

class GetAllProductsEvent extends ProductEvent {}

class GetProductByIdEvent extends ProductEvent {
  final int id;

  GetProductByIdEvent(this.id);
}

class CreateProductEvent extends ProductEvent {
  final ProductEntity product;

  CreateProductEvent(this.product);
}

class UpdateProductEvent extends ProductEvent {
  final ProductEntity product;

  UpdateProductEvent(this.product);
}

class DeleteProductEvent extends ProductEvent {
  final int id;

  DeleteProductEvent(this.id);
}

class GetStatsEvent extends ProductEvent {}

class GetProductsByCategoryEvent extends ProductEvent {
  final String category;

  GetProductsByCategoryEvent(this.category);
}

class SearchProductEvent extends ProductEvent {
  final String query;

  SearchProductEvent(this.query);
}

class GetProductsByStockStatusEvent extends ProductEvent {
  final bool inStock;

  GetProductsByStockStatusEvent(this.inStock);
}