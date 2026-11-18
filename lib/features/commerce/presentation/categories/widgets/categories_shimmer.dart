import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class CategoriesShimmer extends StatefulWidget {
  const CategoriesShimmer({super.key});

  @override
  State<CategoriesShimmer> createState() => _CategoriesShimmerState();
}

class _CategoriesShimmerState extends State<CategoriesShimmer>
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
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ListView.separated(
                itemCount: 8,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, _) =>
                    _SkeletonBox(height: 52, radius: 8, color: skeletonColor),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(
                    width: 140,
                    height: 20,
                    radius: 6,
                    color: skeletonColor,
                  ),
                  const SizedBox(height: 12),
                  _SkeletonBox(height: 100, radius: 10, color: skeletonColor),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                      itemBuilder: (_, _) => Column(
                        children: [
                          Expanded(
                            child: _SkeletonBox(
                              height: 72,
                              radius: 8,
                              color: skeletonColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _SkeletonBox(
                            height: 12,
                            radius: 4,
                            color: skeletonColor,
                          ),
                        ],
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

class SubCategoriesGridShimmer extends StatefulWidget {
  const SubCategoriesGridShimmer({super.key});

  @override
  State<SubCategoriesGridShimmer> createState() =>
      _SubCategoriesGridShimmerState();
}

class _SubCategoriesGridShimmerState extends State<SubCategoriesGridShimmer>
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
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, _) => Column(
          children: [
            Expanded(
              child: _SkeletonBox(height: 72, radius: 8, color: skeletonColor),
            ),
            const SizedBox(height: 6),
            _SkeletonBox(height: 12, radius: 4, color: skeletonColor),
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
