import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReviewsChart extends StatelessWidget {
  const ReviewsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalUsers = 100; // Example total number of users

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'My Total Reviews',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Row(
                children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 16)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Total Users: $totalUsers',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.pink.shade200,
                          value: 10,
                          title: '',
                          radius: 40,
                          borderSide: BorderSide(color: Colors.pink.shade200.withOpacity(0.5), width: 2),
                        ),
                        PieChartSectionData(
                          color: Colors.pink.shade400,
                          value: 20,
                          title: '',
                          radius: 40,
                          borderSide: BorderSide(color: Colors.pink.shade400.withOpacity(0.5), width: 2),
                        ),
                        PieChartSectionData(
                          color: Colors.purple.shade200,
                          value: 30,
                          title: '',
                          radius: 40,
                          borderSide: BorderSide(color: Colors.purple.shade200.withOpacity(0.5), width: 2),
                        ),
                        PieChartSectionData(
                          color: Colors.purple.shade400,
                          value: 25,
                          title: '',
                          radius: 40,
                          borderSide: BorderSide(color: Colors.purple.shade400.withOpacity(0.5), width: 2),
                        ),
                        PieChartSectionData(
                          color: Colors.blue.shade200,
                          value: 15,
                          title: '',
                          radius: 40,
                          borderSide: BorderSide(color: Colors.blue.shade200.withOpacity(0.5), width: 2),
                        ),
                      ],
                      centerSpaceRadius: 30,
                      sectionsSpace: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendItem(color: Colors.pink.shade200, text: '1 Star'),
                  LegendItem(color: Colors.pink.shade400, text: '2 Stars'),
                  LegendItem(color: Colors.purple.shade200, text: '3 Stars'),
                  LegendItem(color: Colors.purple.shade400, text: '4 Stars'),
                  LegendItem(color: Colors.blue.shade200, text: '5 Stars'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({Key? key, required this.color, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}