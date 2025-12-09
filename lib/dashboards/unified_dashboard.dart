import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../features/courses/course_service.dart';
import '../features/assignments/assignment_service.dart';
import '../features/courses/course.dart';
import '../features/assignments/assignment.dart';
import 'superadmin_dashboard.dart';
import 'admin_section.dart';

class UnifiedDashboard extends StatefulWidget {
  final AppUser loggedUser;

  const UnifiedDashboard({super.key, required this.loggedUser});

  @override
  State<UnifiedDashboard> createState() => _UnifiedDashboardState();
}

class _UnifiedDashboardState extends State<UnifiedDashboard> {
  final CourseService _courseService = CourseService();
  final AssignmentService _assignmentService = AssignmentService();

  List<Course> courses = [];
  List<Assignment> assignments = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = widget.loggedUser;
    try {
      final allCourses = await _courseService.getAllCourses();
      List<Assignment> assignmentList = [];

      if (user.role == 'student') {
        assignmentList = await _assignmentService.getAssignmentsForStudent(user.id);
      }

      if (!mounted) return;

      setState(() {
        courses = user.role == 'lecturer'
            ? allCourses.where((c) => c.createdBy == user.id).toList()
            : allCourses;
        assignments = assignmentList;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.loggedUser;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // SuperAdmin redirects to their dashboard
    if (user.role == 'superadmin') {
      return SuperAdminDashboard(superAdminUser: user);
    }

    // Admin Dashboard
    if (user.role == 'admin') {
      return Scaffold(
        appBar: AppBar(title: const Text("Admin Dashboard")),
        body: AdminSection(adminId: user.id, schoolId: user.schoolId),
      );
    }

    // Student or Lecturer
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatsCard(user.role),
                  _buildTabNavigation(),
                  _selectedTabIndex == 0
                      ? _buildCoursesTab(user.role)
                      : _buildAssignmentsTab(user.role),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Your Learning Journey',
                  style: TextStyle(
                      color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Continue growing and achieving your goals',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ],
        ),
      );

  Widget _buildStatsCard(String role) {
    int completedCourses = courses.where((c) => c.isFeatured).length;
    int pendingAssignments = assignments.where((a) => a.submission?.isEmpty ?? true).length;

    return Container(
      margin: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.2,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStatItem('Total Courses', '${courses.length}', Icons.school, Colors.blue),
          _buildStatItem('Completed', '$completedCourses', Icons.check_circle, Colors.green),
          _buildStatItem('Pending', '$pendingAssignments', Icons.assignment, Colors.orange),
          if (role == 'lecturer')
            FutureBuilder<int>(
              future: Future.wait(
                      courses.map((c) => _courseService.getEnrolledStudentsCount(c.id)))
                  .then((counts) => counts.fold<int>(0, (a, b) => a + b)),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return _buildStatItem('Enrolled Students', '$count', Icons.group, Colors.purple);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String count, IconData icon, Color color) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                Text(count,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      );

  Widget _buildTabNavigation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          _buildTabButton('📚 Courses', 0),
          _buildTabButton('📝 Assignments', 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A73E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          onPressed: () => setState(() => _selectedTabIndex = index),
          child: Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _buildCoursesTab(String role) {
    if (courses.isEmpty) return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(child: Text('No courses yet')),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (context, index) => _buildCourseCard(courses[index], index),
      ),
    );
  }

  Widget _buildCourseCard(Course course, int index) {
    double progress = ((index + 1) * 25) % 100 / 100;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: course.imageUrl != null
                  ? Image.network(course.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, size: 48, color: Colors.white30)))
                  : const Center(child: Icon(Icons.school, size: 48, color: Colors.white30)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(course.description,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF1A73E8))),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        minimumSize: const Size(double.infinity, 28)),
                    child: const Text('Continue Learning', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsTab(String role) {
    if (assignments.isEmpty) return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(child: Text('No assignments yet')),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: assignments.map((assignment) {
          bool isSubmitted = assignment.submission?.isNotEmpty ?? false;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isSubmitted ? Colors.green[200]! : Colors.orange[200]!,
                  width: 2),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSubmitted ? Colors.green[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(isSubmitted ? Icons.check_circle : Icons.pending_actions,
                        color: isSubmitted ? Colors.green : Colors.orange, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(assignment.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(assignment.description,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Text(isSubmitted ? 'Submitted' : 'Due Soon',
                            style: TextStyle(
                                fontSize: 11,
                                color: isSubmitted ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  isSubmitted
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
                          child: const Text('✓ Done',
                              style: TextStyle(
                                  color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      : ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange, foregroundColor: Colors.white),
                          child: const Text('Submit'),
                        ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
