# Product Details Page & Product Card Navigation

**Date**: 2026-11-18

## Summary
Implemented the Product Details screen (`ProductDetailsPage`) with Clean Architecture (`GetProductDetailsUseCase`, `ProductDetailsCubit`, `ProductDetailsStates`), matching the design specification (image carousel with wishlist toggle and page indicators, title and formatted price, sold pill, rating, quantity stepper, expandable description, size and color selectors, and sticky bottom total price + Add to cart bar). Wired `HomeProductCard` so tapping any product card across the app (Home and Products List) opens `ProductDetailsPage`.

## Files Changed
- **Data / Domain**:
  - `lib/features/commerce/data/models/products_response_dto.dart` (added `images` to `ProductDto` and `ProductDetailsResponseDto`)
  - `lib/features/commerce/data/data_source/commerce_api_client.dart` & `.g.dart` (added `GET /api/v1/products/{id}`)
  - `lib/features/commerce/domain/entities/product_details_entity.dart`
  - `lib/features/commerce/data/mapper/commerce_mapper.dart` (added `productDtoToDetailsEntity`)
  - `lib/features/commerce/domain/repo/commerce_repo.dart` & `lib/features/commerce/data/repo/commerce_repo_impl.dart`
  - `lib/features/commerce/domain/use_cases/get_product_details_use_case.dart`
- **Presentation**:
  - `lib/features/commerce/presentation/product_details/product_details_states.dart`
  - `lib/features/commerce/presentation/product_details/product_details_cubit.dart`
  - `lib/features/commerce/presentation/product_details/product_details_page.dart`
  - `lib/features/commerce/presentation/product_details/widgets/product_image_carousel.dart`
  - `lib/features/commerce/presentation/product_details/widgets/product_details_shimmer.dart`
  - `lib/features/commerce/presentation/product_details/widgets/product_details_variants.dart`
  - `lib/features/commerce/presentation/home/widgets/home_product_card.dart` (added `onTap` and default navigation to `AppRoutes.productDetails`)
- **Routing / DI / L10n**:
  - `lib/core/routing/app_routes.dart` & `lib/core/routing/route_gen.dart`
  - `lib/core/di/injection.config.dart`
  - `lib/core/l10n/app_en.arb`, `app_ar.arb`, and generated `app_localizations*.dart`
- **Tests**:
  - `test/features/commerce/presentation/product_details/product_details_cubit_test.dart`
  - `test/features/commerce/presentation/product_details/product_details_page_test.dart`

## API Changes
- Added `GET /api/v1/products/{id}` (`getProductDetails`) in `CommerceApiClient` (already present in `docs/Route E-commerce App.postman_collection.json`).

## Code Generation
- Ran `flutter gen-l10n`
- Ran `dart run build_runner build --delete-conflicting-outputs`

## Testing
- `dart format --set-exit-if-changed .` passed.
- `flutter test test/features/commerce/presentation/product_details/ test/features/commerce/data/commerce_mapper_test.dart test/features/commerce/presentation/home/` — all 17 tests passed.

## Known Limitations / Follow-ups
- Size and Color selectors use default UI options because `/api/v1/products/{id}` does not return `sizes` or `colors` arrays.
- Add to cart and Wishlist actions currently update local UI state / show feedback toast until Cart and Wishlist API endpoints are wired.
