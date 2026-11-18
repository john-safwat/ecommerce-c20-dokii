import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/app_localizations.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/home_sections.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_banners_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_home_data_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_products_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_banners_carousel.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_categories_section.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_header.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_product_card.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_products_section.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_shimmer.dart';

class _FakeGetHomeDataUseCase implements GetHomeDataUseCase {
  final Future<List<Result<HomeSections>>> Function() _handler;

  _FakeGetHomeDataUseCase(this._handler);

  @override
  Future<List<Result<HomeSections>>> call() => _handler();

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

Widget _buildTestApp() {
  final colors = LightColors();
  return MaterialApp(
    theme: AppTheme(colors).theme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const HomePage(),
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

  testWidgets('HomePage shows HomeShimmer while loading', (tester) async {
    final completer = Completer<List<Result<HomeSections>>>();
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(_FakeGetHomeDataUseCase(() => completer.future)),
    );

    await tester.pumpWidget(_buildTestApp());
    await tester.pump();

    expect(find.byType(HomeHeader), findsOneWidget);
    expect(find.byType(HomeShimmer), findsOneWidget);

    completer.complete([]);
    await tester.pumpAndSettle();
  });

  testWidgets('HomePage renders banners, categories, and product sections', (
    tester,
  ) async {
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(
        _FakeGetHomeDataUseCase(
          () async => [
            Success(
              BannersSection(0, [
                BannerEntity(
                  'assets/images/advertisement_1.png',
                  'Up To 25% Off',
                  'Headphones',
                  Alignment.centerRight,
                  const Color(0xFF004182),
                  const Color(0xFFFFFFFF),
                ),
              ]),
            ),
            Success(
              CategoriesSection(1, [
                CategoryEntity('c1', '', 'Electronics'),
              ], 'Categories'),
            ),
            Success(
              ProductsListSection(2, [
                ProductEntity('p1', 'Steam Iron', '', 4.8, 2500, 2000),
              ], 'Home Appliance'),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeBannersCarousel), findsOneWidget);
    expect(find.byType(HomeCategoriesSection), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.byType(HomeProductsSection), findsOneWidget);
    expect(find.byType(HomeProductCard), findsOneWidget);
    expect(find.text('Home Appliance'), findsOneWidget);
    expect(find.text('Steam Iron'), findsOneWidget);
    expect(find.text('EGP 2000'), findsOneWidget);
  });

  testWidgets('HomePage shows error view and retries on tap', (tester) async {
    var calls = 0;
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(
        _FakeGetHomeDataUseCase(() async {
          calls++;
          if (calls == 1) return [];
          return [
            Success(
              CategoriesSection(1, [
                CategoryEntity('c1', '', 'Fashion'),
              ], 'Categories'),
            ),
          ];
        }),
      ),
    );

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Failed to load home data'), findsAtLeastNWidgets(1));
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(calls, equals(2));
    expect(find.byType(HomeCategoriesSection), findsOneWidget);
    expect(find.text('Fashion'), findsOneWidget);
  });
}
