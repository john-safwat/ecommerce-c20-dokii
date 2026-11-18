# Walkthrough — Implement Splash Screen

## Date
2026-11-11

## Summary
Implemented the Splash Screen for Route E-Commerce following Clean Architecture and design system specifications. Added high-resolution splash asset under `assets/images/splash_screen.png` and declared `AppAssets.splashScreen`. Constructed `SplashStates`, `SplashAction` (`InitSplashAction`), and `SplashNavigationAction` (`NavigateToLoginScreen`), driven by `@injectable SplashCubit` extending `BaseCubit`. The `SplashPage` view displays the splash asset covering the viewport and navigates to the login screen (`AppRoutes.login`) via `Navigator.pushReplacementNamed` after a 3-second delay. Added `AppRoutes.login` route and placeholder `LoginPage`. Regenerated DI configuration and added complete unit and widget test suites.

## Files Changed
- `assets/images/splash_screen.png` (created) — Splash background image asset.
- `pubspec.yaml` (modified) — Declared `assets/images/` asset directory and added `fake_async` dev dependency.
- `lib/core/constants/app_assets.dart` (created) — Central asset path constant `AppAssets.splashScreen`.
- `lib/features/splash/presentation/view/splash_states.dart` (created) — `SplashStates`, `InitSplashAction`, and `NavigateToLoginScreen`.
- `lib/features/splash/presentation/view/splash_cubit.dart` (created) — `@injectable SplashCubit` managing 3-second delay and navigation event emission.
- `lib/features/splash/presentation/view/splash_page.dart` (created) — `SplashPage` listening to `navStream` and rendering splash image.
- `lib/features/auth/presentation/login/view/login_page.dart` (created) — Placeholder `LoginPage` destination for login route.
- `lib/core/routing/app_routes.dart` (modified) — Added `login = '/login'`.
- `lib/core/routing/route_gen.dart` (modified) — Added route generators for `AppRoutes.splash` and `AppRoutes.login`.
- `lib/core/di/injection.config.dart` (regenerated) — Generated registration for `SplashCubit`.
- `analysis_options.yaml` (modified) — Excluded generated files (`**/*.g.dart`, `**/*.config.dart`) from analyzer checks.
- `test/features/splash/presentation/splash_cubit_test.dart` (created) — Unit test suite for `SplashCubit`.
- `test/features/splash/presentation/splash_page_test.dart` (created) — Widget test suite for `SplashPage` rendering and navigation.
- `test/widget_test.dart` (modified) — Advanced virtual clock to allow splash timer to settle.
- `docs/08-dependency-injection.md` (modified) — Documented `SplashCubit` DI binding.
- `docs/walkthroughs/2026-11-11_implement_splash_screen.md` (created) — This document.
- `docs/walkthroughs/README.md` (modified) — Added index entry.

## API Changes
None. No network endpoints were touched or created.

## Widgets
- `SplashPage`: Screen widget displaying splash cover image and routing to login.
- `LoginPage`: Placeholder screen widget with AppBar and centered title.
*(Note: Feature-specific screen widgets; no shared `lib/core/common_ui/` components created).*

## DI
- Added `@injectable` factory registration for `SplashCubit` in `lib/features/splash/presentation/view/splash_cubit.dart`.
- Regenerated `lib/core/di/injection.config.dart`.
- Updated `docs/08-dependency-injection.md` with `SplashCubit` entry.

## Routing
- Added `AppRoutes.login = '/login'`.
- Wired `AppRoutes.splash` to `SplashPage` and `AppRoutes.login` to `LoginPage` in `lib/core/routing/route_gen.dart`.

## Localization
None. Splash screen contains only the brand image asset.

## Analytics
None.

## Platform Impact
Pure Dart/Flutter assets and widgets; zero platform channel changes.

## Build Config
Added `assets/images/` path to `flutter.assets` in `pubspec.yaml`.

## Code Generation
Executed `dart run build_runner build --delete-conflicting-outputs` to regenerate `lib/core/di/injection.config.dart`.

## Testing
- `test/features/splash/presentation/splash_cubit_test.dart`:
  - Verified initial state is `SplashStates`.
  - Verified `InitSplashAction` emits `NavigateToLoginScreen` after 3 seconds.
  - Verified `InitSplashAction` does not emit navigation when cubit is closed before 3 seconds.
- `test/features/splash/presentation/splash_page_test.dart`:
  - Verified `SplashPage` renders `AppAssets.splashScreen` with `BoxFit.cover`.
  - Verified `SplashPage` navigates to `LoginPage` upon timer expiration.
- All 14 tests in test suite pass (`flutter test`).

## Known Limitations / Follow-ups
`LoginPage` is currently a placeholder screen until authentication feature implementation is completed.
