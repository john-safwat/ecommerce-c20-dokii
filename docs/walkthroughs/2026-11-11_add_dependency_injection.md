# Walkthrough — Add Dependency Injection (`get_it` & `injectable`)

- **Date:** 2026-11-11
- **Author:** Route E-Commerce Team

---

## Summary

Integrated dependency injection using `get_it` and `injectable` into the project. Configured the root service locator in `lib/core/di/injection.dart`, created a barrel export file `lib/core/di/di.dart`, generated the dependency configuration via `build_runner`, and wired asynchronous dependency initialization into `lib/main.dart` at startup.

---

## Details

- **Files changed:**
  - `pubspec.yaml` (added `get_it`, `injectable`, `injectable_generator`, `build_runner`)
  - `pubspec.lock` (updated dependencies)
  - `lib/core/di/injection.dart` (created DI locator and initialization function)
  - `lib/core/di/injection.config.dart` (generated DI config)
  - `lib/core/di/di.dart` (created barrel export)
  - `lib/main.dart` (initialized DI with `WidgetsFlutterBinding.ensureInitialized()` and `await configureDependencies()`)
  - `test/core/di/injection_test.dart` (added unit test for DI configuration)
  - `docs/08-dependency-injection.md` (created DI documentation)
  - `docs/README.md` (created documentation index)
  - `docs/walkthroughs/README.md` (updated walkthrough index)
  - `docs/walkthroughs/2026-11-11_add_dependency_injection.md` (created this walkthrough)
- **API changes:** None.
- **Widgets:** None.
- **DI:** Configured `getIt` locator and `@InjectableInit()` `configureDependencies()`; generated `injection.config.dart`.
- **Routing:** None.
- **Localization:** None.
- **Analytics:** None.
- **Platform impact:** Pure Dart; no native Android/iOS changes.
- **Build config:** Added code generator `build_runner` and `injectable_generator` to `dev_dependencies`.
- **Code generation:** Ran `dart run build_runner build --delete-conflicting-outputs` generating `lib/core/di/injection.config.dart`.
- **Testing:** Added unit test `test/core/di/injection_test.dart` verifying `configureDependencies()` and `getIt` initialization. All tests passing (2 passed).
- **Known limitations / follow-ups:** Ready to register feature-level dependencies (data sources, repositories, use cases, and screen cubits) as features are built.
