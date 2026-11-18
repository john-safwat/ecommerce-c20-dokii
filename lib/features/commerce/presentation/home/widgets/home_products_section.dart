import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/widgets/home_product_card.dart';

class HomeProductsSection extends StatelessWidget {
  final String title;
  final List<ProductEntity> products;

  const HomeProductsSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Text(title, style: context.text.titleMedium),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 256,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) => HomeProductCard(
              key: ValueKey(products[index].id),
              product: products[index],
            ),
          ),
        ),
      ],
    );
  }
}
