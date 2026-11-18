import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_sub_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_states.dart';

@injectable
class CategoriesCubit
    extends
        BaseCubit<
          CategoriesStates,
          CategoriesAction,
          CategoriesNavigationAction
        > {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;

  CategoriesCubit(this._getCategoriesUseCase, this._getSubCategoriesUseCase)
    : super(CategoriesStates());

  @override
  Future<void> doAction(CategoriesAction action) async {
    switch (action) {
      case LoadCategoriesAction():
        await _loadCategories();
      case SelectCategoryAction(:final categoryId):
        await _selectCategory(categoryId);
      case RetrySubCategoriesAction():
        final id = state.selectedCategoryId;
        if (id != null) {
          await _loadSubCategories(id, force: true);
        }
      case ShopNowTappedAction(:final category):
        emitNavigation(NavigateToCategoryProducts(category));
      case SubCategoryTappedAction(:final subCategory):
        emitNavigation(NavigateToSubCategoryProducts(subCategory));
    }
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(categoriesResource: Resources.loading()));
    final result = await _getCategoriesUseCase();
    if (isClosed) return;

    switch (result) {
      case Success<List<CategoryEntity>>():
        final categories = result.data ?? const [];
        final firstId = categories.isNotEmpty ? categories.first.id : null;
        emit(
          state.copyWith(
            categoriesResource: Resources.success(categories),
            selectedCategoryId: firstId,
          ),
        );
        if (firstId != null) {
          await _loadSubCategories(firstId);
        }
      case Failure<List<CategoryEntity>>():
        emit(
          state.copyWith(categoriesResource: Resources.error(result.message)),
        );
        emitNavigation(ShowCategoriesErrorToast(result.message));
    }
  }

  Future<void> _selectCategory(String categoryId) async {
    if (state.selectedCategoryId == categoryId) return;
    emit(state.copyWith(selectedCategoryId: categoryId));
    await _loadSubCategories(categoryId);
  }

  Future<void> _loadSubCategories(
    String categoryId, {
    bool force = false,
  }) async {
    final existing = state.subCategoriesByCategory[categoryId];
    if (!force &&
        existing != null &&
        (existing.status == Status.success ||
            existing.status == Status.loading)) {
      return;
    }

    _emitSubCategoriesResource(categoryId, Resources.loading());
    final result = await _getSubCategoriesUseCase(categoryId);
    if (isClosed) return;

    switch (result) {
      case Success<List<SubCategoryEntity>>():
        _emitSubCategoriesResource(
          categoryId,
          Resources.success(result.data ?? const []),
        );
      case Failure<List<SubCategoryEntity>>():
        _emitSubCategoriesResource(categoryId, Resources.error(result.message));
        emitNavigation(ShowCategoriesErrorToast(result.message));
    }
  }

  void _emitSubCategoriesResource(
    String categoryId,
    Resources<List<SubCategoryEntity>> resource,
  ) {
    final updated = Map<String, Resources<List<SubCategoryEntity>>>.from(
      state.subCategoriesByCategory,
    )..[categoryId] = resource;
    emit(state.copyWith(subCategoriesByCategory: updated));
  }
}
