# Walkthrough — Implement Categories Tab & Main Bottom Navigation Shell

- **Date:** 2026-11-18
- **Summary:** Implemented the Categories tab inside the `commerce` feature following Clean Architecture (`BaseCubit`, `Resources<T>`, `Result<T>`), added the `GET /api/v1/categories/{categoryId}/subcategories` endpoint to `CommerceApiClient`, built the two-pane Categories UI (left category rail + right category banner and 3-column subcategories grid + shimmer skeletons), and introduced `MainLayoutPage` with the primary-blue rounded-top bottom navigation bar.

## Files Changed
- **Data:**
  - `lib/features/commerce/data/models/sub_categories_response_dto.dart` (created)
  - `lib/features/commerce/data/data_source/commerce_api_client.dart` (modified — added `getSubCategoriesOnCategory`)
  - `lib/features/commerce/data/data_source/commerce_api_client.g.dart` (regenerated)
  - `lib/features/commerce/data/mapper/commerce_mapper.dart` (modified — added `subCategoryDtoToEntity`)
  - `lib/features/commerce/data/repo/commerce_repo_impl.dart` (modified — added `getSubCategories`)
- **Domain:**
  - `lib/features/commerce/domain/entities/sub_category_entity.dart` (created)
  - `lib/features/commerce/domain/repo/commerce_repo.dart` (modified — added `getSubCategories`)
  - `lib/features/commerce/domain/use_cases/get_sub_categories_use_case.dart` (created)
- **Presentation:**
  - `lib/features/commerce/presentation/categories/categories_states.dart` (created)
  - `lib/features/commerce/presentation/categories/categories_cubit.dart` (created)
  - `lib/features/commerce/presentation/categories/categories_page.dart` (created)
  - `lib/features/commerce/presentation/categories/widgets/categories_side_rail.dart` (created)
  - `lib/features/commerce/presentation/categories/widgets/sub_categories_grid_view.dart` (created)
  - `lib/features/commerce/presentation/categories/widgets/categories_shimmer.dart` (created)
  - `lib/features/commerce/presentation/main_layout/main_layout_page.dart` (created)
- **Routing, DI & Localization:**
  - `lib/core/routing/route_gen.dart` (modified — `AppRoutes.home` now builds `MainLayoutPage`)
  - `lib/core/di/injection.config.dart` (regenerated)
  - `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ar.arb`, `lib/core/l10n/app_localizations*.dart` (updated & regenerated)
- **Tests:**
  - `test/features/commerce/data/commerce_repo_impl_test.dart` (updated — added `getSubCategories` test)
  - `test/features/commerce/presentation/categories/categories_cubit_test.dart` (created)
  - `test/features/commerce/presentation/categories/categories_page_test.dart` (created)
  - `test/features/commerce/presentation/main_layout/main_layout_page_test.dart` (created)

## API Changes
- Added `GET /api/v1/categories/{categoryId}/subcategories` (already present in `docs/Route E-commerce App.postman_collection.json` under `SubCategories / Get All SubCategories On Category`).

## Widgets
- Feature-scoped widgets only (`CategoriesSideRail`, `SubCategoriesGridView`, `CategoriesShimmer`, `SubCategoriesGridShimmer`, `MainLayoutPage`); no `lib/core/common_ui/` changes required.

## DI
- Registered `GetSubCategoriesUseCase` and `CategoriesCubit` via `@injectable` and regenerated `lib/core/di/injection.config.dart`.

## Routing
- Updated `AppRoutes.home` in `lib/core/routing/route_gen.dart` to render `MainLayoutPage` (hosting Home, Categories, and Wishlist/Profile placeholders).

## Localization
- Added `failedToLoadCategories`, `failedToLoadSubCategories`, `noSubCategories`, `noCategories`, `homeTab`, `categoriesTab`, `wishlistTab`, `profileTab`, and `comingSoon` to `app_en.arb` and `app_ar.arb`, then ran `flutter gen-l10n`.

## Code Generation
- Ran `flutter gen-l10n` and `dart run build_runner build --delete-conflicting-outputs`.

## Testing
- Added unit tests for `CommerceRepoImpl.getSubCategories` and `CategoriesCubit` (4/4 passing), plus widget tests for `CategoriesPage` and `MainLayoutPage`.
- Note: Full-suite widget tests that transitively import `injection.config.dart` hit a pre-existing/parallel compile error in `lib/features/commerce/presentation/product_details/product_details_states.dart` (`Resources.initial()` instead of `Resources.init()`).

## Known Limitations / Follow-ups
- Wishlist and Profile tabs in `MainLayoutPage` are placeholders until those features are implemented.
- Subcategory tap (`NavigateToSubCategoryProducts`) and category banner `"Shop Now"` (`NavigateToCategoryProducts`) are wired as `CategoriesNavigationAction`s ready to navigate to `AppRoutes.productsList` once `products_list` / `product_details` compile cleanly.
