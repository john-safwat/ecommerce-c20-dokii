import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_states.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/widgets/categories_shimmer.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/widgets/categories_side_rail.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/widgets/sub_categories_grid_view.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_header.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_args.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoriesCubit _cubit = getIt<CategoriesCubit>();
  StreamSubscription<CategoriesNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navStream.listen(_handleNavigation);
    _cubit.doAction(const LoadCategoriesAction());
  }

  void _handleNavigation(CategoriesNavigationAction event) {
    if (!mounted) return;
    switch (event) {
      case ShowCategoriesErrorToast(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: context.colors.error,
          ),
        );
      case NavigateToCategoryProducts(:final category):
        Navigator.pushNamed(
          context,
          AppRoutes.productsList,
          arguments: ProductsListArgs(
            categoryId: category.id,
            categoryName: category.name,
          ),
        );
      case NavigateToSubCategoryProducts(:final subCategory):
        Navigator.pushNamed(
          context,
          AppRoutes.productsList,
          arguments: ProductsListArgs(
            categoryId: subCategory.categoryId,
            categoryName: subCategory.name,
          ),
        );
    }
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<CategoriesCubit, CategoriesStates>(
                  builder: _buildBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CategoriesStates state) {
    final resource = state.categoriesResource;
    switch (resource.status) {
      case Status.initial:
      case Status.loading:
        return const CategoriesShimmer();
      case Status.error:
        return _CategoriesErrorView(
          message: resource.message ?? context.locale.failedToLoadCategories,
          onRetry: () => _cubit.doAction(const LoadCategoriesAction()),
        );
      case Status.success:
        final categories = resource.data ?? const [];
        final selectedCategory = state.selectedCategory;
        if (categories.isEmpty || selectedCategory == null) {
          return Center(
            child: Text(
              context.locale.noCategories,
              style: context.text.bodyLarge,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: CategoriesSideRail(
                  categories: categories,
                  selectedCategoryId: selectedCategory.id,
                  onCategorySelected: (id) =>
                      _cubit.doAction(SelectCategoryAction(id)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 7,
                child: SubCategoriesGridView(
                  category: selectedCategory,
                  subCategoriesResource: state.currentSubCategoriesResource,
                  onShopNowTap: () =>
                      _cubit.doAction(ShopNowTappedAction(selectedCategory)),
                  onSubCategoryTap: (sub) =>
                      _cubit.doAction(SubCategoryTappedAction(sub)),
                  onRetrySubCategories: () =>
                      _cubit.doAction(const RetrySubCategoriesAction()),
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _CategoriesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CategoriesErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 180,
              child: AppButton(
                label: context.locale.retry,
                height: 48,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
