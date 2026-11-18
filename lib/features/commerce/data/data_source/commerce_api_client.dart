import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:route_ecommerce/features/commerce/data/models/categories_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/products_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/sub_categories_response_dto.dart';

part 'commerce_api_client.g.dart';

@injectable
@RestApi()
abstract class CommerceApiClient {
  @factoryMethod
  factory CommerceApiClient(Dio dio) = _CommerceApiClient;

  @GET('/api/v1/categories')
  Future<CategoriesResponseDto> getCategories();

  @GET('/api/v1/categories/{categoryId}/subcategories')
  Future<SubCategoriesResponseDto> getSubCategoriesOnCategory(
    @Path('categoryId') String categoryId,
  );

  @GET('/api/v1/products')
  Future<ProductsResponseDto> getProducts({
    @Query('category[in]') String? categoryId,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('keyword') String? keyword,
  });

  @GET('/api/v1/products/{id}')
  Future<ProductDetailsResponseDto> getProductDetails(
    @Path('id') String productId,
  );
}
