import 'package:flutter/material.dart';
import 'package:lmar_learn/models/app_user.dart';

class UserListWidget extends StatelessWidget {
  final String title;
  final List<AppUser> users;

  const UserListWidget({super.key, required this.title, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final user = users[i];

        return Card(
          child: ListTile(
            title: Text(user.email),
            subtitle: Text("Role: ${user.role}"),
            trailing: PopupMenuButton<String>(
              onSelected: (action) {
                if (action == 'act') {
                  // Impersonate / Act as user - navigate to their dashboard
                  final role = user.role.toLowerCase();
                  if (role == 'student') {
                    Navigator.pushNamed(
                      context,
                      '/student-dashboard',
                      arguments: {'userId': user.id},
                    );
                  } else if (role == 'lecturer') {
                    Navigator.pushNamed(
                      context,
                      '/lecturer-dashboard',
                      arguments: {'userId': user.id},
                    );
                  } else if (role == 'moderator') {
                    Navigator.pushNamed(
                      context,
                      '/moderator-dashboard',
                      arguments: {'userId': user.id},
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Cannot open dashboard for role: ${user.role}',
                        ),
                      ),
                    );
                  }
                } else if (action == 'delegate') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Delegate Rights'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CheckboxListTile(
                            title: Text('View Dashboard'),
                            value: true,
                            onChanged: (v) {},
                          ),
                          CheckboxListTile(
                            title: Text('Edit Content'),
                            value: false,
                            onChanged: (v) {},
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rights delegated')),
                            );
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  );
                } else if (action == 'courses') {
                  Navigator.pushNamed(
                    context,
                    '/admin-courses',
                    arguments: {'userId': user.id},
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'act', child: Text('Act as User')),
                const PopupMenuItem(
                  value: 'delegate',
                  child: Text('Delegate Rights'),
                ),
                const PopupMenuItem(
                  value: 'courses',
                  child: Text('Manage Courses'),
                ),
              ],
            ),
            onTap: () {
              // Navigate to user details
            },
          ),
        );
      },
    );
  }
}
