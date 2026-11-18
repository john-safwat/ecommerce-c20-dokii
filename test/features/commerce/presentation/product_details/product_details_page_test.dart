import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/app_localizations.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/routing/route_gen.dart';
import 'package:route_ecommerce/core/theme/app_colors.dart';
import 'package:route_ecommerce/core/theme/app_theme.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_product_details_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_product_card.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/widgets/product_details_shimmer.dart';

class _FakeGetProductDetailsUseCase implements GetProductDetailsUseCase {
  final Future<Result<ProductDetailsEntity>> Function(String id) _handler;

  _FakeGetProductDetailsUseCase(this._handler);

  @override
  Future<Result<ProductDetailsEntity>> call(String productId) =>
      _handler(productId);
}

const _sampleProduct = ProductDetailsEntity(
  id: 'p1',
  title: 'Nike Air Jordon',
  description:
      'Nike is a multinational corporation that designs, develops, and sells athletic footwear, apparel, and accessories.',
  images: [],
  price: 4000,
  priceAfterDiscount: 3500,
  sold: 3230,
  ratingsAverage: 4.8,
  ratingsQuantity: 7500,
  quantity: 10,
);

Widget _wrapWithApp(Widget child) {
  final colors = LightColors();
  return MaterialApp(
    theme: AppTheme(colors).theme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    onGenerateRoute: routeGen,
    home: child,
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

  testWidgets(
    'shows shimmer while loading and renders product details on success',
    (tester) async {
      final completer = Completer<Result<ProductDetailsEntity>>();
      getIt.registerFactory<ProductDetailsCubit>(
        () => ProductDetailsCubit(
          _FakeGetProductDetailsUseCase((_) => completer.future),
        ),
      );

      await tester.pumpWidget(
        _wrapWithApp(const ProductDetailsPage(productId: 'p1')),
      );
      await tester.pump();

      expect(find.byType(ProductDetailsShimmer), findsOneWidget);

      completer.complete(Success(_sampleProduct));
      await tester.pumpAndSettle();

      expect(find.text('Product Details'), findsOneWidget);
      expect(find.text('Nike Air Jordon'), findsOneWidget);
      expect(find.text('EGP 3,500'), findsNWidgets(2));
      expect(find.text('3,230 Sold'), findsOneWidget);
      expect(find.text('4.8 (7,500)'), findsOneWidget);
      expect(find.text('Add to cart'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('EGP 7,000'), findsOneWidget);
    },
  );

  testWidgets('tapping HomeProductCard navigates to ProductDetailsPage', (
    tester,
  ) async {
    getIt.registerFactory<ProductDetailsCubit>(
      () => ProductDetailsCubit(
        _FakeGetProductDetailsUseCase((_) async => Success(_sampleProduct)),
      ),
    );

    final cardProduct = ProductEntity(
      'p1',
      'Nike Air Jordon',
      '',
      4.8,
      3500,
      3500,
    );

    await tester.pumpWidget(
      _wrapWithApp(
        Scaffold(
          body: Center(
            child: SizedBox(
              height: 256,
              child: HomeProductCard(product: cardProduct),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(HomeProductCard));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsPage), findsOneWidget);
    expect(find.text('Product Details'), findsOneWidget);
  });
}
