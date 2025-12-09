// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:lmar_learn/models/app_user.dart';

class SuperAdminSystemControl extends StatefulWidget {
  final AppUser superAdminUser;

  const SuperAdminSystemControl({super.key, required this.superAdminUser});

  @override
  State<SuperAdminSystemControl> createState() =>
      _SuperAdminSystemControlState();
}

class _SuperAdminSystemControlState extends State<SuperAdminSystemControl> {
  bool _maintenanceMode = false;
  bool _backupEnabled = true;
  bool _notificationsEnabled = true;
  bool _analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return false;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Control & Delegation',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildControlPanel(),
            const SizedBox(height: 30),
            _buildRoleDelegation(),
            const SizedBox(height: 30),
            _buildSecuritySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'System Features',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          _buildControlTile(
            title: 'Maintenance Mode',
            subtitle: 'Temporarily disable system access for maintenance',
            icon: Icons.construction,
            value: _maintenanceMode,
            onChanged: (value) {
              setState(() => _maintenanceMode = value);
              _showNotification(
                'Maintenance mode ${value ? 'enabled' : 'disabled'}',
              );
            },
          ),
          _buildControlTile(
            title: 'Automatic Backup',
            subtitle: 'Enable daily automated backups at 2:00 AM',
            icon: Icons.backup,
            value: _backupEnabled,
            onChanged: (value) {
              setState(() => _backupEnabled = value);
              _showNotification(
                'Automatic backup ${value ? 'enabled' : 'disabled'}',
              );
            },
          ),
          _buildControlTile(
            title: 'Notifications',
            subtitle: 'System notifications and alerts',
            icon: Icons.notifications,
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _showNotification(
                'Notifications ${value ? 'enabled' : 'disabled'}',
              );
            },
          ),
          _buildControlTile(
            title: 'Analytics',
            subtitle: 'Collect system usage analytics',
            icon: Icons.analytics,
            value: _analyticsEnabled,
            onChanged: (value) {
              setState(() => _analyticsEnabled = value);
              _showNotification('Analytics ${value ? 'enabled' : 'disabled'}');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.blue,
      ),
    );
  }

  Widget _buildRoleDelegation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role Management & Delegation',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          // childAspectRatio controls width / height. Larger value = shorter cards.
          childAspectRatio: 2.0,
          children: [
            _buildRoleCard(
              title: 'Admin',
              description: 'Manage users and school settings',
              icon: Icons.admin_panel_settings,
              color: Colors.purple,
              onTap: () => _showRoleDetails('Admin'),
            ),
            _buildRoleCard(
              title: 'Lecturer',
              description: 'Manage courses and students',
              icon: Icons.school,
              color: Colors.blue,
              onTap: () => _showRoleDetails('Lecturer'),
            ),
            _buildRoleCard(
              title: 'Student',
              description: 'Access course materials',
              icon: Icons.person,
              color: Colors.green,
              onTap: () => _showRoleDetails('Student'),
            ),
            _buildRoleCard(
              title: 'Moderator',
              description: 'Moderate forums and discussions',
              icon: Icons.gavel,
              color: Colors.orange,
              onTap: () => _showRoleDetails('Moderator'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 110, maxHeight: 160),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(color.red, color.green, color.blue, 0.2),
                Color.fromRGBO(color.red, color.green, color.blue, 0.05),
              ],
            ),
            border: Border.all(
              color: Color.fromRGBO(color.red, color.green, color.blue, 0.9),
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Security & Permissions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.security, color: Colors.red),
              ],
            ),
          ),
          const Divider(),
          _buildSecurityItem(
            icon: Icons.vpn_key,
            title: 'API Keys Management',
            description: 'Create and manage API keys for integrations',
            onTap: () => _showNotification('API Keys management coming soon'),
          ),
          _buildSecurityItem(
            icon: Icons.lock,
            title: 'Password Policies',
            description: 'Configure password requirements and expiration',
            onTap: () =>
                _showNotification('Password policies management coming soon'),
          ),
          _buildSecurityItem(
            icon: Icons.verified_user,
            title: 'Two-Factor Authentication',
            description: 'Enable 2FA for admin accounts',
            onTap: () => _showNotification('2FA setup coming soon'),
          ),
          _buildSecurityItem(
            icon: Icons.history,
            title: 'Audit Logs',
            description: 'View system activity and admin actions',
            onTap: () => _showNotification('Audit logs viewer coming soon'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: Colors.red),
          title: Text(title),
          subtitle: Text(description, style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showRoleDetails(String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 120, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$role Permissions'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Manage permissions for this role:'),
                const SizedBox(height: 12),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('View Dashboard'),
                  value: true,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Edit Content'),
                  value: true,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Delete Content'),
                  value: false,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Manage Users'),
                  value: false,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('View Reports'),
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$role permissions updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
