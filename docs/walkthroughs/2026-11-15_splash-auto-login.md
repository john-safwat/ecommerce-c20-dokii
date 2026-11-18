# Splash Auto-Login (SharedPreferences Token Check)

**Date:** 2026-11-15

## Summary
Implemented the auto-login check in the `splash` feature using Clean Architecture (`data` → `domain` → `presentation`). On launch, `SplashCubit` waits for the 3-second splash delay, checks `SharedPreferences` for a non-empty `'token'` via `CheckTokenUseCase`, and navigates to `AppRoutes.home` if present or `AppRoutes.login` otherwise.

## Files Changed
- **Created** `lib/features/splash/data/data_source/splash_local_data_source.dart` (`SplashLocalDataSource`, `SplashLocalDataSourceImpl`)
- **Created** `lib/features/splash/data/repo/splash_repo_impl.dart` (`SplashRepoImpl`)
- **Created** `lib/features/splash/domain/repo/splash_repo.dart` (`SplashRepo`)
- **Created** `lib/features/splash/domain/use_cases/check_token_use_case.dart` (`CheckTokenUseCase`)
- **Modified** `lib/features/splash/presentation/view/splash_states.dart` (added `Resources<bool> hasToken` and `NavigateToHomeScreen`)
- **Modified** `lib/features/splash/presentation/view/splash_cubit.dart` (injected `CheckTokenUseCase`, branched navigation on token existence)
- **Modified** `lib/features/splash/presentation/view/splash_page.dart` (handled `NavigateToHomeScreen` → `AppRoutes.home`)
- **Regenerated** `lib/core/di/injection.config.dart`
- **Created** `test/features/splash/data/splash_local_data_source_test.dart`
- **Created** `test/features/splash/data/splash_repo_impl_test.dart`
- **Created** `test/features/splash/domain/check_token_use_case_test.dart`
- **Modified** `test/features/splash/presentation/splash_cubit_test.dart`
- **Modified** `test/features/splash/presentation/splash_page_test.dart`

## API Changes
None (local `SharedPreferences` check only).

## DI & Code Generation
Registered `SplashLocalDataSourceImpl`, `SplashRepoImpl`, `CheckTokenUseCase`, and updated `SplashCubit` via `injectable`. Re-ran `dart run build_runner build --delete-conflicting-outputs` to update `lib/core/di/injection.config.dart`.

## Routing
`SplashPage` now navigates to `AppRoutes.home` (`NavigateToHomeScreen`) when a saved token exists, or `AppRoutes.login` (`NavigateToLoginScreen`) otherwise.

## Testing
- Ran `flutter test` — all 58 tests pass (covering `SplashLocalDataSourceImpl`, `SplashRepoImpl`, `CheckTokenUseCase`, `SplashCubit`, and `SplashPage`).
- Ran `flutter analyze` — 0 errors; 0 issues in created/modified files (3 pre-existing warnings in unrelated files).
