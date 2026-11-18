import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/paginated_products_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';

class GetPaginatedProductsParams {
  final String? categoryId;
  final int page;
  final int limit;
  final String? keyword;

  const GetPaginatedProductsParams({
    this.categoryId,
    this.page = 1,
    this.limit = 20,
    this.keyword,
  });
}

@injectable
class GetPaginatedProductsUseCase {
  final CommerceRepo _repo;

  GetPaginatedProductsUseCase(this._repo);

  Future<Result<PaginatedProductsEntity>> call(
    GetPaginatedProductsParams params,
  ) {
    return _repo.getPaginatedProducts(
      categoryId: params.categoryId,
      page: params.page,
      limit: params.limit,
      keyword: params.keyword,
    );
  }
}
