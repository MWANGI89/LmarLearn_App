import 'package:flutter/material.dart';
import 'package:lmar_learn/models/app_user.dart';

import 'superadmin_dashboard.dart';
import 'admin_section.dart';

class SchoolDashboard extends StatefulWidget {
  final AppUser loggedUser;

  const SchoolDashboard({super.key, required this.loggedUser});

  @override
  State<SchoolDashboard> createState() => _SchoolDashboardState();
}

class _SchoolDashboardState extends State<SchoolDashboard> {
  @override
  Widget build(BuildContext context) {
    final user = widget.loggedUser;

    // If user is a SuperAdmin, route to SuperAdmin dashboard
    if (user.role.toLowerCase() == "superadmin") {
      return SuperAdminDashboard(superAdminUser: user);
    }

    // Otherwise, assume this is an Admin dashboard
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: AdminSection(
        adminId: user.id,
        schoolId: user.schoolId, // pass actual schoolId if available
      ),
    );
  }
}
