import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          _destination(context, assetPath: 'assets/icons/home.svg', label: '홈'),
          _destination(
            context,
            assetPath: 'assets/icons/movie.svg',
            label: '영화',
          ),
          _destination(
            context,
            assetPath: 'assets/icons/person.svg',
            label: '마이',
          ),
        ],
      ),
    );
  }

  NavigationDestination _destination(
    BuildContext context, {
    required String assetPath,
    required String label,
  }) {
    final colors = Theme.of(context).colorScheme;

    return NavigationDestination(
      icon: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(colors.onSurfaceVariant, BlendMode.srcIn),
      ),
      selectedIcon: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}
