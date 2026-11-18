import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_page.dart';

class MainLayoutPage extends StatefulWidget {
  final int initialIndex;

  const MainLayoutPage({super.key, this.initialIndex = 0});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomePage(),
          const CategoriesPage(),
          _PlaceholderTab(label: context.locale.wishlistTab),
          _PlaceholderTab(label: context.locale.profileTab),
        ],
      ),
      bottomNavigationBar: _CommerceBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _CommerceBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CommerceBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: context.locale.homeTab,
      ),
      (
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: context.locale.categoriesTab,
      ),
      (
        icon: Icons.favorite_border,
        activeIcon: Icons.favorite,
        label: context.locale.wishlistTab,
      ),
      (
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: context.locale.profileTab,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              return Semantics(
                button: true,
                selected: isSelected,
                label: item.label,
                child: IconButton(
                  tooltip: item.label,
                  onPressed: () => onTap(index),
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.onPrimary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.onPrimary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;

  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label — ${context.locale.comingSoon}',
        style: context.text.titleMedium,
      ),
    );
  }
}
