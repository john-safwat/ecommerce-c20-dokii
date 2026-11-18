import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart';

@injectable
class GetCategoriesUseCase {
  final CommerceRepo repo;

  GetCategoriesUseCase(this.repo);

  Future<Result<List<CategoryEntity>>> call() async {
    return await repo.getCategories();
  }
}
