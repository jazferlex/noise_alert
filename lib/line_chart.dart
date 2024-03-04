import 'package:fl_chart/fl_chart.dart';
import 'package:noise_alert/statspoint.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  
  final List<StatPoint> points;

  const LineChartWidget(this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              dotData: const FlDotData(show: false),
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              barWidth: 0,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red,
              ),

            )
          ],
          titlesData: const FlTitlesData( show: true),
          borderData: FlBorderData(show: false),
        ),
        duration: const Duration(milliseconds: 0),
      )
    );
  }
}