import 'package:flutter/material.dart';

import '../routes.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  /// 0 — главная, 1 — профиль.
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).appBarTheme.foregroundColor;
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      selectedItemColor: foreground,
      unselectedItemColor: foreground?.withValues(alpha: 0.54),
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        final currentName = ModalRoute.of(context)?.settings.name;
        final target = index == 0 ? AppRoutes.home : AppRoutes.profile;
        if (currentName == target) return;
        Navigator.pushNamedAndRemoveUntil(context, target, (route) => false);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ],
    );
  }
}
