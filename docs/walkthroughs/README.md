# Walkthroughs History

Index of feature implementations, refactors, and architectural updates.

- **2026-11-11**: [Add Dependency Injection (`get_it` & `injectable`)](2026-11-11_add_dependency_injection.md) — Configured `get_it` and `injectable` in `lib/core/di/`, updated `lib/main.dart`, generated DI configuration, and documented DI conventions.
- **2026-11-11**: [Implement LocaleProvider with ChangeNotifier and SharedPreferences in Dependency Injection](2026-11-11_implement_locale_provider_and_di.md) — Implemented `LocaleProvider` backed by `SharedPreferences` in DI, updated `MyApp` with `ChangeNotifierProvider.value`, and added unit and widget test suites.
- **2026-11-11**: [Add Light AppColors and AppTheme with DI](2026-11-11_add_app_theme.md) — Created `AppColors` (`LightColors`) and `AppTheme` under `lib/core/theme/`, registered them in DI, wired `getIt<AppTheme>().theme` in `MyApp`, and documented theme tokens in `docs/04-theme-and-ui-components.md`.
- **2026-11-11**: [Implement Splash Screen](2026-11-11_implement_splash_screen.md) — Added splash screen assets, clean architecture cubit and view with 3s timer, `AppRoutes.login` and placeholder `LoginPage`, DI registrations, and test coverage.
- **2026-11-15**: [Implement `errorParser` and Fix `safeCall` Async Handling](2026-11-15_error-parser.md) — Implemented `errorParser<T>` in `lib/core/network/safe_call.dart` for all `DioExceptionType` cases, API `message` extraction, and standard/platform exceptions, fixed `await call()` in `safeCall<T>`, and added unit tests.
- **2026-11-15**: [Auth Login & Register UI, Validation, and Register Cubit Template](2026-11-15_auth-login-register-ui.md) — Built Login and Register UIs with `AppTextField`, `AppButton`, and `RouteLogo`, added `phoneValidation` to `Validator`, connected `LoginPage` to `LoginCubit`, and created the `RegisterCubit` template.
- **2026-11-15**: [Splash Auto-Login (SharedPreferences Token Check)](2026-11-15_splash-auto-login.md) — Implemented the Clean Architecture auto-login cycle in `features/splash/` (`SplashLocalDataSource`, `SplashRepo`, `CheckTokenUseCase`, `SplashCubit`, `SplashPage`), regenerated DI, and added unit and widget tests.
