import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'assignment.dart';

class AssignmentService {
  final CollectionReference assignmentsRef =
      FirebaseFirestore.instance.collection('assignments');

  // Create a logger instance
  final Logger logger = Logger();

  // Create new assignment
  Future<void> addAssignment(Assignment assignment) async {
    await assignmentsRef.doc(assignment.id).set(assignment.toMap());
  }

  // Get assignments belonging to a course
  Future<List<Assignment>> getAssignmentsByCourse(String courseId) async {
    final snapshot =
        await assignmentsRef.where('courseId', isEqualTo: courseId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Assignment.fromMap(doc.id, data);
    }).toList();
  }

  // Get assignments for a student
  Future<List<Assignment>> getAssignmentsForStudent(String studentId) async {
    try {
      final snapshot =
          await assignmentsRef.where('studentId', isEqualTo: studentId).get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Assignment.fromMap(doc.id, data);
      }).toList();
    } catch (e) {
      logger.e("Error fetching assignments for student: $e"); // Use logger for error
      return [];
    }
  }

  // Submit assignment
  Future<void> submitAssignment(
    String assignmentId,
    String submissionText,
  ) async {
    try {
      await assignmentsRef.doc(assignmentId).update({
        'submission': submissionText,
      });
    } catch (e) {
      logger.e("Error submitting assignment: $e"); // Use logger for error
    }
  }
}
