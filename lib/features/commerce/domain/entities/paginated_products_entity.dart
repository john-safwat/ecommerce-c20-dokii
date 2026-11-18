import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';

class PaginatedProductsEntity {
  final List<ProductEntity> products;
  final int currentPage;
  final int numberOfPages;
  final int? nextPage;

  const PaginatedProductsEntity({
    required this.products,
    required this.currentPage,
    required this.numberOfPages,
    this.nextPage,
  });

  bool get hasMore => nextPage != null && currentPage < numberOfPages;
}
