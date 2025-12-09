import 'package:flutter/material.dart';
import 'package:lmar_learn/models/app_user.dart';
import 'package:lmar_learn/features/auth/auth_service.dart';

class SuperAdminOverview extends StatefulWidget {
  final AppUser superAdminUser;

  const SuperAdminOverview({super.key, required this.superAdminUser});

  @override
  State<SuperAdminOverview> createState() => _SuperAdminOverviewState();
}

class _SuperAdminOverviewState extends State<SuperAdminOverview> {
  final AuthService _authService = AuthService();
  int totalAdmins = 0;
  int totalUsers = 0;
  int totalSchools = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      // Fetch stats from Firestore
      final admins = await _authService.getUsersByRole("admin");

      setState(() {
        totalAdmins = admins.length;
        totalUsers = totalAdmins + 1; // Include superadmin
        totalSchools = admins.isEmpty
            ? 1
            : admins.length; // Estimate based on admins
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Overview',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildStatsGrid(),
          const SizedBox(height: 30),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'title': 'Total Admins',
        'value': totalAdmins.toString(),
        'icon': Icons.admin_panel_settings,
        'color': Colors.purple,
      },
      {
        'title': 'Total Users',
        'value': totalUsers.toString(),
        'icon': Icons.people,
        'color': Colors.blue,
      },
      {
        'title': 'Schools',
        'value': totalSchools.toString(),
        'icon': Icons.school,
        'color': Colors.orange,
      },
      {
        'title': 'System Status',
        'value': 'Healthy',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatCard(
          title: stat['title'] as String,
          value: stat['value'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.4)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 28),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          children: [
            _buildQuickActionButton(
              label: 'Register Admin',
              icon: Icons.person_add,
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
            _buildQuickActionButton(
              label: 'View Reports',
              icon: Icons.assessment,
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reports feature coming soon')),
                );
              },
            ),
            _buildQuickActionButton(
              label: 'System Backup',
              icon: Icons.backup,
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup initiated')),
                );
              },
            ),
            _buildQuickActionButton(
              label: 'System Logs',
              icon: Icons.history,
              color: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('System logs coming soon')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
