import 'package:flutter/material.dart';
import 'package:lmar_learn/features/auth/auth_service.dart';
import 'package:lmar_learn/models/app_user.dart';

import '../widgets/user_list_widget.dart';

class SuperAdminSection extends StatefulWidget {
  final String superAdminId;

  const SuperAdminSection({super.key, required this.superAdminId});

  @override
  State<SuperAdminSection> createState() => _SuperAdminSectionState();
}

class _SuperAdminSectionState extends State<SuperAdminSection> {
  final AuthService _authService = AuthService();
  List<AppUser> admins = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAdmins();
  }

  Future<void> loadAdmins() async {
    try {
      final fetchedAdmins = await _authService.getUsersByRole("admin");
      setState(() {
        admins = fetchedAdmins;
        loading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = 'Error loading admins: ${e.toString()}';
        admins = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  errorMessage = null;
                });
                loadAdmins();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (admins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_accounts, size: 64, color: Colors.grey),
            const SizedBox(height: 10),
            const Text('No admins registered yet'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to registration screen to add an admin
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register Admin'),
            ),
          ],
        ),
      );
    }

    return UserListWidget(title: "School Admins", users: admins);
  }
}
