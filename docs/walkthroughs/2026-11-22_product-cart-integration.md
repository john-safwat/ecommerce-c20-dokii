# Walkthrough — Product Card & Product Details Cart Integration

**Date**: 2026-11-22

## Summary
Integrated the singleton `CartCubit` into `HomeProductCard` and `ProductDetailsPage` so users can add, remove, and update product quantities directly from product cards and the product details screen with live reactive UI updates, per-product in-flight loading indicators, and AppBar cart badge count.

## Files Changed
- **Created**:
  - `docs/walkthroughs/2026-11-22_product-cart-integration.md`
- **Modified**:
  - `lib/features/orders/presentation/cart/cart_actions.dart` (added optional `quantity` parameter to `AddToCart`)
  - `lib/features/orders/presentation/cart/cart_state.dart` (added `pendingProductIds`, `isProductPending`, and `totalItemsCount`)
  - `lib/features/orders/presentation/cart/cart_cubit.dart` (tracked `pendingProductIds` during mutations, guarded duplicate concurrent requests, chained `_updateCartUseCase` when `AddToCart.quantity > 1`)
  - `lib/features/commerce/presentation/home/widgets/home_product_card.dart` (wired reactive `BlocSelector<CartCubit, CartState, ...>` for add/remove toggle and in-button loading indicator)
  - `lib/features/commerce/presentation/product_details/product_details_states.dart` (removed placeholder `AddToCartAction` & `ShowAddedToCartToast`)
  - `lib/features/commerce/presentation/product_details/product_details_cubit.dart` (removed placeholder `AddToCartAction` handler)
  - `lib/features/commerce/presentation/product_details/product_details_page.dart` (wired `CartCubit` for AppBar badge count, cart toast subscription, synced quantity stepper, total price, and Add/Remove from cart CTA button)
  - `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ar.arb`, and regenerated `lib/core/l10n/app_localizations*.dart` (added `removeFromCart`)
  - `test/features/orders/presentation/cart/cart_cubit_test.dart`
  - `test/features/commerce/presentation/product_details/product_details_cubit_test.dart`
  - `test/features/commerce/presentation/product_details/product_details_page_test.dart`
  - `docs/walkthroughs/README.md`

## API Changes
None — uses existing `OrdersApiClient` endpoints (`/api/v2/cart`).

## Widgets
- Updated `HomeProductCard` (`_CardCartButton`) to reactively reflect `CartCubit` state (add `+` vs remove `remove_shopping_cart_outlined` + compact in-button loading indicator).
- Updated `ProductDetailsPage` (`_ProductDetailsAppBar` cart badge, `_MetricsAndStepperRow` synced with cart count when in cart, `_BottomPriceBar` Add/Remove CTA with loading state).
- No changes to `lib/core/common_ui/` or `docs/04-theme-and-ui-components.md`.

## DI
No new registrations — uses existing `@singleton CartCubit` resolved from `getIt`.

## Routing
None.

## Localization
- Added `removeFromCart` (`"Remove from cart"` / `"إزالة من السلة"`) to `app_en.arb` and `app_ar.arb` and regenerated `lib/core/l10n/app_localizations*.dart`.

## Analytics
None.

## Platform Impact
Pure Dart only.

## Build Config
None.

## Code Generation
- `flutter gen-l10n`

## Testing
- Updated `cart_cubit_test.dart` (added tests for `AddToCart` with `quantity > 1`, `pendingProductIds`, and `totalItemsCount`).
- Updated `product_details_cubit_test.dart` and `product_details_page_test.dart` (added widget tests for `HomeProductCard` cart toggle and `ProductDetailsPage` add, quantity update, and remove via `CartCubit`).
- Verified with `flutter analyze` (0 issues in modified files) and full `flutter test` suite.

## Known Limitations / Follow-ups
- Tapping the AppBar cart icon on `ProductDetailsPage` still shows "Coming soon" until `CartPage` is implemented.
