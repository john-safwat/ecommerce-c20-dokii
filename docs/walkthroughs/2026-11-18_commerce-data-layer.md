# Commerce Feature — Data Layer Implementation

**Date:** 2026-11-18

## Summary

Implemented the data layer for the `commerce` feature against the existing domain contracts (`CommerceRepo`, `BannerEntity`, `CategoryEntity`, `ProductEntity`), integrating the `/api/v1/categories` and `/api/v1/products` endpoints via Retrofit/Dio and loading local banners from `assets/files/banners.json`, with `safeCall` error handling, `injectable` DI registration, and unit tests.

## Files Changed

- `lib/features/commerce/data/models/categories_response_dto.dart` (created)
- `lib/features/commerce/data/models/products_response_dto.dart` (created)
- `lib/features/commerce/data/models/banners_response_dto.dart` (created)
- `lib/features/commerce/data/data_source/commerce_api_client.dart` (created)
- `lib/features/commerce/data/data_source/commerce_api_client.g.dart` (generated)
- `lib/features/commerce/data/data_source/commerce_local_data_source.dart` (created)
- `lib/features/commerce/data/mapper/commerce_mapper.dart` (created)
- `lib/features/commerce/data/repo/commerce_repo_impl.dart` (created)
- `lib/core/di/injection.config.dart` (regenerated)
- `test/features/commerce/data/commerce_mapper_test.dart` (created)
- `test/features/commerce/data/commerce_local_data_source_test.dart` (created)
- `test/features/commerce/data/commerce_repo_impl_test.dart` (created)

## API Changes

- `GET /api/v1/categories` via `CommerceApiClient.getCategories()`
- `GET /api/v1/products` with optional `@Query('category[in]') String? categoryId` via `CommerceApiClient.getProducts({String? categoryId})`

## DI

Registered `CommerceApiClient`, `CommerceLocalDataSourceImpl` (as `CommerceLocalDataSource`), `CommerceMapper`, and `CommerceRepoImpl` (as `CommerceRepo`) in `lib/core/di/injection.config.dart` via `dart run build_runner build`.

## Code Generation

Ran `dart run build_runner build` to generate `commerce_api_client.g.dart` and update `injection.config.dart`.

## Testing

- Added unit tests for `CommerceMapper`, `CommerceLocalDataSourceImpl`, and `CommerceRepoImpl` (8 tests total, all passing).
- Verified `dart format --set-exit-if-changed lib/features/commerce/data test/features/commerce/data` and `flutter analyze lib/features/commerce/data test/features/commerce/data` exit with 0 issues.
