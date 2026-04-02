import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../providers/expense_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String selectedPeriod = 'Monthly';

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseProvider);
    final filteredExpenses = _filterExpensesByPeriod(expenses);
    final categoryTotals = _groupExpensesByCategory(filteredExpenses);
    final slices = _buildPieSlices(categoryTotals);
    final totalSpent = filteredExpenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    final trendBars = _buildTrendBars(filteredExpenses);
    final periodRangeLabel = _periodRangeLabel();
    final topCategory = slices.isEmpty ? null : slices.first;
    final averageDaily = _calculateAverageDaily(filteredExpenses);

    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        // leading: IconButton(
        //   onPressed: () => Navigator.of(context).maybePop(),
        //   icon: const Icon(
        //     Icons.arrow_back_ios_new_rounded,
        //     color: Colors.black,
        //   ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Text(
                selectedPeriod,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Positioned(
            //   top: -80,
            //   right: -70,
            //   child: _ambientBlob(const [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
            // ),
            // Positioned(
            //   top: 110,
            //   left: -90,
            //   child: _ambientBlob(const [
            //     Color(0xFF22C55E),
            //     Color(0xFF06B6D4),
            //   ], size: 170),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroCard(
                    selectedPeriod: selectedPeriod,
                    periodRangeLabel: periodRangeLabel,
                    totalSpent: totalSpent,
                    topCategory: topCategory,
                  ),

                  const SizedBox(height: 16),

                  _buildSectionHeader(
                    title: 'Select period',
                    subtitle: 'Switch the data view for the charts below.',
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(child: tab('Monthly')),
                        Expanded(child: tab('Weekly')),
                        Expanded(child: tab('Yearly')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      smallCard(
                        selectedPeriod == 'Yearly'
                            ? 'AVG / DAY (YEAR)'
                            : 'AVG DAILY',
                        '₹${averageDaily.toStringAsFixed(2)}',
                        Icons.show_chart_rounded,
                      ),
                      const SizedBox(width: 12),
                      smallCard(
                        'TOP SPEND',
                        topCategory?.label ?? 'None',
                        Icons.local_fire_department_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildSectionHeader(
                    title: 'Spending by category',
                    subtitle: '$selectedPeriod overview for $periodRangeLabel',
                  ),

                  const SizedBox(height: 10),

                  _analyticsCard(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 190,
                          child: slices.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No expense data yet',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : PieChart(
                                  PieChartData(
                                    sections: slices
                                        .map(
                                          (slice) => pieSection(
                                            slice.percentage,
                                            slice.color,
                                            '${slice.percentage.toStringAsFixed(0)}%',
                                          ),
                                        )
                                        .toList(),
                                    sectionsSpace: 3,
                                    centerSpaceRadius: 52,
                                    startDegreeOffset: -90,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                totalSpent == 0
                                    ? 'No expenses recorded'
                                    : 'Total spent: ₹${totalSpent.toStringAsFixed(2)}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                              if (topCategory != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Top category: ${topCategory.label}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        if (slices.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: slices
                                .map(
                                  (slice) => _LegendItem(
                                    color: slice.color,
                                    label: slice.label,
                                    value:
                                        '${slice.percentage.toStringAsFixed(0)}%',
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildSectionHeader(
                    title: '$selectedPeriod trend',
                    subtitle: 'Compare how spending changes over time.',
                  ),

                  const SizedBox(height: 10),

                  _analyticsCard(
                    child: SizedBox(
                      height: 210,
                      child: BarChart(
                        BarChartData(
                          barGroups: trendBars,
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 50,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.black.withOpacity(0.04),
                              strokeWidth: 1,
                            ),
                          ),
                          barTouchData: BarTouchData(enabled: false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ExpenseEntity> _filterExpensesByPeriod(List<ExpenseEntity> expenses) {
    final now = DateTime.now();

    switch (selectedPeriod) {
      case 'Weekly':
        final startOfWeek = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return expenses
            .where(
              (expense) =>
                  !expense.date.isBefore(startOfWeek) &&
                  expense.date.isBefore(endOfWeek),
            )
            .toList();
      case 'Yearly':
        return expenses
            .where((expense) => expense.date.year == now.year)
            .toList();
      case 'Monthly':
      default:
        return expenses
            .where(
              (expense) =>
                  expense.date.year == now.year &&
                  expense.date.month == now.month,
            )
            .toList();
    }
  }

  double _calculateAverageDaily(List<ExpenseEntity> expenses) {
    if (expenses.isEmpty) return 0;

    final now = DateTime.now();
    final periodDays = switch (selectedPeriod) {
      'Weekly' => 7,
      'Yearly' =>
        now.year % 4 == 0 && (now.year % 100 != 0 || now.year % 400 == 0)
            ? 366
            : 365,
      _ => now.day,
    };

    final totalSpent = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    return totalSpent / periodDays;
  }

  String _periodRangeLabel() {
    final now = DateTime.now();

    switch (selectedPeriod) {
      case 'Weekly':
        final startOfWeek = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${_fmt(startOfWeek)} - ${_fmt(endOfWeek)}';
      case 'Yearly':
        return 'Jan ${now.year} - Dec ${now.year}';
      case 'Monthly':
      default:
        return '${_monthName(now.month)} ${now.year}';
    }
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  ///  TAB
  Widget tab(String text) {
    final bool selected = selectedPeriod == text;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          selectedPeriod = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  ///  SMALL CARD
  Widget smallCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _groupExpensesByCategory(List<ExpenseEntity> expenses) {
    final grouped = <String, double>{};

    for (final expense in expenses) {
      grouped.update(
        expense.category,
        (current) => current + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return grouped;
  }

  List<_PieSliceData> _buildPieSlices(Map<String, double> categoryTotals) {
    final total = categoryTotals.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );
    if (total == 0) return [];

    final entries = categoryTotals.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));

    return List.generate(entries.length, (index) {
      final entry = entries[index];
      return _PieSliceData(
        label: entry.key,
        amount: entry.value,
        percentage: (entry.value / total) * 100,
        color: _sliceColor(index),
      );
    });
  }

  List<BarChartGroupData> _buildTrendBars(List<ExpenseEntity> expenses) {
    final now = DateTime.now();

    if (selectedPeriod == 'Yearly') {
      final monthlyTotals = List<double>.filled(12, 0);
      for (final expense in expenses) {
        monthlyTotals[expense.date.month - 1] += expense.amount;
      }

      return List.generate(12, (index) => bar(index + 1, monthlyTotals[index]));
    }

    if (selectedPeriod == 'Weekly') {
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: now.weekday - 1));
      final dailyTotals = List<double>.filled(7, 0);

      for (final expense in expenses) {
        final dayOffset = expense.date.difference(startOfWeek).inDays;
        if (dayOffset >= 0 && dayOffset < 7) {
          dailyTotals[dayOffset] += expense.amount;
        }
      }

      return List.generate(7, (index) => bar(index + 1, dailyTotals[index]));
    }

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dailyTotals = List<double>.filled(daysInMonth, 0);
    for (final expense in expenses) {
      dailyTotals[expense.date.day - 1] += expense.amount;
    }

    return List.generate(
      daysInMonth,
      (index) => bar(index + 1, dailyTotals[index]),
    );
  }

  Color _sliceColor(int index) {
    const colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];

    return colors[index % colors.length];
  }

  /// PIE SECTION
  PieChartSectionData pieSection(double value, Color color, String title) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: 34,
      title: title,
      showTitle: true,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w700,
      ),
      titlePositionPercentageOffset: 0.6,
      borderSide: const BorderSide(color: Colors.white, width: 2),
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
          color: x % 2 == 0 ? AppColors.secondary : AppColors.primary,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y > 0 ? y : 1,
            color: Colors.black.withOpacity(0.04),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard({
    required String selectedPeriod,
    required String periodRangeLabel,
    required double totalSpent,
    required _PieSliceData? topCategory,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.24),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.insights_rounded, color: Colors.white),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  selectedPeriod,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Total spent this period',
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${totalSpent.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            periodRangeLabel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              topCategory == null
                  ? 'No expense data recorded yet'
                  : 'Top category: ${topCategory.label}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _analyticsCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _ambientBlob(List<Color> colors, {double size = 210}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [colors.first, colors.last]),
      ),
    );
  }
}

class _PieSliceData {
  const _PieSliceData({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  final String label;
  final double amount;
  final double percentage;
  final Color color;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($value)',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
