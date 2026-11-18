import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/home_sections.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_states.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_banners_carousel.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_categories_section.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_header.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_products_section.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_shimmer.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_args.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCubit _cubit = getIt<HomeCubit>();
  StreamSubscription<HomeNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navStream.listen(_handleNavigation);
    _cubit.doAction(const LoadHomeDataAction());
  }

  void _handleNavigation(HomeNavigationAction event) {
    if (!mounted) return;
    switch (event) {
      case ShowHomeErrorToast(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: context.colors.error,
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
          child: RefreshIndicator(
            onRefresh: () => _cubit.doAction(const LoadHomeDataAction()),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: HomeHeader()),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                BlocBuilder<HomeCubit, HomeStates>(
                  builder: (context, state) => _buildBody(context, state),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeStates state) {
    final sections = state.homeSections;
    if (sections.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _HomeErrorView(
          message: context.locale.failedToLoadHomeData,
          onRetry: () => _cubit.doAction(const LoadHomeDataAction()),
        ),
      );
    }

    final isLoading = sections.any((item) => item.status == Status.loading);
    if (isLoading) {
      return const SliverToBoxAdapter(child: HomeShimmer());
    }

    return SliverList.separated(
      itemCount: sections.length,
      separatorBuilder: (_, _) => const SizedBox(height: 24),
      itemBuilder: (context, index) => _buildSectionItem(sections[index]),
    );
  }

  Widget _buildSectionItem(Resources<HomeSections> resource) {
    if (resource.status == Status.error) {
      return const SizedBox.shrink();
    }
    final section = resource.data;
    if (section == null) return const SizedBox.shrink();

    switch (section) {
      case BannersSection():
        return HomeBannersCarousel(banners: section.banners);
      case CategoriesSection():
        return HomeCategoriesSection(
          title: section.title,
          categories: section.categories,
          onCategoryTap: (category) {
            Navigator.pushNamed(
              context,
              AppRoutes.productsList,
              arguments: ProductsListArgs(
                categoryId: category.id,
                categoryName: category.name,
              ),
            );
          },
        );
      case ProductsListSection():
        if (section.products.isEmpty) {
          return const SizedBox.shrink();
        }
        return HomeProductsSection(
          title: section.title,
          products: section.products,
        );
    }
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeErrorView({required this.message, required this.onRetry});

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
