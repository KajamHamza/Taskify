import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'legend_item.dart';

class PieChartWidget extends StatelessWidget {
  final int completedCount;
  final int pendingCount;
  final int cancelledCount;

  const PieChartWidget({
    Key? key,
    required this.completedCount,
    required this.pendingCount,
    required this.cancelledCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = completedCount + pendingCount + cancelledCount;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: completedCount.toDouble(),
                  color: Colors.blue,
                  radius: 50,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: pendingCount.toDouble(),
                  color: Colors.blue.shade200,
                  radius: 50,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: cancelledCount.toDouble(),
                  color: Colors.blue.shade100,
                  radius: 50,
                  showTitle: false,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendItem(color: Colors.blue, label: 'Completed'),
            const SizedBox(width: 16),
            LegendItem(color: Colors.blue.shade200, label: 'Pending', isLight: true),
            const SizedBox(width: 16),
            LegendItem(color: Colors.blue.shade100, label: 'Cancelled', isLighter: true),
          ],
        ),
      ],
    );
  }
}
