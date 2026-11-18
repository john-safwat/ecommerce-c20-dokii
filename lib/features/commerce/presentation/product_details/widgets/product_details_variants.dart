import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

class ProductSizeSelector extends StatelessWidget {
  static const List<int> defaultSizes = [38, 39, 40, 41, 42];

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ProductSizeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.locale.size, style: context.text.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: List.generate(defaultSizes.length, (index) {
            final isSelected = index == selectedIndex;
            return InkWell(
              onTap: () => onSelect(index),
              customBorder: const CircleBorder(),
              child: Container(
                width: 40,
                height: 40,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? context.colors.primary
                      : Colors.transparent,
                ),
                child: Text(
                  defaultSizes[index].toString(),
                  style: context.text.bodyMedium?.copyWith(
                    color: isSelected
                        ? context.colors.onPrimary
                        : context.colors.secondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class ProductColorSelector extends StatelessWidget {
  static const List<Color> defaultColors = [
    Color(0xFF2F2929),
    Color(0xFFBC3018),
    Color(0xFF0973DD),
    Color(0xFF02B935),
    Color(0xFFFF645A),
  ];

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ProductColorSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.locale.color, style: context.text.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: List.generate(defaultColors.length, (index) {
            final isSelected = index == selectedIndex;
            return InkWell(
              onTap: () => onSelect(index),
              customBorder: const CircleBorder(),
              child: Container(
                width: 36,
                height: 36,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: defaultColors[index],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 20,
                        color: context.colors.onPrimary,
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
