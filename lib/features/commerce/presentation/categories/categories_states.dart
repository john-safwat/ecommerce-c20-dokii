import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';

class CategoriesStates {
  final Resources<List<CategoryEntity>> categoriesResource;
  final String? selectedCategoryId;
  final Map<String, Resources<List<SubCategoryEntity>>> subCategoriesByCategory;

  CategoriesStates({
    Resources<List<CategoryEntity>>? categoriesResource,
    this.selectedCategoryId,
    Map<String, Resources<List<SubCategoryEntity>>>? subCategoriesByCategory,
  }) : categoriesResource = categoriesResource ?? Resources.init(),
       subCategoriesByCategory = subCategoriesByCategory ?? const {};

  CategoryEntity? get selectedCategory {
    final categories = categoriesResource.data;
    if (categories == null || categories.isEmpty) return null;
    if (selectedCategoryId == null) return categories.first;
    for (final category in categories) {
      if (category.id == selectedCategoryId) return category;
    }
    return categories.first;
  }

  Resources<List<SubCategoryEntity>> get currentSubCategoriesResource {
    final id = selectedCategoryId;
    if (id == null) return Resources.init();
    return subCategoriesByCategory[id] ?? Resources.init();
  }

  CategoriesStates copyWith({
    Resources<List<CategoryEntity>>? categoriesResource,
    String? selectedCategoryId,
    Map<String, Resources<List<SubCategoryEntity>>>? subCategoriesByCategory,
  }) {
    return CategoriesStates(
      categoriesResource: categoriesResource ?? this.categoriesResource,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      subCategoriesByCategory:
          subCategoriesByCategory ?? this.subCategoriesByCategory,
    );
  }
}

sealed class CategoriesAction {
  const CategoriesAction();
}

class LoadCategoriesAction extends CategoriesAction {
  const LoadCategoriesAction();
}

class SelectCategoryAction extends CategoriesAction {
  final String categoryId;

  const SelectCategoryAction(this.categoryId);
}

class RetrySubCategoriesAction extends CategoriesAction {
  const RetrySubCategoriesAction();
}

class ShopNowTappedAction extends CategoriesAction {
  final CategoryEntity category;

  const ShopNowTappedAction(this.category);
}

class SubCategoryTappedAction extends CategoriesAction {
  final SubCategoryEntity subCategory;

  const SubCategoryTappedAction(this.subCategory);
}

sealed class CategoriesNavigationAction {
  const CategoriesNavigationAction();
}

class ShowCategoriesErrorToast extends CategoriesNavigationAction {
  final String message;

  const ShowCategoriesErrorToast(this.message);
}

class NavigateToCategoryProducts extends CategoriesNavigationAction {
  final CategoryEntity category;

  const NavigateToCategoryProducts(this.category);
}

class NavigateToSubCategoryProducts extends CategoriesNavigationAction {
  final SubCategoryEntity subCategory;

  const NavigateToSubCategoryProducts(this.subCategory);
}
