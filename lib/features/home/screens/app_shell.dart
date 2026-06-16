import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/watchlist')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/watchlist');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.surfaceBorder,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(index, context),
          selectedLabelStyle: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
          unselectedLabelStyle: AppTypography.labelSmall,
          items: [
            _buildNavItem(Icons.home_outlined, Icons.home, 'Home', currentIndex == 0),
            _buildNavItem(Icons.search_outlined, Icons.search, 'Search', currentIndex == 1),
            _buildNavItem(Icons.bookmark_outline, Icons.bookmark, 'My List', currentIndex == 2),
            _buildNavItem(Icons.person_outline, Icons.person, 'Profile', currentIndex == 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, IconData activeIcon, String label, bool isActive) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Icon(isActive ? activeIcon : icon),
          if (isActive)
            Positioned(
              top: -8,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.brand,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
