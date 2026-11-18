# Initialize Home Screen Cubit, State, and Actions

**Date**: 2026-11-18

## Summary
Initialized `HomeCubit`, `HomeStates`, `HomeAction`, and `HomeNavigationAction` under `lib/features/commerce/presentation/home/` to load home screen sections via `GetHomeDataUseCase`. `HomeStates` holds `List<Resources<HomeSections>>`, mapping each `Result<HomeSections>` returned by `GetHomeDataUseCase` into `Resources.success(...)` or `Resources.error(...)`.

## Files Changed
- Created `lib/features/commerce/presentation/home/home_states.dart`
- Created `lib/features/commerce/presentation/home/home_cubit.dart`
- Updated `lib/core/di/injection.config.dart` (via `build_runner`)
- Created `test/features/commerce/presentation/home/home_cubit_test.dart`
- Created `docs/walkthroughs/2026-11-18_home-cubit-init.md`
- Updated `docs/walkthroughs/README.md`

## API Changes
None (consumes existing `GetHomeDataUseCase`).

## Widgets
None (`HomePage` UI wiring deferred).

## DI
Registered `@injectable HomeCubit` in `lib/core/di/injection.config.dart` via `dart run build_runner build --delete-conflicting-outputs`.

## Routing
None.

## Localization
None (no UI strings added; fallback error toast message is `'Failed to load home data'`).

## Analytics
None.

## Platform Impact
Dart only.

## Build Config
None.

## Code Generation
Re-ran `dart run build_runner build --delete-conflicting-outputs`.

## Testing
Added `test/features/commerce/presentation/home/home_cubit_test.dart` covering initial state, loading -> mapped `Success`/`Failure` resources, empty results with `ShowHomeErrorToast`, and closed-cubit safety (4/4 tests passing).

## Known Limitations / Follow-ups
- Wire `HomePage` to `HomeCubit` (`BlocProvider.value`, `navStream`, and section list rendering).
- Localize the empty-results error message in `ShowHomeErrorToast` when wiring the UI.
