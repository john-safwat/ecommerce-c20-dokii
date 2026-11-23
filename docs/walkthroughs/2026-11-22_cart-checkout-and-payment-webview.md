# Cart Checkout Bottom Sheet & Payment WebView

- **Date**: 2026-11-22

## Summary

Implemented the end-to-end checkout flow from `CartPage` with a modal `CheckoutBottomSheet` offering **Credit Card** (online Stripe session via WebView) and **Cash on Delivery** options plus validated shipping address inputs. Preserved `cartId` across cart API responses via `CartEntity`, integrated `POST /api/v2/orders/{cartId}` and `POST /api/v1/orders/checkout-session/{cartId}?url=http://localhost:3000`, added `PaymentWebViewPage` backed by `webview_flutter` with debug-gated `AppLogger` logging for all WebView lifecycle/navigation/error callbacks, and handled success/cancelled/failed callback outcomes in `CartCubit`.

## Files Changed

### Created
- `lib/core/utils/app_logger.dart`
- `lib/features/orders/data/models/shipping_address_request_dto.dart`
- `lib/features/orders/data/models/cash_order_response_dto.dart`
- `lib/features/orders/data/models/checkout_session_response_dto.dart`
- `lib/features/orders/domain/entities/cart_entity.dart`
- `lib/features/orders/domain/entities/shipping_address_entity.dart`
- `lib/features/orders/domain/entities/checkout_session_entity.dart`
- `lib/features/orders/domain/entities/order_entity.dart`
- `lib/features/orders/domain/use_cases/create_cash_order_use_case.dart`
- `lib/features/orders/domain/use_cases/create_checkout_session_use_case.dart`
- `lib/features/orders/presentation/cart/widgets/checkout_bottom_sheet.dart`
- `lib/features/orders/presentation/payment/payment_web_view_args.dart`
- `lib/features/orders/presentation/payment/payment_web_view_page.dart`
- `test/features/orders/data/orders_repo_impl_test.dart`
- `test/features/orders/presentation/payment/payment_web_view_callback_resolver_test.dart`

### Modified
- `pubspec.yaml` & `pubspec.lock` (`webview_flutter: ^4.14.1`)
- `lib/core/routing/app_routes.dart` & `lib/core/routing/route_gen.dart`
- `lib/core/utils/validators.dart`
- `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ar.arb`, and regenerated `lib/core/l10n/app_localizations*.dart`
- `lib/features/orders/data/datasource/orders_api_client.dart` (+ regenerated `orders_api_client.g.dart`)
- `lib/features/orders/data/mapper/orders_mapper.dart`
- `lib/features/orders/domain/repo/orders_repo.dart` & `lib/features/orders/data/repo/orders_repo_impl.dart`
- `lib/features/orders/domain/use_cases/{get_user_cart,add_to_cart,remove_from_cart,update_cart}_use_case.dart`
- `lib/features/orders/presentation/cart/{cart_actions,cart_state,cart_cubit,cart_page}.dart`
- `lib/features/commerce/presentation/product_details/product_details_page.dart`
- `lib/core/di/injection.config.dart`
- `test/features/orders/data/orders_mapper_test.dart`
- `test/features/orders/presentation/cart/{cart_cubit_test,cart_page_test}.dart`
- `test/features/commerce/presentation/product_details/product_details_page_test.dart`
- `docs/08-dependency-injection.md` & `docs/walkthroughs/README.md`

## API Changes

- `POST /api/v2/orders/{cartId}` (`OrdersApiClient.createCashOrder`) — Cash on Delivery order creation. Already documented in `docs/Route E-commerce App.postman_collection.json`.
- `POST /api/v1/orders/checkout-session/{cartId}?url=http://localhost:3000` (`OrdersApiClient.createCheckoutSession`) — Online Stripe checkout session creation. Already documented in `docs/Route E-commerce App.postman_collection.json`.

## Widgets

- Added feature-local `CheckoutBottomSheet` under `lib/features/orders/presentation/cart/widgets/` (reuses `AppTextField` and `AppButton` from `lib/core/common_ui/`; no new shared primitives added to `docs/04`).
- Added `PaymentWebViewPage` under `lib/features/orders/presentation/payment/`.

## DI

- Registered `CreateCashOrderUseCase` and `CreateCheckoutSessionUseCase` (`@injectable`), injected into `@singleton CartCubit`.
- Regenerated `lib/core/di/injection.config.dart` via `build_runner`.

## Routing

- Added `AppRoutes.paymentWebView` (`/payment-webview`) in `app_routes.dart` and wired `MaterialPageRoute<PaymentWebViewResult>` in `route_gen.dart`.

## Localization

- Added 22 EN/AR keys in `app_en.arb` and `app_ar.arb` for checkout payment methods, shipping address fields, validation messages, WebView title, and order/payment status feedback. Regenerated `app_localizations*.dart` via `flutter gen-l10n`.

## Analytics

- None added.

## Platform Impact

- Added `webview_flutter` (Android & iOS WebView support). No custom platform channels required.

## Build Config

- No flavor, manifest, or `Info.plist` changes required.

## Code Generation

- `flutter gen-l10n`
- `dart run build_runner build --delete-conflicting-outputs`

## Testing

- Unit tests: `orders_mapper_test.dart`, `orders_repo_impl_test.dart`, `payment_web_view_callback_resolver_test.dart`, `cart_cubit_test.dart`.
- Widget tests: `cart_page_test.dart` (cash on delivery checkout & credit card WebView callback flows), `product_details_page_test.dart`.
- Verified with `dart format`, `flutter analyze`, and `flutter test`.

## Known Limitations / Follow-ups

- After a successful online payment or cash order, the cart is cleared locally and shows the empty cart state; a dedicated Orders History / Order Confirmation screen can be wired next once built.
