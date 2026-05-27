import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartDataModel {
  final String label;
  final double value;
  final Color color;

  const PieChartDataModel({
    required this.label,
    required this.value,
    required this.color,
  });
}

class AppPieChart extends StatefulWidget {
  final List<PieChartDataModel> data;
  final double radius;
  final double centerSpaceRadius;
  final bool showLabels;
  final Widget? centerWidget; // 👈 thêm cái này

  const AppPieChart({
    super.key,
    required this.data,
    this.radius = 60,
    this.centerSpaceRadius = 40,
    this.showLabels = true,
    this.centerWidget,
  });

  @override
  State<AppPieChart> createState() => _AppPieChartState();
}

class _AppPieChartState extends State<AppPieChart> {
  int touchedIndex = -1;

  double get total => widget.data.fold(0, (sum, item) => sum + item.value);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: widget.centerSpaceRadius,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    final idx = response?.touchedSection?.touchedSectionIndex;
                    touchedIndex = idx ?? -1;
                  });
                },
              ),
              sections: _buildSections(),
            ),
          ),

          // =========================
          // CENTER TEXT
          // =========================
          widget.centerWidget ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    total.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      final isTouched = index == touchedIndex;

      return PieChartSectionData(
        value: item.value,
        color: item.color,
        radius: isTouched ? widget.radius + 10 : widget.radius,
        title: widget.showLabels ? '${item.value.toInt()}%' : '',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
