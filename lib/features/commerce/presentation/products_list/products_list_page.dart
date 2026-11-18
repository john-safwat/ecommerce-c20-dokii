import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_header.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_product_card.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_args.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_states.dart';
import 'package:route_ecommerce/features/commerce/presentation/products_list/widgets/products_list_shimmer.dart';

class ProductsListPage extends StatefulWidget {
  final ProductsListArgs? args;

  const ProductsListPage({super.key, this.args});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  static const double _loadMoreThreshold = 200;

  final ProductsListCubit _cubit = getIt<ProductsListCubit>();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<ProductsListNavigationAction>? _navSub;

  @override
  void initState() {
    super.initState();
    _navSub = _cubit.navStream.listen(_handleNavigation);
    _scrollController.addListener(_onScroll);
    _cubit.doAction(
      LoadProductsAction(
        categoryId: widget.args?.categoryId,
        keyword: widget.args?.keyword,
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      _cubit.doAction(const LoadMoreProductsAction());
    }
  }

  void _handleNavigation(ProductsListNavigationAction event) {
    if (!mounted) return;
    switch (event) {
      case ShowProductsErrorToast(:final message):
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
            onRefresh: () => _cubit.doAction(const RefreshProductsAction()),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeader(
                    onSearchSubmitted: (keyword) =>
                        _cubit.doAction(SearchProductsAction(keyword)),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                BlocBuilder<ProductsListCubit, ProductsListStates>(
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

  Widget _buildBody(BuildContext context, ProductsListStates state) {
    final resource = state.productsResource;
    final products = resource.data ?? const <ProductEntity>[];

    if (resource.status == Status.loading ||
        resource.status == Status.initial) {
      return const SliverToBoxAdapter(child: ProductsListShimmer());
    }

    if (resource.status == Status.error && products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _ProductsErrorView(
          message: resource.message ?? context.locale.failedToLoadProducts,
          onRetry: () => _cubit.doAction(const RefreshProductsAction()),
        ),
      );
    }

    if (products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Text(
              context.locale.noProducts,
              style: context.text.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          sliver: SliverGrid.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) => HomeProductCard(
              key: ValueKey(products[index].id),
              product: products[index],
            ),
          ),
        ),
        if (state.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 16),
              child: ProductsListShimmer(itemCount: 2),
            ),
          ),
      ],
    );
  }
}

class _ProductsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProductsErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: context.text.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
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
