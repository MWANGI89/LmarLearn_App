import 'package:flutter/material.dart';
import 'package:lmar_learn/models/app_user.dart';

import '../dashboards/superadmin_admin_management.dart';
import '../dashboards/superadmin_overview.dart';
import '../dashboards/superadmin_settings.dart';
import '../dashboards/superadmin_system_control.dart'; // Add this file

class SuperAdminDashboard extends StatefulWidget {
  final AppUser superAdminUser;

  const SuperAdminDashboard({super.key, required this.superAdminUser});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  int _currentTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Overview', 'icon': Icons.dashboard, 'color': Colors.blue},
    {'title': 'Admin Management', 'icon': Icons.people_alt, 'color': Colors.purple},
    {'title': 'System Control', 'icon': Icons.settings_suggest, 'color': Colors.orange},
    {'title': 'Settings', 'icon': Icons.settings, 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SuperAdmin Control Center',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Manage your entire system',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Chip(
            avatar: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                widget.superAdminUser.name.isNotEmpty
                    ? widget.superAdminUser.name[0].toUpperCase()
                    : 'S',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            label: Text(widget.superAdminUser.email),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final pages = [
      SuperAdminOverview(superAdminUser: widget.superAdminUser, key: const ValueKey('overview')),
      SuperAdminManagement(superAdminUser: widget.superAdminUser, key: const ValueKey('admin')),
      SuperAdminSystemControl(superAdminUser: widget.superAdminUser, key: const ValueKey('system')),
      SuperAdminSettings(superAdminUser: widget.superAdminUser, key: const ValueKey('settings')),
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: pages[_currentTabIndex],
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isActive = index == _currentTabIndex;
            final Color tabColor = tab['color'] as Color;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _currentTabIndex = index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                    decoration: BoxDecoration(
                      color: isActive ? tabColor.withAlpha((0.1 * 255).toInt()) : Colors.transparent,
                      border: Border.all(
                        color: isActive ? tabColor : Colors.grey.shade300,
                        width: isActive ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(tab['icon'] as IconData, color: isActive ? tabColor : Colors.grey.shade600, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          tab['title'] as String,
                          style: TextStyle(
                            color: isActive ? tabColor : Colors.grey.shade600,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
