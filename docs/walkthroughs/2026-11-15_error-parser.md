# Implement `errorParser` and Fix `safeCall` Async Handling

**Date:** 2026-11-15

## Summary
Implemented `errorParser<T>(Exception e)` in `lib/core/network/safe_call.dart` to map all `DioExceptionType` variants, API `message` error payloads (`Map` and JSON `String`), HTTP status codes, and standard Dart/platform exceptions (`SocketException`, `TimeoutException`, `FormatException`, `HttpException`, `HandshakeException`, `PlatformException`) into `Failure<T>`. Also updated `safeCall<T>` to `await call()` inside `try` and safely handle non-`Exception` errors.

## Files Changed
- `lib/core/network/safe_call.dart` (modified) — implemented `errorParser<T>`, added `await` in `safeCall<T>`, removed unused `user_entity.dart` import.
- `test/core/network/safe_call_test.dart` (created) — unit tests for `safeCall` and all `errorParser` branches.
- `docs/walkthroughs/2026-11-15_error-parser.md` (created) — walkthrough entry.
- `docs/walkthroughs/README.md` (modified) — added index entry.

## API Changes
- None (extracts the existing `message` field from API error responses).

## Widgets / DI / Routing / Localization / Analytics / Platform / Build Config / Codegen
- None.

## Testing
- Added `test/core/network/safe_call_test.dart` (21 tests covering `safeCall`, all `DioExceptionType` values, `Map` and JSON `String` API `message` extraction, HTTP status code fallbacks, inner `DioException.unknown` errors, and non-Dio `Exception` types).
- Verified with `dart format --set-exit-if-changed`, `flutter analyze`, and `flutter test test/core/network/safe_call_test.dart`.

## Known Limitations / Follow-ups
- Error messages are currently English strings rather than localized keys; localize when network error keys are added to `app_en.arb`/`app_ar.arb`.
