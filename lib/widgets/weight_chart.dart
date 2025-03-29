import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/weight_entry.dart';

class WeightChart extends StatelessWidget {
  final List<WeightEntry> entries;
  final double? goalWeight;
  final Function(WeightEntry) onEntryTapped;

  const WeightChart({
    Key? key,
    required this.entries,
    this.goalWeight,
    required this.onEntryTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'Add weight entries to see your progress',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Sort entries by date
    final sortedEntries = List<WeightEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Determine min and max values for chart
    double minY = sortedEntries.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    double maxY = sortedEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b);

    // Add padding to min and max
    final padding = (maxY - minY) * 0.1;
    minY = (minY - padding).clamp(0, double.infinity);
    maxY = maxY + padding;

    // If goal weight is set, adjust min/max values if needed
    if (goalWeight != null) {
      if (goalWeight! < minY) minY = goalWeight! - padding;
      if (goalWeight! > maxY) maxY = goalWeight! + padding;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weight Trend',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 2,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor.withAlpha(77),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor.withAlpha(77),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < sortedEntries.length) {
                              final date = sortedEntries[value.toInt()].date;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('MM/dd').format(date),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                          interval: _calculateXInterval(sortedEntries.length),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                        right: const BorderSide(color: Colors.transparent),
                        top: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    minX: 0,
                    maxX: sortedEntries.length - 1.0,
                    minY: minY,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final entry = sortedEntries[spot.x.toInt()];
                            return LineTooltipItem(
                              '${entry.weight.toStringAsFixed(1)} kg\n${DateFormat('MMM d, y').format(entry.date)}',
                              TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                        if (event is FlTapUpEvent && response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
                          final spotIndex = response.lineBarSpots!.first.x.toInt();
                          if (spotIndex >= 0 && spotIndex < sortedEntries.length) {
                            onEntryTapped(sortedEntries[spotIndex]);
                          }
                        }
                      },
                      handleBuiltInTouches: true,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(sortedEntries.length, (index) {
                          return FlSpot(index.toDouble(), sortedEntries[index].weight);
                        }),
                        isCurved: true,
                        barWidth: 3,
                        color: Theme.of(context).colorScheme.primary,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Theme.of(context).colorScheme.primary.withAlpha(26),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Theme.of(context).colorScheme.primary,
                              strokeWidth: 2,
                              strokeColor: Theme.of(context).colorScheme.surface,
                            );
                          },
                        ),
                      ),
                      // Goal weight line if available
                      if (goalWeight != null)
                        LineChartBarData(
                          spots: [
                            FlSpot(0, goalWeight!),
                            FlSpot(sortedEntries.length - 1.0, goalWeight!),
                          ],
                          isCurved: false,
                          barWidth: 2,
                          color: Theme.of(context).colorScheme.tertiary,
                          dotData: const FlDotData(show: false),
                          dashArray: [5, 5],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateXInterval(int totalPoints) {
    if (totalPoints <= 5) return 1;
    if (totalPoints <= 10) return 2;
    if (totalPoints <= 20) return 4;
    return (totalPoints / 5).ceil().toDouble();
  }
} 