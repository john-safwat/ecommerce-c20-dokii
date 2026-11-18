import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class ProductDetailsShimmer extends StatefulWidget {
  const ProductDetailsShimmer({super.key});

  @override
  State<ProductDetailsShimmer> createState() => _ProductDetailsShimmerState();
}

class _ProductDetailsShimmerState extends State<ProductDetailsShimmer>
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
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBox(height: 300, radius: 15, color: skeletonColor),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonBox(
                  width: 180,
                  height: 22,
                  radius: 6,
                  color: skeletonColor,
                ),
                _SkeletonBox(
                  width: 90,
                  height: 22,
                  radius: 6,
                  color: skeletonColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonBox(
                  width: 170,
                  height: 34,
                  radius: 17,
                  color: skeletonColor,
                ),
                _SkeletonBox(
                  width: 110,
                  height: 38,
                  radius: 19,
                  color: skeletonColor,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SkeletonBox(
              width: 110,
              height: 20,
              radius: 6,
              color: skeletonColor,
            ),
            const SizedBox(height: 10),
            _SkeletonBox(height: 14, radius: 6, color: skeletonColor),
            const SizedBox(height: 8),
            _SkeletonBox(
              width: 240,
              height: 14,
              radius: 6,
              color: skeletonColor,
            ),
            const SizedBox(height: 24),
            _SkeletonBox(
              width: 70,
              height: 20,
              radius: 6,
              color: skeletonColor,
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12),
                  child: _SkeletonBox(
                    width: 38,
                    height: 38,
                    radius: 19,
                    color: skeletonColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  final Color color;

  const _SkeletonBox({
    this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
