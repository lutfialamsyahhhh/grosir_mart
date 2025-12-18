class ProductModel {
  final String id;
  final String name;
  final int price;
  final int stock;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toInt(),
      stock: (data['stock'] ?? 0).toInt(),
      description: data['description'] ?? '',
    );
  }
}
