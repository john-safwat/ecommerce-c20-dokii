import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/paginated_products_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_paginated_products_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_states.dart';

class _FakeGetPaginatedProductsUseCase implements GetPaginatedProductsUseCase {
  final List<GetPaginatedProductsParams> recordedParams = [];
  Future<Result<PaginatedProductsEntity>> Function(
    GetPaginatedProductsParams params,
  )?
  handler;

  @override
  Future<Result<PaginatedProductsEntity>> call(
    GetPaginatedProductsParams params,
  ) {
    recordedParams.add(params);
    return handler!(params);
  }
}

void main() {
  late _FakeGetPaginatedProductsUseCase useCase;
  late ProductsListCubit cubit;

  setUp(() {
    useCase = _FakeGetPaginatedProductsUseCase();
    cubit = ProductsListCubit(useCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  ProductEntity makeProduct(String id) => ProductEntity(
    id,
    'Product $id',
    'https://example.com/$id.png',
    4.5,
    100,
    90,
  );

  group('ProductsListCubit', () {
    test(
      'loads first page successfully and sets hasReachedEnd=false when hasMore is true',
      () async {
        final page1 = PaginatedProductsEntity(
          products: [makeProduct('1'), makeProduct('2')],
          currentPage: 1,
          numberOfPages: 2,
          nextPage: 2,
        );
        useCase.handler = (_) async => Success(page1);

        await cubit.doAction(const LoadProductsAction(categoryId: 'cat-1'));

        expect(cubit.state.productsResource.status, Status.success);
        expect(cubit.state.productsResource.data?.length, 2);
        expect(cubit.state.currentPage, 1);
        expect(cubit.state.hasReachedEnd, isFalse);
        expect(cubit.state.isLoadingMore, isFalse);
        expect(useCase.recordedParams.length, 1);
        expect(useCase.recordedParams.first.categoryId, 'cat-1');
        expect(useCase.recordedParams.first.page, 1);
      },
    );

    test(
      'loads next page and appends products, setting hasReachedEnd=true on last page',
      () async {
        final page1 = PaginatedProductsEntity(
          products: [makeProduct('1')],
          currentPage: 1,
          numberOfPages: 2,
          nextPage: 2,
        );
        final page2 = PaginatedProductsEntity(
          products: [makeProduct('2')],
          currentPage: 2,
          numberOfPages: 2,
        );
        useCase.handler = (params) async =>
            params.page == 1 ? Success(page1) : Success(page2);

        await cubit.doAction(const LoadProductsAction(categoryId: 'cat-1'));
        await cubit.doAction(const LoadMoreProductsAction());

        expect(cubit.state.productsResource.data?.map((e) => e.id).toList(), [
          '1',
          '2',
        ]);
        expect(cubit.state.currentPage, 2);
        expect(cubit.state.hasReachedEnd, isTrue);
        expect(cubit.state.isLoadingMore, isFalse);

        // Subsequent LoadMoreProductsAction is a no-op when hasReachedEnd is true
        await cubit.doAction(const LoadMoreProductsAction());
        expect(useCase.recordedParams.length, 2);
      },
    );

    test(
      'emits error state and navigation toast when initial load fails',
      () async {
        useCase.handler = (_) async => Failure('Network error');

        final navEvents = <ProductsListNavigationAction>[];
        final sub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(const LoadProductsAction(categoryId: 'cat-1'));
        await pumpEventQueue();
        await sub.cancel();

        expect(cubit.state.productsResource.status, Status.error);
        expect(cubit.state.productsResource.message, 'Network error');
        expect(navEvents, [isA<ShowProductsErrorToast>()]);
      },
    );

    test('SearchProductsAction reloads page 1 with keyword', () async {
      final page1 = PaginatedProductsEntity(
        products: [makeProduct('9')],
        currentPage: 1,
        numberOfPages: 1,
      );
      useCase.handler = (_) async => Success(page1);

      await cubit.doAction(const SearchProductsAction('nike'));

      expect(cubit.state.keyword, 'nike');
      expect(cubit.state.productsResource.data?.single.id, '9');
      expect(useCase.recordedParams.single.keyword, 'nike');
    });
  });
}
