class ProductEntity {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final double price;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
  });
}