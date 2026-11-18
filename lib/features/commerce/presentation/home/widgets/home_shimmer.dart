import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class HomeShimmer extends StatefulWidget {
  const HomeShimmer({super.key});

  @override
  State<HomeShimmer> createState() => _HomeShimmerState();
}

class _HomeShimmerState extends State<HomeShimmer>
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
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBox(height: 200, radius: 15, color: skeletonColor),
            const SizedBox(height: 24),
            _SkeletonBox(
              width: 120,
              height: 20,
              radius: 8,
              color: skeletonColor,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (_) => _SkeletonBox(
                  width: 72,
                  height: 72,
                  radius: 36,
                  color: skeletonColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SkeletonBox(
              width: 150,
              height: 20,
              radius: 8,
              color: skeletonColor,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SkeletonBox(
                    height: 220,
                    radius: 15,
                    color: skeletonColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SkeletonBox(
                    height: 220,
                    radius: 15,
                    color: skeletonColor,
                  ),
                ),
              ],
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
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
