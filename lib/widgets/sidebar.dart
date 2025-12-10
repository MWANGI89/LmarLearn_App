import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final Function(String) onSelected;
  final String selected;

  const Sidebar({
    super.key,
    required this.isCollapsed,
    required this.onSelected,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'label': 'Home', 'icon': Icons.home},
      {'label': 'Courses', 'icon': Icons.school},
      {'label': 'Assignments', 'icon': Icons.assignment},
      {'label': 'Logout', 'icon': Icons.logout},
    ];

    return Container(
      width: isCollapsed ? 70 : 220,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: items.map((item) {
          bool isSelected = selected == item['label'];
          return ListTile(
            leading: Icon(item['icon'] as IconData, color: Colors.white),
            title: isCollapsed ? null : Text(item['label'] as String, style: const TextStyle(color: Colors.white)),
            selected: isSelected,
            selectedTileColor: Colors.black26,
            onTap: () => onSelected(item['label'] as String),
          );
        }).toList(),
      ),
    );
  }
}
