/*
 * MIT License
 * 
 * Copyright (c) 2025 Elijah Mwangi Mutiso (Founder of Ellines Tech)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/auth_service.dart';
import '../../models/app_user.dart';
import '../../features/courses/course.dart';
import '../../widgets/hover_button.dart';
import '../../widgets/course_card.dart' as course_card;
import '../courses/course_list_screen.dart';
import '../../widgets/hero_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  final List<Map<String, String>> heroSlides = [
    {
      'image': 'assets/pictures/learningnurse.jpg',
      'title': 'Empower Every Mind',
      'description': 'Lmar Learn - Your Ultimate Learning Companion.',
    },
    {
      'image': 'assets/pictures/LearnAnywhere.jpg',
      'title': 'Learn Anytime, Anywhere',
      'description': 'Access a world of knowledge anytime.',
    },
    {
      'image': 'assets/pictures/lecturenurse.jpg',
      'title': 'Connect & Learn',
      'description': 'Engage with lecturers and classmates.',
    },
  ];

  final List<Course> medicalCourses = [
    Course(
        id: '1',
        title: 'Basic Nursing',
        description: 'Learn fundamentals of nursing.',
        createdBy: 'Admin',
        imageUrl: 'img-2.jpg',
        level: 'Beginner',
        enrollmentCount: 120),
    Course(
        id: '2',
        title: 'Anatomy & Physiology',
        description: 'Deep dive into human anatomy.',
        createdBy: 'Admin',
        imageUrl: 'images.jpg',
        level: 'Intermediate',
        enrollmentCount: 95),
    Course(
        id: '3',
        title: 'Medical Ethics',
        description: 'Understand ethics in medical practice.',
        createdBy: 'Admin',
        imageUrl: 'premium.jpg',
        level: 'Advanced',
        enrollmentCount: 70),
    Course(
        id: '4',
        title: 'Pharmacology Basics',
        description: 'Introduction to pharmacology.',
        createdBy: 'Admin',
        imageUrl: 'maxresdefault.jpg',
        level: 'Beginner',
        enrollmentCount: 85),
    Course(
        id: '5',
        title: 'Patient Care Techniques',
        description: 'Best practices for patient care.',
        createdBy: 'Admin',
        imageUrl: 'maxresdefault.jpg',
        level: 'Intermediate',
        enrollmentCount: 110),
    Course(
        id: '6',
        title: 'Infection Control',
        description: 'Methods to prevent infections in healthcare.',
        createdBy: 'Admin',
        imageUrl: '7830105-612x612.jpg',
        level: 'Advanced',
        enrollmentCount: 60),
    Course(
        id: '7',
        title: 'Emergency Nursing',
        description: 'Handling emergencies in nursing.',
        createdBy: 'Admin',
        imageUrl: 'img-2.jpg',
        level: 'Advanced',
        enrollmentCount: 45),
    Course(
        id: '8',
        title: 'Pediatric Nursing',
        description: 'Caring for children in medical settings.',
        createdBy: 'Admin',
        imageUrl: 'images.jpg',
        level: 'Intermediate',
        enrollmentCount: 75),
    Course(
        id: '9',
        title: 'Geriatric Care',
        description: 'Specialized care for the elderly.',
        createdBy: 'Admin',
        imageUrl: 'premium.jpg',
        level: 'Beginner',
        enrollmentCount: 50),
    Course(
        id: '10',
        title: 'Mental Health Nursing',
        description: 'Supporting mental health in nursing practice.',
        createdBy: 'Admin',
        imageUrl: 'maxresdefault.jpg',
        level: 'Advanced',
        enrollmentCount: 40), 
    Course(
        id: '11',
        title: 'Surgical Nursing',
        description: 'Nursing care in surgical settings.',
        createdBy: 'Admin',
        imageUrl: '7830105-612x612.jpg',
        level: 'Intermediate',
        enrollmentCount: 55),
    Course(
        id: '12',
        title: 'Community Health Nursing',
        description: 'Promoting health in communities.',
        createdBy: 'Admin',
        imageUrl: 'img-2.jpg',
        level: 'Beginner',
        enrollmentCount: 65),
  ];

  int hoverIndex = -1;

  @override
  void initState() {
    super.initState();
    _checkUserRedirect();
  }

  Future<void> _checkUserRedirect() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      final userData = await _authService.getUserData(user.uid);
      if (userData == null) {
        return;
      }

      final role = (userData['role'] ?? '').toString().toLowerCase();

      final appUser = AppUser(
        id: user.uid,
        name: userData['name'] ?? '',
        email: userData['email'] ?? user.email ?? '',
        role: role,
        schoolId: userData['schoolId'] ?? '',
      );

      if (!mounted) return;

      switch (role) {
        case 'admin':
          _go('/admin-dashboard', appUser);
          break;
        case 'student':
          _go('/student-dashboard', appUser);
          break;
        case 'lecturer':
          _go('/lecturer-dashboard', appUser);
          break;
        case 'superadmin':
          _go('/superadmin-dashboard', appUser);
          break;
      }
    } catch (e) {
      debugPrint("Redirect Error: $e");
    }
  }

  void _go(String route, AppUser user) {
    Navigator.pushReplacementNamed(
      context,
      route,
      arguments: {'loggedUser': user},
    );
  }

  Widget _buildLegalFooter() {
    return Container(
      height: 90,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(color: Color(0xFF0D0D0D)),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset('assets/logo/Lmar_Logo_icon-nobg.png', height: 40),
              const SizedBox(width: 8),
              const Text(
                "Lmar Learn",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Developed & Designed by Ellines Tech",
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 5),
              Text("© Lmar Learn 2025", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              HoverButton(
                text: "Terms of Service",
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              HoverButton(
                text: "Privacy Policy",
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Navbar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo/Lmar_Logo_icon-nobg.png',
                        height: 40,
                      ),
                      const SizedBox(width: 9),
                      const Text(
                        'Lmar Learn',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/'),
                            child: const Text('Home'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Courses'),
                          ),
                          const SizedBox(width: 5),
                          if (user == null) ...[
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              child: const Text('Login'),
                            ),
                            const SizedBox(width: 5),
                            OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, '/sign-up'),
                              child: const Text('Sign Up'),
                            ),
                          ] else ...[
                            Text(
                              'Hello, ${user.email}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            OutlinedButton(
                              onPressed: () async {
                                await _authService.logout();
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              child: const Text('Logout'),
                            ),
                            const SizedBox(width: 5),
                            OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                              child: const Text('Dashboard'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hero Slider
          SliverToBoxAdapter(
            child: HeroSlider(
              slides: heroSlides,
              courses: medicalCourses,
              height: isMobile ? 300 : 500,
            ),
          ),

          // Medical Courses Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Medical Courses",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double width = constraints.maxWidth;
                      int crossAxisCount = 5;
                      if (width < 500) { crossAxisCount = 1; }
                      else if (width < 800) { crossAxisCount = 2; }
                      else if (width < 1100) { crossAxisCount = 3; }
                      else if (width < 1400) { crossAxisCount = 4; }
                      crossAxisCount = crossAxisCount.clamp(1, 5);

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: GridView.builder(
                          key: ValueKey(crossAxisCount),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: medicalCourses.length,
                          itemBuilder: (context, index) {
                            return TweenAnimationBuilder(
                              duration: Duration(milliseconds: 480 + index * 60),
                              tween: Tween<double>(begin: 0.85, end: 1),
                              curve: Curves.easeOutBack,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: MouseRegion(
                                    onEnter: (_) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (!mounted) return;
                                        setState(() => hoverIndex = index);
                                      });
                                    },
                                    onExit: (_) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (!mounted) return;
                                        setState(() => hoverIndex = -1);
                                      });
                                    },
                                    child: AnimatedScale(
                                      scale: hoverIndex == index ? 1.05 : 1.0,
                                      duration: const Duration(milliseconds: 180),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        decoration: BoxDecoration(
                                          boxShadow: hoverIndex == index
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.blue.withAlpha((0.25 * 255).round()),
                                                    blurRadius: 18,
                                                    spreadRadius: 2,
                                                  )
                                                ]
                                              : [],
                                        ),
                                        child: course_card.CourseCard(
                                          course: medicalCourses[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() => hoverIndex = -1);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseListScreen(courses: medicalCourses),
                            ),
                          );
                        });
                      },
                      child: const Text(
                        "View All Courses",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Buttons
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 110,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withAlpha((0.35 * 255).round()),
                    Colors.lightBlue.withAlpha((0.35 * 255).round()),
                    Colors.blue.withAlpha((0.30 * 255).round()),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.blueAccent.withAlpha((0.7 * 255).round()),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withAlpha((0.45 * 255).round()),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Home", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/sign-up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          // Legal Footer
          SliverToBoxAdapter(child: _buildLegalFooter()),
        ],
      ),
    );
  }
}
