import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/app_localizations.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_sub_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/widgets/categories_shimmer.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/widgets/categories_side_rail.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/widgets/sub_categories_grid_view.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_header.dart';

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

  _FakeGetSubCategoriesUseCase(this._handler);

  @override
  Future<Result<List<SubCategoryEntity>>> call(String categoryId) =>
      _handler(categoryId);

  @override
  CommerceRepo get repo => throw UnimplementedError();
}

Widget _buildTestApp() {
  final colors = LightColors();
  return MaterialApp(
    theme: AppTheme(colors).theme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const CategoriesPage(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AppColors>(LightColors.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('CategoriesPage shows CategoriesShimmer while loading', (
    tester,
  ) async {
    final completer = Completer<Result<List<CategoryEntity>>>();
    getIt.registerFactory<CategoriesCubit>(
      () => CategoriesCubit(
        _FakeGetCategoriesUseCase(() => completer.future),
        _FakeGetSubCategoriesUseCase((_) async => Success(const [])),
      ),
    );

    await tester.pumpWidget(_buildTestApp());
    await tester.pump();

    expect(find.byType(HomeHeader), findsOneWidget);
    expect(find.byType(CategoriesShimmer), findsOneWidget);

    completer.complete(Success(const []));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'CategoriesPage renders rail and subcategories and switches category on tap',
    (tester) async {
      final categories = [
        CategoryEntity('c1', '', "Men's Fashion"),
        CategoryEntity('c2', '', "Women's Fashion"),
      ];

      getIt.registerFactory<CategoriesCubit>(
        () => CategoriesCubit(
          _FakeGetCategoriesUseCase(() async => Success(categories)),
          _FakeGetSubCategoriesUseCase((id) async {
            if (id == 'c1') {
              return Success([
                const SubCategoryEntity(
                  id: 's1',
                  name: 'Shirts',
                  slug: 'shirts',
                  categoryId: 'c1',
                ),
              ]);
            }
            return Success([
              const SubCategoryEntity(
                id: 's2',
                name: 'Dresses',
                slug: 'dresses',
                categoryId: 'c2',
              ),
            ]);
          }),
        ),
      );

      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(CategoriesSideRail), findsOneWidget);
      expect(find.byType(SubCategoriesGridView), findsOneWidget);
      expect(find.text('Shirts'), findsOneWidget);

      await tester.tap(find.text("Women's Fashion"));
      await tester.pumpAndSettle();

      expect(find.text('Dresses'), findsOneWidget);
    },
  );

  testWidgets('CategoriesPage shows error view and retries on tap', (
    tester,
  ) async {
    var attempts = 0;
    getIt.registerFactory<CategoriesCubit>(
      () => CategoriesCubit(
        _FakeGetCategoriesUseCase(() async {
          attempts++;
          if (attempts == 1) return Failure('Load error');
          return Success([CategoryEntity('c1', '', 'Electronics')]);
        }),
        _FakeGetSubCategoriesUseCase((_) async => Success(const [])),
      ),
    );

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Load error'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(CategoriesSideRail), findsOneWidget);
    expect(attempts, equals(2));
  });
}
