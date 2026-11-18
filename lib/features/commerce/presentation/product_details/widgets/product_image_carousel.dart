import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  final bool isWishlisted;
  final VoidCallback onWishlistTap;

  const ProductImageCarousel({
    super.key,
    required this.images,
    required this.isWishlisted,
    required this.onWishlistTap,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    final pageCount = images.isEmpty ? 1 : images.length;

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: context.colors.outline, width: 1.5),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13.5),
            child: images.isEmpty
                ? _ImagePlaceholder(color: context.colors.primary)
                : PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) => Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                      errorBuilder: (_, _, _) =>
                          _ImagePlaceholder(color: context.colors.primary),
                    ),
                  ),
          ),
          PositionedDirectional(
            top: 12,
            end: 12,
            child: _WishlistIconButton(
              isWishlisted: widget.isWishlisted,
              onTap: widget.onWishlistTap,
            ),
          ),
          if (pageCount > 1)
            PositionedDirectional(
              bottom: 12,
              start: 0,
              end: 0,
              child: _CarouselDots(count: pageCount, activeIndex: _currentPage),
            ),
        ],
      ),
    );
  }
}

class _WishlistIconButton extends StatelessWidget {
  final bool isWishlisted;
  final VoidCallback onTap;

  const _WishlistIconButton({required this.isWishlisted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      shape: const CircleBorder(),
      elevation: 2,
      child: IconButton(
        onPressed: onTap,
        tooltip: context.locale.addToWishlist,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
        icon: Icon(
          isWishlisted ? Icons.favorite : Icons.favorite_border,
          color: context.colors.primary,
          size: 20,
        ),
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _CarouselDots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 3),
          width: isActive ? 24 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? context.colors.primary : context.colors.surface,
            borderRadius: BorderRadius.circular(4),
            border: isActive
                ? null
                : Border.all(color: context.colors.primary, width: 1),
          ),
        );
      }),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final Color color;

  const _ImagePlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.outline.withValues(alpha: 0.15),
      alignment: AlignmentDirectional.center,
      child: Icon(Icons.image_outlined, size: 48, color: color),
    );
  }
}
