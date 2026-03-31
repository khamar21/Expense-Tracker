import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Analytics", style: TextStyle(color: Colors.black)),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔘 FILTER TABS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tab("Monthly", true),
                tab("Weekly", false),
                tab("Yearly", false),
              ],
            ),

            const SizedBox(height: 20),

            /// 💜 TOTAL CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("TOTAL THIS MONTH",
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 8),
                  Text("\$4,285.50",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("+2.8% from last month",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 📊 SMALL CARDS
            Row(
              children: [
                smallCard("AVG DAILY", "\$142.68", Icons.show_chart),
                const SizedBox(width: 10),
                smallCard("TOP SPEND", "Dining", Icons.restaurant),
              ],
            ),

            const SizedBox(height: 20),

            /// PIE CHART
            const Text("Spending by Category",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          pieSection(40, Colors.blue),
                          pieSection(25, Colors.purple),
                          pieSection(35, Colors.green),
                        ],
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text("Last Month\n42%",
                      textAlign: TextAlign.center),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// BAR CHART
            const Text("Weekly Trends",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 150,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      bar(1, 5),
                      bar(2, 8),
                      bar(3, 4),
                      bar(4, 7),
                      bar(5, 6),
                      bar(6, 3),
                      bar(7, 5),
                    ],
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///  TAB
  Widget tab(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: selected ? Colors.white : Colors.black),
      ),
    );
  }

  ///  SMALL CARD
  Widget smallCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12)),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  /// PIE SECTION
  PieChartSectionData pieSection(double value, Color color) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: 25,
      showTitle: false,
    );
  }

  /// BAR
  BarChartGroupData bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 10,
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
        )
      ],
    );
  }
}