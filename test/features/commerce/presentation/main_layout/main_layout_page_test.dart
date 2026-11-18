import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/app_localizations.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/home_sections.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_banners_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_home_data_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_products_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_sub_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/main_layout/main_layout_page.dart';

class _FakeGetHomeDataUseCase implements GetHomeDataUseCase {
  @override
  Future<List<Result<HomeSections>>> call() async => const [];

  @override
  GetBannersUseCase get getBannersUseCase => throw UnimplementedError();

  @override
  set getBannersUseCase(GetBannersUseCase _) {}

  @override
  GetCategoriesUseCase get getCategoriesUseCase => throw UnimplementedError();

  @override
  set getCategoriesUseCase(GetCategoriesUseCase _) {}

  @override
  GetProductsUseCase get getProductsUseCase => throw UnimplementedError();

  @override
  set getProductsUseCase(GetProductsUseCase _) {}
}

class _FakeGetCategoriesUseCase implements GetCategoriesUseCase {
  @override
  Future<Result<List<CategoryEntity>>> call() async => Success(const []);

  @override
  CommerceRepo get repo => throw UnimplementedError();
}

class _FakeGetSubCategoriesUseCase implements GetSubCategoriesUseCase {
  @override
  Future<Result<List<SubCategoryEntity>>> call(String categoryId) async =>
      Success(const []);

  @override
  CommerceRepo get repo => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AppColors>(LightColors.new);
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(_FakeGetHomeDataUseCase()),
    );
    getIt.registerFactory<CategoriesCubit>(
      () => CategoriesCubit(
        _FakeGetCategoriesUseCase(),
        _FakeGetSubCategoriesUseCase(),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('MainLayoutPage switches from Home tab to Categories tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme(LightColors()).theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MainLayoutPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.byTooltip('Categories'));
    await tester.pumpAndSettle();

    expect(find.byType(CategoriesPage), findsOneWidget);
  });
}
