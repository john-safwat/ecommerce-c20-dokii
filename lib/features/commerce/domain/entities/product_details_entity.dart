class ProductDetailsEntity {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final double price;
  final double priceAfterDiscount;
  final int sold;
  final double ratingsAverage;
  final int ratingsQuantity;
  final int quantity;

  const ProductDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    required this.priceAfterDiscount,
    required this.sold,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.quantity,
  });

  double get effectivePrice =>
      priceAfterDiscount > 0 && priceAfterDiscount < price
      ? priceAfterDiscount
      : price;
}
