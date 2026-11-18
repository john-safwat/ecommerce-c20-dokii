import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';

class HomeBannersCarousel extends StatefulWidget {
  final List<BannerEntity> banners;

  const HomeBannersCarousel({super.key, required this.banners});

  @override
  State<HomeBannersCarousel> createState() => _HomeBannersCarouselState();
}

class _HomeBannersCarouselState extends State<HomeBannersCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: SizedBox(
        height: 200,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.banners.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) =>
                  _BannerSlide(banner: widget.banners[index]),
            ),
            Positioned(
              bottom: 12,
              child: _BannerDots(
                count: widget.banners.length,
                activeIndex: _currentIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  final BannerEntity banner;

  const _BannerSlide({required this.banner});

  @override
  Widget build(BuildContext context) {
    final isEndAligned = banner.alignment.x > 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            banner.image,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: context.colors.outline.withValues(alpha: 0.2),
              alignment: AlignmentDirectional.center,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: context.colors.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Align(
              alignment: isEndAligned
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isEndAligned
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    banner.title,
                    textAlign: isEndAligned ? TextAlign.start : TextAlign.end,
                    style: context.text.headlineMedium?.copyWith(
                      color: banner.buttonForGroundColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.categoryName,
                    textAlign: isEndAligned ? TextAlign.start : TextAlign.end,
                    style: context.text.bodySmall?.copyWith(
                      color: banner.buttonForGroundColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: banner.buttonBackGroundColor,
                      foregroundColor: banner.buttonForGroundColor,
                      minimumSize: const Size(96, 36),
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      context.locale.shopNow,
                      style: context.text.bodySmall?.copyWith(
                        color: banner.buttonForGroundColor,
                        fontWeight: FontWeight.w500,
                      ),
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

class _BannerDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _BannerDots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? context.colors.primary : context.colors.surface,
          ),
        );
      }),
    );
  }
}
