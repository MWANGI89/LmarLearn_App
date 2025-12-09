class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String schoolId;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.schoolId,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      id: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      schoolId: data['schoolId'] ?? '',
    );
  }
}
