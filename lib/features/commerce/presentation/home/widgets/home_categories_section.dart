import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';

class HomeCategoriesSection extends StatelessWidget {
  final String title;
  final List<CategoryEntity> categories;
  final VoidCallback? onViewAllTap;
  final ValueChanged<CategoryEntity>? onCategoryTap;

  const HomeCategoriesSection({
    super.key,
    required this.title,
    required this.categories,
    this.onViewAllTap,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.text.titleMedium),
              TextButton(
                onPressed: onViewAllTap,
                child: Text(
                  context.locale.viewAll,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (context, index) => _CategoryTile(
              category: categories[index],
              onTap: onCategoryTap == null
                  ? null
                  : () => onCategoryTap!(categories[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback? onTap;

  const _CategoryTile({required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.outline.withValues(alpha: 0.15),
            ),
            child: ClipOval(
              child: Image.network(
                category.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.category_outlined,
                  color: context.colors.primary,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
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
