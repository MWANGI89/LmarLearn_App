import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../features/courses/course.dart';

class InteractiveChart extends StatefulWidget {
  final List<Course> courses;

  const InteractiveChart({super.key, required this.courses});

  @override
  InteractiveChartState createState() => InteractiveChartState();
}

class InteractiveChartState extends State<InteractiveChart> {
  int? touchedIndex; // Track which bar is touched

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final barWidth = (chartWidth / widget.courses.length) * 0.18;

        return SizedBox(
          height: 280,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxEnrollCount(),
              minY: 0,
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchCallback: (event, response) {
                  if (response == null || response.spot == null) {
                    setState(() => touchedIndex = null);
                    return;
                  }
                  setState(() => touchedIndex = response.spot!.touchedBarGroupIndex);
                },
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) =>
                      isDark ? Colors.grey[850]! : Colors.white,
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${widget.courses[groupIndex].title}\n',
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: '${rod.toY.toInt()} students',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= widget.courses.length) {
                        return const SizedBox.shrink();
                      }
                      return Transform.rotate(
                        angle: -0.8,
                        child: Text(
                          widget.courses[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _buildBars(barWidth),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: isDark ? Colors.white12 : Colors.black12,
                    strokeWidth: 1,
                  );
                },
              ),
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          ),
        );
      },
    );
  }

  Color _courseColor(int index) {
    final colors = [
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.redAccent,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  List<BarChartGroupData> _buildBars(double width) {
    return List.generate(
      widget.courses.length,
      (i) {
        final isTouched = i == touchedIndex;
        final double height = isTouched
            ? widget.courses[i].enrollmentCount.toDouble() * 1.05
            : widget.courses[i].enrollmentCount.toDouble();

        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: height,
              width: width,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              gradient: LinearGradient(
                colors: [
                  _courseColor(i).withValues(alpha: isTouched ? 1.0 : 0.9),
                  _courseColor(i).withValues(alpha: isTouched ? 0.7 : 0.5),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _getMaxEnrollCount(),
                color: Colors.grey.withValues(alpha: 0.1),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getMaxEnrollCount() {
    if (widget.courses.isEmpty) return 100;
    return (widget.courses
                .map((c) => c.enrollmentCount)
                .reduce((a, b) => a > b ? a : b) +
            20)
        .toDouble();
  }
}

extension ColorExtension on Color {
  Color withValues({required double alpha}) {
    return withAlpha((alpha * 255).round());
  }
}
