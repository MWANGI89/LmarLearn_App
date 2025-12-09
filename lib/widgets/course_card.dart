import 'package:flutter/material.dart';
import '../features/courses/course.dart';
import '../features/courses/course_detail_screen.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final double width;

  const CourseCard({
    super.key,
    required this.course,
    this.width = 230,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard>
    with SingleTickerProviderStateMixin {
  bool hover = false;
  bool pressed = false;
  bool bookmarked = false;
  bool imageLoaded = false;

  double tiltX = 0;
  double tiltY = 0;

  late AnimationController glowController;

  @override
  void initState() {
    super.initState();
    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    glowController.dispose();
    super.dispose();
  }

  void updateTilt(PointerEvent e) {
    if (widget.width < 300) return; // disable tilt for small cards/mobile
    final dx = (e.localPosition.dx - widget.width / 2) / widget.width;
    final dy = (e.localPosition.dy - 165) / 330;
    setState(() {
      tiltX = dy * 0.25;
      tiltY = -dx * 0.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CourseDetailScreen(course: widget.course),
        ),
      ),
      child: MouseRegion(
        onHover: updateTilt,
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() {
          hover = false;
          tiltX = 0;
          tiltY = 0;
        }),
        child: Listener(
          onPointerDown: (_) => setState(() => pressed = true),
          onPointerUp: (_) => setState(() => pressed = false),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            scale: pressed
                ? 0.97
                : hover && !isMobile
                    ? 1.05
                    : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: widget.width,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(tiltX)
                ..rotateY(tiltY),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 2,
                  color: hover
                      ? Colors.blueAccent.withOpacity(0.6)
                      : Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: hover
                        ? Colors.blueAccent.withOpacity(0.4)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: hover ? 25 : 10,
                    spreadRadius: hover ? 2 : 1,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE + BOOKMARK
                    Stack(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: imageLoaded ? 1 : 0,
                          child: Image.asset(
                            "assets/courseimages/${widget.course.imageUrl}",
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, _) {
                              if (frame == null) return shimmer();
                              if (!imageLoaded) {
                                Future.delayed(
                                    const Duration(milliseconds: 50), () {
                                  if (mounted) setState(() => imageLoaded = true);
                                });
                              }
                              return child;
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => bookmarked = !bookmarked);
                              glowController.forward(from: 0);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: bookmarked
                                        ? Colors.blueAccent.withOpacity(0.5)
                                        : Colors.black.withOpacity(0.2),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: AnimatedBuilder(
                                animation: glowController,
                                builder: (_, __) {
                                  final glow = bookmarked ? glowController.value * 6 : 0;
                                  return Icon(
                                    bookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_outline,
                                    color: Colors.blueAccent,
                                    size: 22.0 + glow,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // TEXT CONTENT
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.course.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.width < 200 ? 14 : 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.course.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: widget.width < 200 ? 10 : 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.star, size: 16, color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text(
                                    "4.8",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${widget.course.enrollmentCount} enrolled",
                                style: TextStyle(
                                  fontSize: widget.width < 200 ? 10 : 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget shimmer() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
