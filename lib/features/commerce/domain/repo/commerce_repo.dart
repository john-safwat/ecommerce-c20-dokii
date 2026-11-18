import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/paginated_products_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';

abstract interface class CommerceRepo {
  Future<Result<List<BannerEntity>>> getBanners();

  Future<Result<List<CategoryEntity>>> getCategories();

  Future<Result<List<SubCategoryEntity>>> getSubCategories(String categoryId);

  Future<Result<List<ProductEntity>>> getProducts(String categoryId);

  Future<Result<PaginatedProductsEntity>> getPaginatedProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
    String? keyword,
  });

  Future<Result<ProductDetailsEntity>> getProductDetails(String productId);
}
