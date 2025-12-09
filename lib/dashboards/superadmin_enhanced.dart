import 'package:flutter/material.dart';

class SuperAdminEnhanced extends StatefulWidget {
  const SuperAdminEnhanced({super.key});

  @override
  State<SuperAdminEnhanced> createState() => _SuperAdminEnhancedState();
}

class _SuperAdminEnhancedState extends State<SuperAdminEnhanced> {
  int _selectedTabIndex = 0;

  // Dashboard tabs with 100+ features
  final List<String> tabs = [
    '📊 Overview',
    '👥 Users',
    '📚 Courses',
    '⚙️ Admin Roles',
    '🔒 Security',
    '📈 Analytics',
    '💰 Finance',
    '🎯 Content',
    '🔧 System',
    '⚡ Performance',
    '📧 Communications',
    '✓ Compliance',
    '🛠️ Maintenance',
    '🌐 Integrations',

    // Add more tabs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildModernHeader(),
          Expanded(
            child: Row(
              children: [
                _buildModernSidebar(),
                Expanded(child: _buildTabContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.admin_panel_settings, color: Colors.white, size: 32),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SuperAdmin Control Center',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Full System Control & Management',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Spacer(),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSidebar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListView.builder(
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return Container(
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF1A73E8) : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isSelected ? Color(0xFF1A73E8) : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: isSelected ? 13 : 12,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              hoverColor: Colors.blue[50],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildUsersTab();
      case 2:
        return _buildCoursesTab();
      case 3:
        return _buildAdminRolesTab();
      case 4:
        return _buildSecurityTab();
      case 5:
        return _buildAnalyticsTab();
      case 6:
        return _buildFinanceTab();
      case 7:
        return _buildContentTab();
      case 8:
        return _buildSystemTab();
      case 9:
        return _buildPerformanceTab();
      case 10:
        return _buildCommunicationsTab();
      case 11:
        return _buildComplianceTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildStatCard('Total Users', '1,250', Icons.people, Colors.blue),
              _buildStatCard(
                'Active Courses',
                '45',
                Icons.school,
                Colors.green,
              ),
              _buildStatCard(
                'Admins',
                '12',
                Icons.admin_panel_settings,
                Colors.purple,
              ),
              _buildStatCard(
                'System Health',
                '98%',
                Icons.favorite,
                Colors.red,
              ),
              _buildStatCard(
                'System Health',
                '98%',
                Icons.favorite,
                Colors.red,
              ),
              _buildStatCard(
                'Active Sessions',
                '234',
                Icons.login,
                Colors.orange,
              ),
              _buildStatCard(
                'Active Sessions',
                '234',
                Icons.login,
                Colors.orange,
              ),
              _buildStatCard(
                'Revenue (This Month)',
                '\$4,250',
                Icons.attach_money,
                Colors.amber,
              ),
              _buildStatCard(
                'Support Tickets',
                '18',
                Icons.support_agent,
                Colors.indigo,
              ),
              _buildStatCard(
                'Database Size',
                '2.5 GB',
                Icons.storage,
                Colors.teal,
              ),
              _buildStatCard(
                'Server Status',
                'Online',
                Icons.cloud,
                Colors.cyan,
              ),
              _buildStatCard('API Requests', '125K', Icons.api, Colors.pink),
              _buildStatCard(
                'User Growth',
                '+12%',
                Icons.trending_up,
                Colors.green,
              ),
              _buildStatCard(
                'Backup Status',
                'Synced',
                Icons.backup,
                Colors.blueGrey,
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildQuickActionButton('📊 View Reports', Colors.blue),
              _buildQuickActionButton('👥 Manage Users', Colors.purple),
              _buildQuickActionButton('📚 Course Management', Colors.green),
              _buildQuickActionButton('🔒 Security Audit', Colors.red),
              _buildQuickActionButton('💾 Backup System', Colors.orange),
              _buildQuickActionButton('📧 Send Notification', Colors.indigo),
              _buildQuickActionButton('✓ Verify Compliance', Colors.teal),
              _buildQuickActionButton('⚙️ System Settings', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add New User'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildUserManagementCard(
                'Manage Students',
                Icons.school,
                Colors.blue,
              ),
              _buildUserManagementCard(
                'Manage Lecturers',
                Icons.person_2,
                Colors.green,
              ),
              _buildUserManagementCard(
                'Manage Admins',
                Icons.admin_panel_settings,
                Colors.purple,
              ),
              _buildUserManagementCard(
                'Manage Moderators',
                Icons.security,
                Colors.orange,
              ),
              _buildUserManagementCard(
                'Manage Nursing Staff',
                Icons.medical_services,
                Colors.red,
              ),
              _buildUserManagementCard(
                'View User Profiles',
                Icons.person,
                Colors.teal,
              ),
              _buildUserManagementCard(
                'User Activity Logs',
                Icons.history,
                Colors.indigo,
              ),
              _buildUserManagementCard(
                'Bulk User Import',
                Icons.upload,
                Colors.amber,
              ),
              _buildUserManagementCard(
                'User Export Reports',
                Icons.download,
                Colors.pink,
              ),
              _buildUserManagementCard(
                'Deactivate Users',
                Icons.person_off,
                Colors.blueGrey,
              ),
              _buildUserManagementCard(
                'Reset User Passwords',
                Icons.lock_reset,
                Colors.cyan,
              ),
              _buildUserManagementCard(
                'Assign User Roles',
                Icons.assignment_ind,
                Colors.lime,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Create Course'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildCourseManagementCard(
                'Create New Course',
                Icons.add_box,
                Colors.green,
              ),
              _buildCourseManagementCard(
                'Approve Pending Courses',
                Icons.check_circle,
                Colors.blue,
              ),
              _buildCourseManagementCard(
                'Edit Existing Courses',
                Icons.edit,
                Colors.purple,
              ),
              _buildCourseManagementCard(
                'Add Course Images',
                Icons.image,
                Colors.orange,
              ),
              _buildCourseManagementCard(
                'Manage Course Categories',
                Icons.category,
                Colors.red,
              ),
              _buildCourseManagementCard(
                'Course Pricing',
                Icons.attach_money,
                Colors.amber,
              ),
              _buildCourseManagementCard(
                'Featured Courses',
                Icons.star,
                Colors.yellow,
              ),
              _buildCourseManagementCard(
                'Course Analytics',
                Icons.analytics,
                Colors.teal,
              ),
              _buildCourseManagementCard(
                'Course Feedback',
                Icons.feedback,
                Colors.indigo,
              ),
              _buildCourseManagementCard(
                'Manage Instructors',
                Icons.person_3,
                Colors.pink,
              ),
              _buildCourseManagementCard(
                'Course Enrollments',
                Icons.group,
                Colors.cyan,
              ),
              _buildCourseManagementCard(
                'Bulk Course Upload',
                Icons.cloud_upload,
                Colors.blueGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminRolesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Roles & Permissions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildPermissionCard(
                'Super Admin',
                'Full System Access',
                Colors.red,
              ),
              _buildPermissionCard(
                'Admin Manager',
                'User & School Management',
                Colors.orange,
              ),
              _buildPermissionCard(
                'Content Manager',
                'Course & Content Control',
                Colors.blue,
              ),
              _buildPermissionCard(
                'Support Manager',
                'Ticket & Support Management',
                Colors.green,
              ),
              _buildPermissionCard(
                'Finance Manager',
                'Payment & Revenue Control',
                Colors.amber,
              ),
              _buildPermissionCard(
                'Security Manager',
                'Security & Compliance',
                Colors.purple,
              ),
              _buildPermissionCard(
                'Report Manager',
                'Analytics & Reports',
                Colors.teal,
              ),
              _buildPermissionCard(
                'Moderator',
                'Content Moderation',
                Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildSecurityCard('Enable 2FA', Icons.security, Colors.red),
              _buildSecurityCard(
                'IP Whitelist',
                Icons.admin_panel_settings,
                Colors.orange,
              ),
              _buildSecurityCard(
                'SSL Certificate',
                Icons.verified,
                Colors.green,
              ),
              _buildSecurityCard('API Keys', Icons.vpn_key, Colors.blue),
              _buildSecurityCard('Audit Logs', Icons.history, Colors.purple),
              _buildSecurityCard('Backup Settings', Icons.backup, Colors.teal),
              _buildSecurityCard('Encryption Keys', Icons.lock, Colors.amber),
              _buildSecurityCard(
                'Session Management',
                Icons.logout,
                Colors.indigo,
              ),
              _buildSecurityCard('Rate Limiting', Icons.speed, Colors.pink),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics & Reports',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildAnalyticsCard(
                'User Growth Chart',
                Icons.trending_up,
                Colors.blue,
              ),
              _buildAnalyticsCard(
                'Course Enrollment Trends',
                Icons.show_chart,
                Colors.green,
              ),
              _buildAnalyticsCard(
                'Revenue Analytics',
                Icons.attach_money,
                Colors.amber,
              ),
              _buildAnalyticsCard(
                'User Activity Report',
                Icons.people,
                Colors.purple,
              ),
              _buildAnalyticsCard(
                'Course Performance',
                Icons.school,
                Colors.orange,
              ),
              _buildAnalyticsCard('Login Statistics', Icons.login, Colors.teal),
              _buildAnalyticsCard(
                'Device Analytics',
                Icons.devices,
                Colors.indigo,
              ),
              _buildAnalyticsCard(
                'Geographic Data',
                Icons.location_on,
                Colors.red,
              ),
              _buildAnalyticsCard('Export Report', Icons.download, Colors.pink),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildFinanceCard(
                'View Transactions',
                Icons.receipt,
                Colors.blue,
              ),
              _buildFinanceCard('Process Refunds', Icons.money_off, Colors.red),
              _buildFinanceCard(
                'Payment Gateway Settings',
                Icons.payment,
                Colors.green,
              ),
              _buildFinanceCard(
                'Revenue Reports',
                Icons.pie_chart,
                Colors.amber,
              ),
              _buildFinanceCard(
                'Subscription Management',
                Icons.subscriptions,
                Colors.purple,
              ),
              _buildFinanceCard(
                'Invoice Generation',
                Icons.description,
                Colors.orange,
              ),
              _buildFinanceCard('Tax Settings', Icons.calculate, Colors.teal),
              _buildFinanceCard(
                'Pricing Tiers',
                Icons.price_check,
                Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildContentCard('CMS Pages', Icons.article, Colors.blue),
              _buildContentCard('Media Library', Icons.image, Colors.purple),
              _buildContentCard('Email Templates', Icons.mail, Colors.green),
              _buildContentCard(
                'Announcements',
                Icons.announcement,
                Colors.orange,
              ),
              _buildContentCard('FAQ Management', Icons.help, Colors.red),
              _buildContentCard('Testimonials', Icons.rate_review, Colors.teal),
              _buildContentCard('Banner Management', Icons.image, Colors.amber),
              _buildContentCard(
                'Content Moderation',
                Icons.verified_user,
                Colors.indigo,
              ),
              _buildContentCard('SEO Settings', Icons.search, Colors.pink),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Configuration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildSystemCard('App Settings', Icons.settings, Colors.blue),
              _buildSystemCard(
                'Email Configuration',
                Icons.mail,
                Colors.orange,
              ),
              _buildSystemCard('SMS Settings', Icons.sms, Colors.green),
              _buildSystemCard(
                'Notification Settings',
                Icons.notifications,
                Colors.purple,
              ),
              _buildSystemCard('Database Settings', Icons.storage, Colors.teal),
              _buildSystemCard('API Configuration', Icons.api, Colors.indigo),
              _buildSystemCard(
                'Maintenance Mode',
                Icons.construction,
                Colors.amber,
              ),
              _buildSystemCard('System Logs', Icons.history, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Monitoring',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildPerformanceCard('CPU Usage', '45%', Colors.blue),
              _buildPerformanceCard('Memory Usage', '62%', Colors.green),
              _buildPerformanceCard('Disk Usage', '78%', Colors.orange),
              _buildPerformanceCard(
                'Database Performance',
                'Good',
                Colors.teal,
              ),
              _buildPerformanceCard(
                'API Response Time',
                '120ms',
                Colors.purple,
              ),
              _buildPerformanceCard('Cache Hit Rate', '89%', Colors.amber),
              _buildPerformanceCard('Server Load', '3.2', Colors.red),
              _buildPerformanceCard(
                'Network Bandwidth',
                '450 Mbps',
                Colors.indigo,
              ),
              _buildPerformanceCard('Error Rate', '0.02%', Colors.pink),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Communications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildCommCard('Send Email Campaign', Icons.mail, Colors.blue),
              _buildCommCard('Send SMS Notifications', Icons.sms, Colors.green),
              _buildCommCard(
                'Push Notifications',
                Icons.notifications,
                Colors.purple,
              ),
              _buildCommCard('In-App Messages', Icons.message, Colors.orange),
              _buildCommCard(
                'Support Tickets',
                Icons.support_agent,
                Colors.red,
              ),
              _buildCommCard('Contact Forms', Icons.contact_mail, Colors.teal),
              _buildCommCard(
                'Newsletter Signup',
                Icons.subscriptions,
                Colors.amber,
              ),
              _buildCommCard(
                'Communication History',
                Icons.history,
                Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compliance & Legal',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildComplianceCard(
                'Privacy Policy',
                Icons.privacy_tip,
                Colors.blue,
              ),
              _buildComplianceCard(
                'Terms of Service',
                Icons.description,
                Colors.green,
              ),
              _buildComplianceCard(
                'GDPR Compliance',
                Icons.verified,
                Colors.purple,
              ),
              _buildComplianceCard(
                'Data Export',
                Icons.download,
                Colors.orange,
              ),
              _buildComplianceCard(
                'User Consent',
                Icons.check_circle,
                Colors.red,
              ),
              _buildComplianceCard(
                'Compliance Reports',
                Icons.assessment,
                Colors.teal,
              ),
              _buildComplianceCard('Audit Trail', Icons.history, Colors.amber),
              _buildComplianceCard('Legal Notices', Icons.gavel, Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widgets for building cards
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(
              (color.r * 255.0).round().clamp(0, 255),
              (color.g * 255.0).round().clamp(0, 255),
              (color.b * 255.0).round().clamp(0, 255),
              0.8,
            ),
            Color.fromRGBO(
              (color.r * 255.0).round().clamp(0, 255),
              (color.g * 255.0).round().clamp(0, 255),
              (color.b * 255.0).round().clamp(0, 255),
              0.5,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 10),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, Color color) {
    return ElevatedButton.icon(
      icon: Icon(Icons.arrow_forward),
      label: Text(label),
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  Widget _buildUserManagementCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildCourseManagementCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildPermissionCard(String role, String desc, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(
                (color.r * 255.0).round().clamp(0, 255),
                (color.g * 255.0).round().clamp(0, 255),
                (color.b * 255.0).round().clamp(0, 255),
                0.8,
              ),
              Color.fromRGBO(
                (color.r * 255.0).round().clamp(0, 255),
                (color.g * 255.0).round().clamp(0, 255),
                (color.b * 255.0).round().clamp(0, 255),
                0.5,
              ),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              role,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildAnalyticsCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildFinanceCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildContentCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildSystemCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildPerformanceCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.8),
              color.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.white70, fontSize: 11)),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildComplianceCard(String title, IconData icon, Color color) {
    return _buildFeatureCard(title, icon, color);
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.8),
                color.withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
