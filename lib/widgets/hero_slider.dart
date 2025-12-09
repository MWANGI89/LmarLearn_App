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
import '../../features/courses/course.dart';

class HeroSlider extends StatefulWidget {
  final List<Map<String, String>> slides;
  final List<Course>? courses;
  final double height;

  const HeroSlider({
    super.key,
    required this.slides,
    this.courses,
    this.height = 500,
  });

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  Timer? _sliderTimer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!mounted || !_pageController.hasClients) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;

        _currentPage = (_currentPage + 1) % widget.slides.length;

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );

        if (mounted) _fadeController.forward(from: 0);
      });
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.slides.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 10,
          width: isActive ? 22 : 10,
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.white70,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SizedBox(
      height: widget.height + 80,
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.slides.length,
                  onPageChanged: (index) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      setState(() => _currentPage = index);
                      _fadeController.forward(from: 0);
                    });
                  },
                  itemBuilder: (_, index) {
                    final slide = widget.slides[index];
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(slide['image']!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha((0.45 * 255).round()),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 16 : 32,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  slide['title']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isMobile ? 22 : 34,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  slide['description']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: _buildPageIndicators(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
