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
 * The above copyright notice shall be included in all copies or substantial portions of the Software.
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
import '../../widgets/hover_button.dart';
import '../../widgets/course_card.dart' as course_card;
import '../courses/course_list_screen.dart';
import '../../widgets/hero_slider.dart';
import '../courses/medical_courses.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  int hoverIndex = -1;
  String? userName;

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

  @override
  void initState() {
    super.initState();
    _checkUserRedirect();
  }

  Future<void> _checkUserRedirect() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userData = await _authService.getUserData(user.uid);
      if (userData == null) return;

      final role = (userData['role'] ?? '').toString().toLowerCase();
      setState(() {
        userName = userData['name'] ?? user.email?.split('@')[0] ?? 'User'; // Fallback to email username
      });

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
              HoverButton(text: "Terms of Service", onPressed: () {}),
              const SizedBox(width: 12),
              HoverButton(text: "Privacy Policy", onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _animatedCourseButton(VoidCallback onPressed, String text, {Color? color}) {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        bool isHovered = false;
        return MouseRegion(
          onEnter: (_) => setLocalState(() => isHovered = true),
          onExit: (_) => setLocalState(() => isHovered = false),
          child: AnimatedScale(
            scale: isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: (color ?? Colors.blueAccent).withAlpha(64),
                          blurRadius: 12,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color ?? Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(text, style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        );
      },
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
          // NAVBAR
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/logo/Lmar_Logo_icon-nobg.png', height: 40),
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
                          ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                            child: const Text('Home'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseListScreen(courses: medicalCourses),
                                ),
                              );
                            },
                            child: const Text('Courses'),
                          ),
                          const SizedBox(width: 5),
                          if (user == null) ...[
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              child: const Text('Login'),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/sign-up'),
                              child: const Text('Sign Up'),
                            ),
                          ] else ...[
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                if (value == 'logout') {
                                  _authService.logout();
                                  setState(() {});
                                } else if (value == 'dashboard') {
                                  Navigator.pushNamed(context, '/dashboard');
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: 'dashboard',
                                    child: Text('Dashboard'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'profile',
                                    child: Text('Profile'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'logout',
                                    child: Text('Logout'),
                                  ),
                                ];
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Hello, ${userName ?? 'User'}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
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

          // HERO SLIDER
          SliverToBoxAdapter(
            child: HeroSlider(
              slides: heroSlides,
              courses: medicalCourses,
              height: isMobile ? 300 : 500,
            ),
          ),

          // MEDICAL COURSES GRID
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Medical Courses",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double width = constraints.maxWidth;
                      int crossAxisCount = 5;
                      if (width < 500) {crossAxisCount = 1;
                        crossAxisCount = 1;
                      } else if (width < 800) {
                        crossAxisCount = 2;
                      } else if (width < 1100) {
                        crossAxisCount = 3;
                      } else if (width < 1400) {
                        crossAxisCount = 4;
                      }
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
                                    onEnter: (_) { if (mounted) setState(() { hoverIndex = index; }); },
                                    onExit: (_) { if (mounted) setState(() { hoverIndex = -1; }); },
                                    child: AnimatedScale(
                                      scale: hoverIndex == index ? 1.05 : 1.0,
                                      duration: const Duration(milliseconds: 180),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 180),
                                        decoration: BoxDecoration(
                                          boxShadow: hoverIndex == index
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.blue.withAlpha(64),
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
                    child: _animatedCourseButton(
                      () {
                        hoverIndex = -1;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseListScreen(courses: medicalCourses),
                          ),
                        );
                      },
                      "View All Courses",
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FLOATING BUTTONS
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 110,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.35),
                    Colors.lightBlue.withOpacity(0.35),
                    Colors.blue.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.7),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.45),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Home", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseListScreen(courses: medicalCourses),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Courses", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          // LEGAL FOOTER
          SliverToBoxAdapter(child: _buildLegalFooter()),
        ],
      ),
    );
  }
}
/// Extension to replace deprecated .withOpacity()
extension ColorAlphaExtension on Color {
  Color withAlpha(double alpha) {
    assert(alpha >= 0.0 && alpha <= 1.0, 'Alpha must be between 0.0 and 1.0');
    return this.withAlpha((alpha * 255).round());
  }
}
