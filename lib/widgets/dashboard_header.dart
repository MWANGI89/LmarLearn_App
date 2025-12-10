import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onMenuTap;

  const DashboardHeader({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuTap,
          ),
          const SizedBox(width: 10),
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
    );
  }
}
