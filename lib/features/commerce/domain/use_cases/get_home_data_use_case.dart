import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/home_sections.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_banners_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_products_use_case.dart';

@injectable
class GetHomeDataUseCase {
  GetBannersUseCase getBannersUseCase;
  GetProductsUseCase getProductsUseCase;
  GetCategoriesUseCase getCategoriesUseCase;

  GetHomeDataUseCase(
    this.getBannersUseCase,
    this.getProductsUseCase,
    this.getCategoriesUseCase,
  );

  Future<List<Result<HomeSections>>> call() async {
    List<Result<HomeSections>> homeSections = [];
    final banners = await getBannersUseCase();
    if (banners is Success) {
      homeSections.add(Success(BannersSection(0, banners.data ?? [])));
    }
    final categories = await getCategoriesUseCase();
    if (categories is Success) {
      final categoriesData = categories.data ?? [];
      homeSections.add(
        Success(CategoriesSection(1, categoriesData, "Categories")),
      );
      final random = Random();
      for (int i = 0; i < 4; i++) {
        final category = categoriesData[random.nextInt(categoriesData.length)];
        final products = await getProductsUseCase(category.id);
        if (products is Success) {
          if (products.data == null || products.data!.isEmpty) continue;
          homeSections.add(
            Success(
              ProductsListSection(2 + i, products.data ?? [], category.name),
            ),
          );
        }
      }
    }
    homeSections.sort((a, b) {
      final indexA = a is Success<HomeSections> ? a.data!.index : 0;
      final indexB = b is Success<HomeSections> ? b.data!.index : 0;
      return indexA.compareTo(indexB);
    });

    return homeSections;
  }
}
