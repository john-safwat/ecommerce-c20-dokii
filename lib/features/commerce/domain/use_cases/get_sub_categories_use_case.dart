import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';

@injectable
class GetSubCategoriesUseCase {
  final CommerceRepo repo;

  GetSubCategoriesUseCase(this.repo);

  Future<Result<List<SubCategoryEntity>>> call(String categoryId) {
    return repo.getSubCategories(categoryId);
  }
}
