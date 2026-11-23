# Token Header Interceptor (`TokenInterceptor`)

**Date:** 2026-11-18

## Summary

Added `TokenInterceptor` to `lib/core/network/token_interceptor.dart` to read the persisted `'token'` from `SharedPreferences` and attach it as the `token` request header on every outgoing `Dio` request when present and non-empty. Wired `TokenInterceptor` into `AppModule.provideDio` ahead of `PrettyDioLogger` and `ChuckerDioInterceptor`, regenerated DI, updated `docs/08-dependency-injection.md`, and added unit tests.

## Files Changed

- **Created:** `lib/core/network/token_interceptor.dart` — `@lazySingleton` `TokenInterceptor extends Interceptor` reading `'token'` from `SharedPreferences` and setting `options.headers['token']`.
- **Modified:** `lib/core/di/app_module.dart` — injected `TokenInterceptor` into `provideDio(TokenInterceptor tokenInterceptor)` and added it to `dio.interceptors` before `PrettyDioLogger` and `ChuckerDioInterceptor`.
- **Regenerated:** `lib/core/di/injection.config.dart` — registered `TokenInterceptor` and updated `Dio` factory call via `build_runner`.
- **Created:** `test/core/network/token_interceptor_test.dart` — unit tests covering non-empty token, missing token, and whitespace-only token.
- **Modified:** `docs/08-dependency-injection.md` — documented `TokenInterceptor` and `Dio` core bindings.
- **Modified:** `docs/walkthroughs/README.md` — added index entry.

## API Changes

- None (attaches existing `token` header expected by Route E-Commerce API endpoints).

## Widgets

- None.

## DI

- Registered `TokenInterceptor` (`@lazySingleton`) and updated `AppModule.provideDio(TokenInterceptor)` in `lib/core/di/injection.config.dart` via `dart run build_runner build --delete-conflicting-outputs`.

## Routing / Localization / Analytics / Platform / Build Config

- None.

## Code Generation

- `dart run build_runner build --delete-conflicting-outputs`

## Testing

- `test/core/network/token_interceptor_test.dart`: 3 unit tests verifying header attachment and `handler.next(options)` invocation.
- Ran `dart format --set-exit-if-changed .`, `flutter analyze`, and `flutter test`.

## Known Limitations / Follow-ups

- Token is read from `SharedPreferences` (`'token'`) to match `AuthRepoImpl` and `SplashLocalDataSourceImpl`; migrating to `SecureStorage` and `RefreshInterceptor` remains a future security hardening task per `AGENTS.md` §7 & §14.
