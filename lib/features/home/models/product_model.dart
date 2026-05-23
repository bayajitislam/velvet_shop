class ProductModel {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String description;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.images = const [],
    this.rating = 4.5,
    this.reviewCount = 120,
    this.description = '',
    this.isFavorite = false,
  });
}