import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class ProductsListShimmer extends StatefulWidget {
  final int itemCount;

  const ProductsListShimmer({super.key, this.itemCount = 6});

  @override
  State<ProductsListShimmer> createState() => _ProductsListShimmerState();
}

class _ProductsListShimmerState extends State<ProductsListShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skeletonColor = context.colors.outline.withValues(alpha: 0.25);

    return FadeTransition(
      opacity: Tween<double>(begin: 0.4, end: 0.9).animate(_controller),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        itemCount: widget.itemCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, _) => Container(
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
