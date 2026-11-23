class CartProductEntity {
  final int count;
  final String id;
  final double price;
  final String title;
  final String imageCover;
  final String brandName;
  final String categoryName;

  const CartProductEntity(
    this.count,
    this.id,
    this.price, {
    this.title = '',
    this.imageCover = '',
    this.brandName = '',
    this.categoryName = '',
  });

  CartProductEntity copyWith({
    int? count,
    String? id,
    double? price,
    String? title,
    String? imageCover,
    String? brandName,
    String? categoryName,
  }) {
    return CartProductEntity(
      count ?? this.count,
      id ?? this.id,
      price ?? this.price,
      title: title ?? this.title,
      imageCover: imageCover ?? this.imageCover,
      brandName: brandName ?? this.brandName,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
