import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/common_ui/app_button.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/widgets/categories_shimmer.dart';

class SubCategoriesGridView extends StatelessWidget {
  final CategoryEntity category;
  final Resources<List<SubCategoryEntity>> subCategoriesResource;
  final VoidCallback onShopNowTap;
  final ValueChanged<SubCategoryEntity> onSubCategoryTap;
  final VoidCallback onRetrySubCategories;

  const SubCategoriesGridView({
    super.key,
    required this.category,
    required this.subCategoriesResource,
    required this.onShopNowTap,
    required this.onSubCategoryTap,
    required this.onRetrySubCategories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.titleSmall?.copyWith(
              color: context.colors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _CategoryBannerCard(category: category, onShopNowTap: onShopNowTap),
          const SizedBox(height: 20),
          _buildSubCategoriesContent(context),
        ],
      ),
    );
  }

  Widget _buildSubCategoriesContent(BuildContext context) {
    switch (subCategoriesResource.status) {
      case Status.initial:
      case Status.loading:
        return const SubCategoriesGridShimmer();
      case Status.error:
        return _SubCategoriesError(
          message:
              subCategoriesResource.message ??
              context.locale.failedToLoadSubCategories,
          onRetry: onRetrySubCategories,
        );
      case Status.success:
        final items = subCategoriesResource.data ?? const [];
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 32),
            child: Center(
              child: Text(
                context.locale.noSubCategories,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.secondary,
                ),
              ),
            ),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) => _SubCategoryTile(
            key: ValueKey(items[index].id),
            subCategory: items[index],
            onTap: () => onSubCategoryTap(items[index]),
          ),
        );
    }
  }
}

class _CategoryBannerCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onShopNowTap;

  const _CategoryBannerCard({
    required this.category,
    required this.onShopNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              category.image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: context.colors.primary.withValues(alpha: 0.12),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [
                    context.colors.surface.withValues(alpha: 0.88),
                    context.colors.surface.withValues(alpha: 0.25),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall?.copyWith(
                      color: context.colors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onShopNowTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        context.locale.shopNow,
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubCategoryTile extends StatelessWidget {
  final SubCategoryEntity subCategory;
  final VoidCallback onTap;

  const _SubCategoryTile({
    super.key,
    required this.subCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: subCategory.image.isNotEmpty
                  ? Image.network(
                      subCategory.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.category_outlined,
                        color: context.colors.primary,
                        size: 28,
                      ),
                    )
                  : Icon(
                      Icons.category_outlined,
                      color: context.colors.primary,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subCategory.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubCategoriesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SubCategoriesError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: context.colors.error),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 140,
              child: AppButton(
                label: context.locale.retry,
                height: 44,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
