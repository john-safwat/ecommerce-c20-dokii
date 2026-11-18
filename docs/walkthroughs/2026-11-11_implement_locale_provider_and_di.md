# Walkthrough — Implement LocaleProvider with ChangeNotifier and SharedPreferences in Dependency Injection

- **Date:** 2026-11-11
- **Author:** Route E-Commerce Team

---

## Summary

Implemented `LocaleProvider` extending `ChangeNotifier` to manage the active application locale with persistence backed by `SharedPreferences`. Configured `SharedPreferences` in Dependency Injection via an `@module` abstract class with `@preResolve`, registered `LocaleProvider` as a `@lazySingleton` receiving `SharedPreferences` via constructor injection, and regenerated DI configuration with `build_runner`. Refactored `MyApp` in `lib/main.dart` into a `StatelessWidget` wrapped with `ChangeNotifierProvider.value` consuming `getIt<LocaleProvider>()`, and added comprehensive unit and widget tests.

---

## Details

- **Files changed:**
  - `pubspec.yaml` (added `provider: ^6.1.2` and `shared_preferences: ^2.3.2`)
  - `pubspec.lock` (resolved dependencies)
  - `lib/core/di/app_module.dart` (created third-party module registering `@preResolve Future<SharedPreferences>`)
  - `lib/core/di/di.dart` (re-exported `app_module.dart`)
  - `lib/core/di/injection.dart` (updated `configureDependencies` to await `getIt.init()`)
  - `lib/core/di/injection.config.dart` (regenerated injectable graph with `SharedPreferences` factoryAsync and `LocaleProvider` lazySingleton)
  - `lib/core/l10n/locale_provider.dart` (created `LocaleProvider` with persistence, getters, `setLocale`, and `toggleLocale`)
  - `lib/main.dart` (refactored `MyApp` to `StatelessWidget` with `ChangeNotifierProvider.value` and `Consumer<LocaleProvider>`)
  - `test/core/di/injection_test.dart` (verified DI resolves `SharedPreferences` and `LocaleProvider`)
  - `test/core/l10n/locale_provider_test.dart` (created unit test suite for `LocaleProvider`)
  - `test/widget_test.dart` (updated widget test verifying `MaterialApp` locale binding and runtime update)
  - `docs/08-dependency-injection.md` (documented `AppModule`, `@preResolve`, and `LocaleProvider`)
  - `docs/walkthroughs/README.md` (updated walkthrough index)
  - `docs/walkthroughs/2026-11-11_implement_locale_provider_and_di.md` (created this walkthrough)
- **API changes:** None.
- **Widgets:** `MyApp` updated from `StatefulWidget` to `StatelessWidget`, wrapped with `ChangeNotifierProvider.value` and `Consumer<LocaleProvider>`. Provided static `MyApp.setLocale(context, newLocale)` delegating to `LocaleProvider.setLocale`.
- **DI:**
  - Created `AppModule` with `@preResolve Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();`.
  - Annotated `LocaleProvider` with `@lazySingleton`.
  - Regenerated `lib/core/di/injection.config.dart`.
- **Routing:** No route changes. `MaterialApp` preserves `onGenerateRoute: routeGen` and `initialRoute: AppRoutes.splash`.
- **Localization:** Locale managed dynamically via `LocaleProvider` with fallback `'en'`, persistent storage under key `'app_locale'`, and helper methods `isArabic`, `isEnglish`, `setLocale(newLocale)`, and `toggleLocale()`.
- **Analytics:** None.
- **Platform impact:** Standard Flutter platform channel integration for `shared_preferences`.
- **Build config:** Added `provider: ^6.1.2` and `shared_preferences: ^2.3.2`.
- **Code generation:** Ran `dart run build_runner build --delete-conflicting-outputs`.
- **Testing:**
  - `test/core/l10n/locale_provider_test.dart`: 5 tests covering initial default locale, saved locale initialization, `setLocale` updates and notifications, duplicate locale no-op, and `toggleLocale`.
  - `test/core/di/injection_test.dart`: 1 test verifying `SharedPreferences` and `LocaleProvider` registration in GetIt.
  - `test/widget_test.dart`: 1 test verifying `MyApp` renders `MaterialApp` with locale from `LocaleProvider` and reflects dynamic locale changes.
  - All 7 tests passing.
- **Known limitations / follow-ups:** Ready to be consumed by UI language-picker widgets and future feature screens.
