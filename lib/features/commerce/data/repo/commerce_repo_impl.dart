import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/network/safe_call.dart';
import 'package:route_ecommerce/features/commerce/data/data_source/commerce_api_client.dart';
import 'package:route_ecommerce/features/commerce/data/data_source/commerce_local_data_source.dart';
import 'package:route_ecommerce/features/commerce/data/mapper/commerce_mapper.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/paginated_products_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceApiClient _apiClient;
  final CommerceLocalDataSource _localDataSource;
  final CommerceMapper _mapper;

  CommerceRepoImpl(this._apiClient, this._localDataSource, this._mapper);

  @override
  Future<Result<List<BannerEntity>>> getBanners() {
    return safeCall(() async {
      final response = await _localDataSource.getBanners();
      final banners = (response.banners ?? [])
          .map(_mapper.bannerDtoToEntity)
          .toList();
      return Success(banners);
    });
  }

  @override
  Future<Result<List<CategoryEntity>>> getCategories() {
    return safeCall(() async {
      final response = await _apiClient.getCategories();
      final categories = (response.data ?? [])
          .map(_mapper.categoryDtoToEntity)
          .toList();
      return Success(categories);
    });
  }

  @override
  Future<Result<List<SubCategoryEntity>>> getSubCategories(String categoryId) {
    return safeCall(() async {
      final response = await _apiClient.getSubCategoriesOnCategory(categoryId);
      final subCategories = (response.data ?? [])
          .map(_mapper.subCategoryDtoToEntity)
          .toList();
      return Success(subCategories);
    });
  }

  @override
  Future<Result<List<ProductEntity>>> getProducts(String categoryId) {
    return safeCall(() async {
      final response = await _apiClient.getProducts(
        categoryId: categoryId.isEmpty ? null : categoryId,
      );
      final products = (response.data ?? [])
          .map(_mapper.productDtoToEntity)
          .toList();
      return Success(products);
    });
  }

  @override
  Future<Result<PaginatedProductsEntity>> getPaginatedProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
    String? keyword,
  }) {
    return safeCall(() async {
      final normalizedCategoryId = (categoryId == null || categoryId.isEmpty)
          ? null
          : categoryId;
      final normalizedKeyword = (keyword == null || keyword.trim().isEmpty)
          ? null
          : keyword.trim();
      final response = await _apiClient.getProducts(
        categoryId: normalizedCategoryId,
        page: page,
        limit: limit,
        keyword: normalizedKeyword,
      );
      return Success(_mapper.productsResponseToPaginatedEntity(response));
    });
  }

  @override
  Future<Result<ProductDetailsEntity>> getProductDetails(String productId) {
    return safeCall(() async {
      final response = await _apiClient.getProductDetails(productId);
      final dto = response.data;
      if (dto == null) {
        return Failure('Product not found');
      }
      return Success(_mapper.productDtoToDetailsEntity(dto));
    });
  }
}
