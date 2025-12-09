import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/courses/course.dart';

class CourseService {
  final _db = FirebaseFirestore.instance;

  Future<List<Course>> getAllCourses() async {
    final snap = await _db.collection('courses').get();
    return snap.docs.map((d) => Course.fromMap(d.id, d.data())).toList();
  }

  /// NEW METHOD: Get number of students enrolled in a course
  Future<int> getEnrolledStudentsCount(String courseId) async {
    try {
      final snapshot = await _db
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching enrolled students count: $e');
      return 0;
    }
  }
}
