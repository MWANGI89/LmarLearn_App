import 'package:flutter/material.dart';
import '../../features/courses/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER IMAGE
            Image.asset(
              "assets/courseimages/${course.imageUrl}",
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Chip(
                        label: Text(course.level ?? 'Beginner'),
                        // Fixed: replaced with withAlpha
                        backgroundColor: Colors.blueAccent.withAlpha((0.2 * 255).round()),
                      ),
                      const SizedBox(width: 12),
                      Text("${course.enrollmentCount} enrolled"),
                      const SizedBox(width: 12),
                      Icon(Icons.star, color: Colors.amber.shade700),
                      Text(course.rating.toStringAsFixed(1)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text("Description",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),

                  Text(
                    course.description,
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 20),

                  if (course.instructor != null)
                    Text("Instructor: ${course.instructor}",
                        style: const TextStyle(fontSize: 16)),
                  if (course.duration != null)
                    Text("Duration: ${course.duration} hours",
                        style: const TextStyle(fontSize: 16)),
                  if (course.price != null)
                    Text("Price: \$${course.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enrollment pending backend setup."),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Enroll Now",
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
