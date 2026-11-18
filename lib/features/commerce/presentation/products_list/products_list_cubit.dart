import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/paginated_products_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_paginated_products_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_states.dart';

@injectable
class ProductsListCubit
    extends
        BaseCubit<
          ProductsListStates,
          ProductsListAction,
          ProductsListNavigationAction
        > {
  static const int _pageLimit = 20;

  final GetPaginatedProductsUseCase _getPaginatedProductsUseCase;

  ProductsListCubit(this._getPaginatedProductsUseCase)
    : super(ProductsListStates.initial());

  @override
  Future<void> doAction(ProductsListAction action) async {
    switch (action) {
      case LoadProductsAction():
        await _loadFirstPage(
          categoryId: action.categoryId,
          keyword: action.keyword,
        );
      case LoadMoreProductsAction():
        await _loadNextPage();
      case RefreshProductsAction():
        await _loadFirstPage(
          categoryId: state.categoryId,
          keyword: state.keyword,
        );
      case SearchProductsAction():
        await _loadFirstPage(
          categoryId: state.categoryId,
          keyword: action.keyword,
        );
    }
  }

  Future<void> _loadFirstPage({String? categoryId, String? keyword}) async {
    final trimmedKeyword = keyword?.trim();
    final effectiveKeyword = (trimmedKeyword == null || trimmedKeyword.isEmpty)
        ? null
        : trimmedKeyword;

    emit(
      state.copyWith(
        productsResource: Resources.loading(),
        currentPage: 1,
        hasReachedEnd: false,
        isLoadingMore: false,
        categoryId: categoryId,
        keyword: effectiveKeyword,
        clearKeyword: effectiveKeyword == null,
      ),
    );

    final result = await _getPaginatedProductsUseCase(
      GetPaginatedProductsParams(
        categoryId: categoryId,
        page: 1,
        limit: _pageLimit,
        keyword: effectiveKeyword,
      ),
    );
    if (isClosed) return;

    switch (result) {
      case Success<PaginatedProductsEntity>():
        final pageData = result.data;
        final products = pageData?.products ?? const <ProductEntity>[];
        emit(
          state.copyWith(
            productsResource: Resources.success(products),
            currentPage: pageData?.currentPage ?? 1,
            hasReachedEnd: !(pageData?.hasMore ?? false),
            isLoadingMore: false,
          ),
        );
      case Failure<PaginatedProductsEntity>():
        emit(
          state.copyWith(
            productsResource: Resources.error(result.message),
            isLoadingMore: false,
          ),
        );
        emitNavigation(ShowProductsErrorToast(result.message));
    }
  }

  Future<void> _loadNextPage() async {
    if (state.isLoadingMore ||
        state.hasReachedEnd ||
        state.productsResource.status == Status.loading) {
      return;
    }

    final existingProducts = state.productsResource.data ?? const [];
    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getPaginatedProductsUseCase(
      GetPaginatedProductsParams(
        categoryId: state.categoryId,
        page: nextPage,
        limit: _pageLimit,
        keyword: state.keyword,
      ),
    );
    if (isClosed) return;

    switch (result) {
      case Success<PaginatedProductsEntity>():
        final pageData = result.data;
        final merged = [
          ...existingProducts,
          ...(pageData?.products ?? const <ProductEntity>[]),
        ];
        emit(
          state.copyWith(
            productsResource: Resources.success(merged),
            currentPage: pageData?.currentPage ?? nextPage,
            hasReachedEnd: !(pageData?.hasMore ?? false),
            isLoadingMore: false,
          ),
        );
      case Failure<PaginatedProductsEntity>():
        emit(state.copyWith(isLoadingMore: false));
        emitNavigation(ShowProductsErrorToast(result.message));
    }
  }
}
