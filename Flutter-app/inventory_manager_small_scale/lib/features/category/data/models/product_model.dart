import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int,
    name: json['name'] as String,
    category: json['category'] as String,
    price: (json['price']).toDouble(),
    quantity: json['quantity'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'price': price,
    'quantity': quantity,
  };
}
