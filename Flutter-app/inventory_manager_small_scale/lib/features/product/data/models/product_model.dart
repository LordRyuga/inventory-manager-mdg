import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.quantity,
    required super.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'price': price,
    };
  }
}
