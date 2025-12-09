import 'package:flutter/material.dart';
import 'package:lmar_learn/models/app_user.dart';
import 'package:lmar_learn/features/auth/auth_service.dart';

class AdminSection extends StatefulWidget {
  final String adminId;
  final String schoolId;

  const AdminSection({
    super.key,
    required this.adminId,
    required this.schoolId,
  });

  @override
  State<AdminSection> createState() => _AdminSectionState();
}

class _AdminSectionState extends State<AdminSection> {
  final AuthService _authService = AuthService();
  List<AppUser> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      users = await _authService.getUsersBySchoolAndRoles(
        widget.schoolId,
        ['student', 'lecturer', 'moderator', 'nursingstaff'],
      );
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Control Center',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildActionCards(context),
                const SizedBox(height: 16),
                _buildUserGrid(),
              ],
            ),
          );
  }

  Widget _buildActionCards(BuildContext context) {
    final actions = [
      {
        'title': 'Register User',
        'icon': Icons.person_add,
        'colors': [Color(0xFF3A9FF2), Color(0xFF1A73E8)],
        'onTap': () => Navigator.pushNamed(context, '/register')
      },
      {
        'title': 'Manage Courses',
        'icon': Icons.book,
        'colors': [Color(0xFFFFA726), Color(0xFFF57C00)],
        'onTap': () => Navigator.pushNamed(context, '/admin-courses')
      },
      {
        'title': 'Delegate Rights',
        'icon': Icons.security,
        'colors': [Color(0xFFAB47BC), Color(0xFF8E24AA)],
        'onTap': () => Navigator.pushNamed(context, '/delegation')
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final action = actions[index];
          final colors = action['colors'] as List<Color>;
          return GestureDetector(
            onTap: action['onTap'] as void Function()?,
            child: Container(
              width: 140,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action['icon'] as IconData, color: Colors.white, size: 28),
                  const SizedBox(height: 8),
                  Text(action['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserGrid() {
    if (users.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text('No users found.')),
      );
    }

    return GridView.builder(
      itemCount: users.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(user.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('${user.role} • ${user.email}',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[600])),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/edit-user', arguments: user),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
