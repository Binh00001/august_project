import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_august/models/revenue_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

class RevenueBarChart extends StatelessWidget {
  final List<Revenue> revenues;

  const RevenueBarChart({Key? key, required this.revenues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          barTouchData: _barTouchData,
          titlesData: _titlesData(),
          borderData: FlBorderData(show: false),
          barGroups: _getBarGroups(),
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
        ),
      ),
    );
  }

  BarTouchData get _barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (BarChartGroupData group, int groupIndex,
              BarChartRodData rod, int rodIndex) {
            return BarTooltipItem(
              // Assuming rod.toY returns a double, round it and then format:
              _formatThousands(rod.toY.round()),
              const TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(revenues.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: revenues[index].revenue.toDouble(),
            gradient: const LinearGradient(
              colors: [
                AppColors.highChart,
                AppColors.lowChart,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          )
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  double _getMaxY() {
    return revenues.map((e) => e.revenue).reduce(max).toDouble() *
        1.2; // To ensure the maximum value fits nicely
  }

  FlTitlesData _titlesData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              List<String> monthAbbreviations = [
                'T1',
                'T2',
                'T3',
                'T4',
                'T5',
                'T6',
                'T7',
                'T8',
                'T9',
                '10',
                '11',
                '12'
              ];
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text(
                  monthAbbreviations[
                      int.parse(revenues[value.toInt()].month.substring(6)) -
                          1], // Corrects for 0-based index
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  String _formatThousands(int number) {
    if (number < 1000) {
      return number
          .toString(); // Return the original number if it's less than 1000
    } else {
      final formatter = NumberFormat(
          "#,##0'K'", "en_US"); // Creates a formatter for thousands with 'K'
      return formatter
          .format(number / 1000); // Formats the number divided by 1000
    }
  }
}
