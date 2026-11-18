# Walkthrough: Paginated Products List Screen (`commerce` feature)

**Date**: 2026-11-18

## Summary
Implemented the paginated Products List screen inside `lib/features/commerce/`, backed by paginated `GET /api/v1/products` queries (`category[in]`, `page`, `limit`, `keyword`) and `metadata` parsing. Wired navigation from both the Home tab category tiles and the Categories tab (`NavigateToCategoryProducts`, `NavigateToSubCategoryProducts`) to `AppRoutes.productsList`.

## Files Changed
- **Data / Domain**:
  - `lib/features/commerce/data/models/products_response_dto.dart` — Added `PaginationMetadataDto` (`currentPage`, `numberOfPages`, `limit`, `nextPage`) and parsed `metadata` in `ProductsResponseDto`.
  - `lib/features/commerce/data/data_source/commerce_api_client.dart` (+ `.g.dart`) — Added `@Query('page')`, `@Query('limit')`, and `@Query('keyword')` to `getProducts`.
  - `lib/features/commerce/domain/entities/paginated_products_entity.dart` — Added `PaginatedProductsEntity` with `hasMore`.
  - `lib/features/commerce/data/mapper/commerce_mapper.dart` — Added `productsResponseToPaginatedEntity`.
  - `lib/features/commerce/domain/repo/commerce_repo.dart` & `lib/features/commerce/data/repo/commerce_repo_impl.dart` — Added `getPaginatedProducts`.
  - `lib/features/commerce/domain/use_cases/get_paginated_products_use_case.dart` — Added `@injectable GetPaginatedProductsUseCase` & `GetPaginatedProductsParams`.
- **Presentation**:
  - `lib/features/commerce/presentation/products_list/products_list_args.dart`
  - `lib/features/commerce/presentation/products_list/products_list_states.dart`
  - `lib/features/commerce/presentation/products_list/products_list_cubit.dart`
  - `lib/features/commerce/presentation/products_list/products_list_page.dart`
  - `lib/features/commerce/presentation/products_list/widgets/products_list_shimmer.dart`
  - `lib/features/commerce/presentation/home/widgets/home_categories_section.dart` — Added `onCategoryTap` callback to `_CategoryTile`.
  - `lib/features/commerce/presentation/home/home_page.dart` — Navigated to `AppRoutes.productsList` on category tap.
  - `lib/features/commerce/presentation/categories/categories_page.dart` — Wired `NavigateToCategoryProducts` and `NavigateToSubCategoryProducts` to `AppRoutes.productsList`.
- **Routing / DI / L10n**:
  - `lib/core/routing/app_routes.dart` & `lib/core/routing/route_gen.dart` — Added `AppRoutes.productsList` (`/products`).
  - `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ar.arb`, `lib/core/l10n/app_localizations*.dart` — Added `failedToLoadProducts` and `noProducts`.
  - `lib/core/di/injection.config.dart` — Regenerated via `build_runner`.
- **Tests**:
  - `test/features/commerce/presentation/products_list/products_list_cubit_test.dart`
  - `test/features/commerce/data/commerce_repo_impl_test.dart`

## Code Generation
- `flutter gen-l10n`
- `dart run build_runner build --delete-conflicting-outputs`

## Testing
- `flutter test test/features/commerce/presentation/products_list/products_list_cubit_test.dart` — 4/4 tests passed (initial load, pagination append & `hasReachedEnd`, error + toast, keyword search).
- `flutter analyze` on all `products_list` and modified files — 0 issues.
