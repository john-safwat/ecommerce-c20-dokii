import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/data/data_source/commerce_api_client.dart';
import 'package:route_ecommerce/features/commerce/data/data_source/commerce_local_data_source.dart';
import 'package:route_ecommerce/features/commerce/data/mapper/commerce_mapper.dart';
import 'package:route_ecommerce/features/commerce/data/models/banners_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/categories_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/products_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/sub_categories_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/repo/commerce_repo_impl.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/paginated_products_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';

class _FakeCommerceApiClient implements CommerceApiClient {
  CategoriesResponseDto? categoriesResponse;
  SubCategoriesResponseDto? subCategoriesResponse;
  ProductsResponseDto? productsResponse;
  Exception? errorToThrow;
  String? lastCategoryIdQuery;
  int? lastPageQuery;
  int? lastLimitQuery;
  String? lastKeywordQuery;
  String? lastSubCategoryCategoryId;

  @override
  Future<CategoriesResponseDto> getCategories() async {
    if (errorToThrow != null) throw errorToThrow!;
    return categoriesResponse ?? CategoriesResponseDto(data: []);
  }

  @override
  Future<SubCategoriesResponseDto> getSubCategoriesOnCategory(
    String categoryId,
  ) async {
    lastSubCategoryCategoryId = categoryId;
    if (errorToThrow != null) throw errorToThrow!;
    return subCategoriesResponse ?? SubCategoriesResponseDto(data: []);
  }

  @override
  Future<ProductsResponseDto> getProducts({
    String? categoryId,
    int? page,
    int? limit,
    String? keyword,
  }) async {
    lastCategoryIdQuery = categoryId;
    lastPageQuery = page;
    lastLimitQuery = limit;
    lastKeywordQuery = keyword;
    if (errorToThrow != null) throw errorToThrow!;
    return productsResponse ?? ProductsResponseDto(data: []);
  }

  @override
  Future<ProductDetailsResponseDto> getProductDetails(String productId) async {
    throw UnimplementedError();
  }
}

class _FakeCommerceLocalDataSource implements CommerceLocalDataSource {
  BannersResponseDto? bannersResponse;
  Exception? errorToThrow;

  @override
  Future<BannersResponseDto> getBanners() async {
    if (errorToThrow != null) throw errorToThrow!;
    return bannersResponse ?? BannersResponseDto(banners: []);
  }
}

void main() {
  late _FakeCommerceApiClient apiClient;
  late _FakeCommerceLocalDataSource localDataSource;
  late CommerceMapper mapper;
  late CommerceRepoImpl repo;

  setUp(() {
    apiClient = _FakeCommerceApiClient();
    localDataSource = _FakeCommerceLocalDataSource();
    mapper = CommerceMapper();
    repo = CommerceRepoImpl(apiClient, localDataSource, mapper);
  });

  group('CommerceRepoImpl', () {
    test('getBanners returns Success with mapped entities', () async {
      localDataSource.bannersResponse = BannersResponseDto(
        banners: [
          BannerDto(
            image: 'img.png',
            title: 'Sale',
            categoryName: 'Tech',
            alignment: 'start',
            buttonBackGroundColor: 0xFF000000,
            buttonForGroundColor: 0xFFFFFFFF,
          ),
        ],
      );

      final result = await repo.getBanners();

      expect(result, isA<Success<List<BannerEntity>>>());
      expect(result.data, hasLength(1));
      expect(result.data!.first.title, 'Sale');
    });

    test('getCategories returns Success with mapped categories', () async {
      apiClient.categoriesResponse = CategoriesResponseDto(
        data: [CategoryDto(id: '1', name: 'Music', image: 'music.png')],
      );

      final result = await repo.getCategories();

      expect(result, isA<Success<List<CategoryEntity>>>());
      expect(result.data, hasLength(1));
      expect(result.data!.first.name, 'Music');
    });

    test(
      'getSubCategories returns Success with mapped subcategories',
      () async {
        apiClient.subCategoriesResponse = SubCategoriesResponseDto(
          data: [
            SubCategoryDto(
              id: 's1',
              name: 'Dresses',
              slug: 'dresses',
              category: 'c1',
            ),
          ],
        );

        final result = await repo.getSubCategories('c1');

        expect(apiClient.lastSubCategoryCategoryId, 'c1');
        expect(result, isA<Success<List<SubCategoryEntity>>>());
        expect(result.data, hasLength(1));
        expect(result.data!.first.name, 'Dresses');
        expect(result.data!.first.categoryId, 'c1');
      },
    );

    test(
      'getProducts passes categoryId when non-empty and null when empty',
      () async {
        apiClient.productsResponse = ProductsResponseDto(
          data: [
            ProductDto(
              id: 'p1',
              title: 'Shawl',
              imageCover: 'shawl.png',
              ratingsAverage: 4.1,
              price: 149,
            ),
          ],
        );

        final filteredResult = await repo.getProducts('cat-123');
        expect(apiClient.lastCategoryIdQuery, 'cat-123');
        expect(filteredResult, isA<Success<List<ProductEntity>>>());
        expect(filteredResult.data!.first.name, 'Shawl');

        await repo.getProducts('');
        expect(apiClient.lastCategoryIdQuery, isNull);
      },
    );

    test(
      'getCategories wraps DioException into Failure via safeCall',
      () async {
        apiClient.errorToThrow = DioException(
          requestOptions: RequestOptions(path: '/api/v1/categories'),
          type: DioExceptionType.connectionError,
        );

        final result = await repo.getCategories();

        expect(result, isA<Failure<List<CategoryEntity>>>());
      },
    );

    test(
      'getPaginatedProducts passes pagination/filter queries and maps metadata',
      () async {
        apiClient.productsResponse = ProductsResponseDto(
          results: 1,
          metadata: PaginationMetadataDto(
            currentPage: 2,
            numberOfPages: 4,
            limit: 10,
            nextPage: 3,
          ),
          data: [
            ProductDto(
              id: 'p2',
              title: 'Sneakers',
              imageCover: 'sneakers.png',
              ratingsAverage: 4.8,
              price: 1200,
              priceAfterDiscount: 1000,
            ),
          ],
        );

        final result = await repo.getPaginatedProducts(
          categoryId: 'cat-9',
          page: 2,
          limit: 10,
          keyword: ' nike ',
        );

        expect(apiClient.lastCategoryIdQuery, 'cat-9');
        expect(apiClient.lastPageQuery, 2);
        expect(apiClient.lastLimitQuery, 10);
        expect(apiClient.lastKeywordQuery, 'nike');
        expect(result, isA<Success<PaginatedProductsEntity>>());
        expect(result.data!.currentPage, 2);
        expect(result.data!.numberOfPages, 4);
        expect(result.data!.nextPage, 3);
        expect(result.data!.hasMore, isTrue);
        expect(result.data!.products.single.name, 'Sneakers');
      },
    );
  });
}
