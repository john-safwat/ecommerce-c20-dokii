# Walkthrough — Cart Cubit & Orders UseCases

**Date**: 2026-11-18

## Summary
Implemented the cart operations in `CartCubit` (`GetCartProducts`, `AddToCart`, `RemoveFromCart`, `UpdateCart`) backed by Clean Architecture domain UseCases wrapping `OrdersRepo`, with optimistic UI updates and rollback on failure, `CartNavigationAction` toast notifications, regenerated DI registrations, and unit tests.

## Files Changed
- **Created**:
  - `lib/features/orders/domain/use_cases/get_user_cart_use_case.dart`
  - `lib/features/orders/domain/use_cases/add_to_cart_use_case.dart`
  - `lib/features/orders/domain/use_cases/remove_from_cart_use_case.dart`
  - `lib/features/orders/domain/use_cases/update_cart_use_case.dart`
  - `test/features/orders/presentation/cart/cart_cubit_test.dart`
  - `docs/walkthroughs/2026-11-18_cart-cubit.md`
- **Modified**:
  - `lib/features/orders/presentation/cart/cart_actions.dart` (added `CartNavigationAction` & `ShowCartToast`)
  - `lib/features/orders/presentation/cart/cart_state.dart` (added `Resources<Map<String, CartProductEntity>> cartResource`)
  - `lib/features/orders/presentation/cart/cart_cubit.dart` (injected UseCases, implemented `_getUserCart`, `_addToCart`, `_removeFromCart`, `_updateCart` with optimistic updates & rollback)
  - `lib/core/di/injection.config.dart` (regenerated via `build_runner`)
  - `docs/walkthroughs/README.md`

## API Changes
None — uses existing `OrdersApiClient` endpoints (`/api/v2/cart`).

## Widgets
None.

## DI
Registered `OrdersMapper`, `OrdersRepoImpl` (`as: OrdersRepo`), `GetUserCartUseCase`, `AddToCartUseCase`, `RemoveFromCartUseCase`, `UpdateCartUseCase`, and `CartCubit` (`@singleton`) in `lib/core/di/injection.config.dart`.

## Routing
None.

## Localization
None.

## Analytics
None.

## Platform Impact
Pure Dart only.

## Build Config
None.

## Code Generation
- `dart run build_runner build --delete-conflicting-outputs`

## Testing
- `flutter test test/features/orders/presentation/cart/cart_cubit_test.dart`: 9/9 tests passing (initial load, fetch failure, add new item, optimistic add + rollback, optimistic remove + rollback, optimistic update + rollback, count <= 0 removal).
- `flutter analyze lib/features/orders/ test/features/orders/ lib/core/di/injection.config.dart`: 0 issues.

## Known Limitations / Follow-ups
- Cart UI (`CartPage`) is not yet implemented and should subscribe to `CartCubit.navStream` to render `ShowCartToast`.
