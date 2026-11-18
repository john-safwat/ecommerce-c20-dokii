# Walkthrough: Auth Login & Register UI + Validation + Register Cubit Template

**Date:** 2026-11-15

## Summary
Built the Login and Register screen UIs matching the Route E-Commerce design, added Egyptian mobile phone validation to `Validator`, wired `LoginPage` to the existing `LoginCubit` (fixing its initial state from `Resources.loading()` to `Resources.init()` and adding navigation/error UI actions), and created the `RegisterCubit` template (`RegisterState`, `RegisterActions`, `RegisterUIAction`, `RegisterCubit`) without registration business logic so the user can implement it directly.

## Files Changed
- **Created**:
  - `lib/core/common_ui/app_text_field.dart`
  - `lib/core/common_ui/app_button.dart`
  - `lib/features/auth/presentation/widgets/route_logo.dart`
  - `lib/features/auth/presentation/register/view/register_state.dart`
  - `lib/features/auth/presentation/register/view/register_actions.dart`
  - `lib/features/auth/presentation/register/view/register_cubit.dart`
  - `lib/features/auth/presentation/register/view/register_page.dart`
  - `test/core/utils/validators_test.dart`
  - `docs/walkthroughs/2026-11-15_auth-login-register-ui.md`
- **Modified**:
  - `lib/core/utils/validators.dart` (added `phoneValidation`)
  - `lib/core/l10n/app_en.arb` & `lib/core/l10n/app_ar.arb` (+ regenerated `app_localizations*.dart`)
  - `lib/core/routing/app_routes.dart` & `lib/core/routing/route_gen.dart` (added `AppRoutes.register`)
  - `lib/features/auth/presentation/login/view/login_actions.dart`
  - `lib/features/auth/presentation/login/view/login_cubit.dart`
  - `lib/features/auth/presentation/login/view/login_page.dart`
  - `lib/core/di/injection.config.dart` (regenerated for `RegisterCubit`)
  - `docs/04-theme-and-ui-components.md` & `docs/walkthroughs/README.md`

## API Changes
None.

## Widgets & Catalogue
Added `AppTextField` and `AppButton` to `lib/core/common_ui/` and documented them in `docs/04-theme-and-ui-components.md`. Added feature-local `RouteLogo` in `lib/features/auth/presentation/widgets/route_logo.dart`.

## DI
Registered `@injectable RegisterCubit` and regenerated `lib/core/di/injection.config.dart`.

## Routing
Added `AppRoutes.register` (`/register`) in `app_routes.dart` and `routeGen` in `route_gen.dart`.

## Localization
Added English and Arabic strings for Login, Register, and phone validation in `app_en.arb` and `app_ar.arb`, and regenerated `app_localizations*.dart` via `flutter gen-l10n`.

## Code Generation
- `flutter gen-l10n`
- `dart run build_runner build --delete-conflicting-outputs`

## Testing
- Added unit tests in `test/core/utils/validators_test.dart`.
- Verified `dart format --set-exit-if-changed .`, `flutter analyze`, and `flutter test`.

## Known Limitations / Follow-ups
- `RegisterCubit.doAction` is intentionally left as a stub (`// TODO: Implement registration logic`).
- `LoginPage._handleNavigation` has a placeholder `TODO` for `NavigateToHomeScreen()` until the Home route is implemented.
