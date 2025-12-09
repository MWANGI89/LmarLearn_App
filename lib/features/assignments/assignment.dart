class Assignment {
  final String id;
  final String title;
  final String description;
  final String studentId;      // Assigned student
  final String? courseId;      // Optional: assignment belongs to a course
  final String? submission;    // Optional: student's submission answer

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.studentId,
    this.courseId,
    this.submission,
  });

  factory Assignment.fromMap(String id, Map<String, dynamic> data) {
    return Assignment(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      studentId: data['studentId'] ?? '',
      courseId: data['courseId'],
      submission: data['submission'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'studentId': studentId,
        'courseId': courseId,
        'submission': submission,
      };
}
