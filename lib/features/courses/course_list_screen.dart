import 'package:flutter/material.dart';
import '../../features/courses/course.dart';
import '../../widgets/course_card.dart';

class CourseListScreen extends StatelessWidget {
  final List<Course> courses;

  const CourseListScreen({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int crossAxisCount = 4;

    // Make it responsive
    if (size.width < 600) {
      crossAxisCount = 1;
    } else if (size.width < 900) {
      crossAxisCount = 2;
    } else if (size.width < 1200) {
      crossAxisCount = 3;
    }

    // Calculate width for each card
    final double cardWidth = (size.width - (16 * (crossAxisCount + 1))) / crossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: courses.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: cardWidth / 300, // Adjust aspect ratio for smaller cards
          ),
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(course: course, width: cardWidth);
          },
        ),
      ),
    );
  }
}
