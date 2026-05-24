// ─────────────────────────────────────────────────────────
//  CartItemModel
// ─────────────────────────────────────────────────────────

class CartItemModel {
  final String id;         // unique: productId + size
  final String productId;
  final String name;
  final String subtitle;
  final String imageUrl;
  final String size;
  final double price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.size,
    required this.price,
    this.quantity = 1,
  });

  // From ProductModel helper
  factory CartItemModel.fromProduct({
    required String productId,
    required String name,
    required String subtitle,
    required String imageUrl,
    required String size,
    required double price,
    int quantity = 1,
  }) {
    return CartItemModel(
      id: '${productId}_$size',
      productId: productId,
      name: name,
      subtitle: subtitle,
      imageUrl: imageUrl,
      size: size,
      price: price,
      quantity: quantity,
    );
  }

  double get totalPrice => price * quantity;

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      productId: productId,
      name: name,
      subtitle: subtitle,
      imageUrl: imageUrl,
      size: size,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}