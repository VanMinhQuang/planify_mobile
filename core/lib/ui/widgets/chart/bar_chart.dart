import 'package:app_core/app_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartDataModel {
  final String label;
  final double value;
  final Color color;

  const BarChartDataModel({
    required this.label,
    required this.value,
    required this.color,
  });
}

class AppBarChart extends StatefulWidget {
  final List<BarChartDataModel> data;
  final double maxY;
  final bool showLabels;

  const AppBarChart({
    super.key,
    required this.data,
    this.maxY = 100,
    this.showLabels = true,
  });

  @override
  State<AppBarChart> createState() => _AppBarChartState();
}

class _AppBarChartState extends State<AppBarChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BarChart(
        BarChartData(
          maxY: widget.maxY,
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: false,
            touchCallback: (event, response) {
              setState(() {
                touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
              });
            },
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 60,
                showTitles: widget.showLabels,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i >= widget.data.length) return const SizedBox();
                  return Container(
                    width: 70.w,
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.data[i].label,
                      style: AppTextStyles.normal12(),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: _buildGroups(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildGroups() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      final isTouched = index == touchedIndex;

      return BarChartGroupData(
        x: index,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: item.value,
            width: isTouched ? 60.w : 60.w,
            color: item.color,
            borderRadius: BorderRadius.circular(8),
            label: BarChartRodLabel(
              text: item.value.formatNumberWithDots(),
              style: AppTextStyles.semiBold12(color: item.color),
            ),
          ),
        ],
      );
    }).toList();
  }
}

class AppHorizontalBarChart extends StatelessWidget {
  final List<BarChartDataModel> data;
  final double maxY;

  const AppHorizontalBarChart({super.key, required this.data, this.maxY = 100});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: AppTextStyles.normal12(),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 110.w,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i >= data.length) return const SizedBox();
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        data[i].label,
                        style: AppTextStyles.normal12(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: data.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.value,
                  width: 16,
                  color: e.value.color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
        ),
        swapAnimationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
