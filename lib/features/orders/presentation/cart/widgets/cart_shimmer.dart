import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class CartShimmer extends StatefulWidget {
  const CartShimmer({super.key});

  @override
  State<CartShimmer> createState() => _CartShimmerState();
}

class _CartShimmerState extends State<CartShimmer>
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
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, _) => _CartCardSkeleton(color: skeletonColor),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SkeletonBox(
                        width: 80,
                        height: 16,
                        radius: 6,
                        color: skeletonColor,
                      ),
                      const SizedBox(height: 8),
                      _SkeletonBox(
                        width: 100,
                        height: 20,
                        radius: 6,
                        color: skeletonColor,
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _SkeletonBox(
                      height: 48,
                      radius: 20,
                      color: skeletonColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartCardSkeleton extends StatelessWidget {
  final Color color;

  const _CartCardSkeleton({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 113,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 120, height: 113, radius: 15, color: color),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBox(width: 140, height: 18, radius: 6, color: color),
                  _SkeletonBox(width: 90, height: 14, radius: 6, color: color),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SkeletonBox(
                        width: 80,
                        height: 18,
                        radius: 6,
                        color: color,
                      ),
                      _SkeletonBox(
                        width: 96,
                        height: 32,
                        radius: 16,
                        color: color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
