import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_sub_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_states.dart';

class _FakeGetCategoriesUseCase implements GetCategoriesUseCase {
  final Future<Result<List<CategoryEntity>>> Function() _handler;

  _FakeGetCategoriesUseCase(this._handler);

  @override
  Future<Result<List<CategoryEntity>>> call() => _handler();

  @override
  CommerceRepo get repo => throw UnimplementedError();
}

class _FakeGetSubCategoriesUseCase implements GetSubCategoriesUseCase {
  final Future<Result<List<SubCategoryEntity>>> Function(String categoryId)
  _handler;
  int callCount = 0;

  _FakeGetSubCategoriesUseCase(this._handler);

  @override
  Future<Result<List<SubCategoryEntity>>> call(String categoryId) {
    callCount++;
    return _handler(categoryId);
  }

  @override
  CommerceRepo get repo => throw UnimplementedError();
}

void main() {
  group('CategoriesCubit', () {
    test('initial state has initial categoriesResource', () {
      final cubit = CategoriesCubit(
        _FakeGetCategoriesUseCase(() async => Success(const [])),
        _FakeGetSubCategoriesUseCase((_) async => Success(const [])),
      );

      expect(cubit.state.categoriesResource.status, equals(Status.initial));
      expect(cubit.state.selectedCategoryId, isNull);
      cubit.close();
    });

    test(
      'LoadCategoriesAction loads categories, selects first, and fetches subcategories',
      () async {
        final categories = [
          CategoryEntity('c1', 'img1', "Men's Fashion"),
          CategoryEntity('c2', 'img2', "Women's Fashion"),
        ];
        final subCategories = [
          const SubCategoryEntity(
            id: 's1',
            name: 'Shirts',
            slug: 'shirts',
            categoryId: 'c1',
          ),
        ];

        final cubit = CategoriesCubit(
          _FakeGetCategoriesUseCase(() async => Success(categories)),
          _FakeGetSubCategoriesUseCase((id) async {
            expect(id, equals('c1'));
            return Success(subCategories);
          }),
        );

        await cubit.doAction(const LoadCategoriesAction());

        expect(cubit.state.categoriesResource.status, equals(Status.success));
        expect(cubit.state.selectedCategoryId, equals('c1'));
        expect(
          cubit.state.currentSubCategoriesResource.status,
          equals(Status.success),
        );
        expect(
          cubit.state.currentSubCategoriesResource.data,
          equals(subCategories),
        );
        await cubit.close();
      },
    );

    test(
      'SelectCategoryAction caches subcategories and avoids duplicate fetches',
      () async {
        final categories = [
          CategoryEntity('c1', 'img1', "Men's Fashion"),
          CategoryEntity('c2', 'img2', "Women's Fashion"),
        ];
        final subUseCase = _FakeGetSubCategoriesUseCase(
          (id) async => Success([
            SubCategoryEntity(
              id: 's-$id',
              name: 'Sub $id',
              slug: 'sub-$id',
              categoryId: id,
            ),
          ]),
        );

        final cubit = CategoriesCubit(
          _FakeGetCategoriesUseCase(() async => Success(categories)),
          subUseCase,
        );

        await cubit.doAction(const LoadCategoriesAction());
        expect(subUseCase.callCount, equals(1));

        await cubit.doAction(const SelectCategoryAction('c2'));
        expect(cubit.state.selectedCategoryId, equals('c2'));
        expect(subUseCase.callCount, equals(2));

        await cubit.doAction(const SelectCategoryAction('c1'));
        expect(cubit.state.selectedCategoryId, equals('c1'));
        expect(subUseCase.callCount, equals(2));

        await cubit.close();
      },
    );

    test(
      'LoadCategoriesAction emits error state and ShowCategoriesErrorToast on failure',
      () async {
        final cubit = CategoriesCubit(
          _FakeGetCategoriesUseCase(() async => Failure('Network error')),
          _FakeGetSubCategoriesUseCase((_) async => Success(const [])),
        );

        final navEvents = <CategoriesNavigationAction>[];
        final sub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(const LoadCategoriesAction());
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.categoriesResource.status, equals(Status.error));
        expect(cubit.state.categoriesResource.message, equals('Network error'));
        expect(navEvents, hasLength(1));
        expect(navEvents.first, isA<ShowCategoriesErrorToast>());

        await sub.cancel();
        await cubit.close();
      },
    );
  });
}
