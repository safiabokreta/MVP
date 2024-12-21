import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LikesPlot extends StatelessWidget {
  const LikesPlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Likes Over Months',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.favorite, color: Colors.pink, size: 20),
              ],
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          );
                          return Text(value.toInt().toString(), style: style);
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          );
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Jan', style: style);
                            case 1:
                              return const Text('Feb', style: style);
                            case 2:
                              return const Text('Mar', style: style);
                            case 3:
                              return const Text('Apr', style: style);
                            case 4:
                              return const Text('May', style: style);
                            case 5:
                              return const Text('Jun', style: style);
                            case 6:
                              return const Text('Jul', style: style);
                            case 7:
                              return const Text('Aug', style: style);
                            case 8:
                              return const Text('Sep', style: style);
                            case 9:
                              return const Text('Oct', style: style);
                            case 10:
                              return const Text('Nov', style: style);
                            case 11:
                              return const Text('Dec', style: style);
                            default:
                              return const Text('', style: style);
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                      left: BorderSide(color: Colors.black, width: 1),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 400,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 50),
                        FlSpot(1, 150),
                        FlSpot(2, 100),
                        FlSpot(3, 200),
                        FlSpot(4, 50),
                        FlSpot(5, 300),
                        FlSpot(6, 250),
                        FlSpot(7, 350),
                        FlSpot(8, 200),
                        FlSpot(9, 300),
                        FlSpot(10, 100),
                        FlSpot(11, 150),
                      ],
                      isCurved: true,
                      color: Colors.pink,
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: false, // Set to false to remove the fill
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}