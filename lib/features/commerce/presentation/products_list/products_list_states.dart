import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';

class ProductsListStates {
  final Resources<List<ProductEntity>> productsResource;
  final int currentPage;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? categoryId;
  final String? keyword;

  const ProductsListStates({
    required this.productsResource,
    this.currentPage = 1,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.categoryId,
    this.keyword,
  });

  factory ProductsListStates.initial() =>
      ProductsListStates(productsResource: Resources.init());

  ProductsListStates copyWith({
    Resources<List<ProductEntity>>? productsResource,
    int? currentPage,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? categoryId,
    String? keyword,
    bool clearKeyword = false,
  }) {
    return ProductsListStates(
      productsResource: productsResource ?? this.productsResource,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      categoryId: categoryId ?? this.categoryId,
      keyword: clearKeyword ? null : (keyword ?? this.keyword),
    );
  }
}

sealed class ProductsListAction {
  const ProductsListAction();
}

class LoadProductsAction extends ProductsListAction {
  final String? categoryId;
  final String? keyword;

  const LoadProductsAction({this.categoryId, this.keyword});
}

class LoadMoreProductsAction extends ProductsListAction {
  const LoadMoreProductsAction();
}

class RefreshProductsAction extends ProductsListAction {
  const RefreshProductsAction();
}

class SearchProductsAction extends ProductsListAction {
  final String keyword;

  const SearchProductsAction(this.keyword);
}

sealed class ProductsListNavigationAction {
  const ProductsListNavigationAction();
}

class ShowProductsErrorToast extends ProductsListNavigationAction {
  final String message;

  const ShowProductsErrorToast(this.message);
}
