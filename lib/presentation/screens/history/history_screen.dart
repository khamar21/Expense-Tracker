import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/category_icon_helper.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../providers/expense_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late DateTimeRange _selectedDateRange;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _selectedDateRange = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
  }

  String get _formattedDateRange {
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    return '${formatter.format(_selectedDateRange.start)} - ${formatter.format(_selectedDateRange.end)}';
  }

  List<ExpenseEntity> _filteredExpenses(List<ExpenseEntity> expenses) {
    final DateTime start = DateTime(
      _selectedDateRange.start.year,
      _selectedDateRange.start.month,
      _selectedDateRange.start.day,
    );
    final DateTime endExclusive = DateTime(
      _selectedDateRange.end.year,
      _selectedDateRange.end.month,
      _selectedDateRange.end.day + 1,
    );

    final byDate = expenses
        .where(
          (expense) =>
              !expense.date.isBefore(start) &&
              expense.date.isBefore(endExclusive),
        )
        .toList();

    if (_selectedCategory == 'All') {
      return byDate;
    }

    return byDate
        .where((expense) => expense.category == _selectedCategory)
        .toList();
  }

  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: _selectedDateRange,
      helpText: 'Select date range',
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseProvider);
    final filteredExpenses = _filteredExpenses(expenses);
    final categories = <String>{
      'All',
      ...expenses.map((e) => e.category),
    }.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFF4F7FB)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -70,
                right: -45,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondary.withAlpha(35),
                        AppColors.primary.withAlpha(8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: -65,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withAlpha(16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                    child: Row(
                      children: [
                        // Container(
                        //   width: 44,
                        //   height: 44,
                        //   // decoration: BoxDecoration(
                        //   //   color: Colors.white,
                        //   //   borderRadius: BorderRadius.circular(14),
                        //   //   boxShadow: const [
                        //   //     BoxShadow(
                        //   //       color: Color(0x12000000),
                        //   //       blurRadius: 12,
                        //   //       offset: Offset(0, 6),
                        //   //     ),
                        //   //   ],
                        //   // ),
                        //   // child: const Icon(
                        //   //   Icons.history,
                        //   //   color: AppColors.primary,
                        //   // ),
                        // ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expense History',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Review your spending across any date range',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x12000000),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.notifications_none),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x335B67FF),
                            blurRadius: 24,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DATE RANGE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _formattedDateRange,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: _pickDateRange,
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Change',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white24,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: categories
                            .map((category) => _chip(category))
                            .toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TRANSACTIONS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              filteredExpenses.isEmpty
                                  ? 'No items in this range'
                                  : '${filteredExpenses.length} items shown',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () =>
                              setState(() => _selectedCategory = 'All'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'RESET',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: filteredExpenses.isEmpty
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'No expenses in selected range/category',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            itemCount: filteredExpenses.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 2),
                            itemBuilder: (context, index) {
                              final expense = filteredExpenses[index];
                              return ExpenseCard(
                                title: expense.title,
                                category: expense.category,
                                amount: expense.amount.toStringAsFixed(2),
                                time: DateFormat(
                                  'hh:mm a',
                                ).format(expense.date),
                                icon: getCategoryIcon(expense.category),
                                color: getCategoryColor(expense.category),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CHIP
  Widget _chip(String text) {
    final bool selected = _selectedCategory == text;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = text;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF1F4F9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x225B67FF),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ]
              : const [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// 🏷 SECTION TITLE
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 💳 EXPENSE CARD
class ExpenseCard extends StatelessWidget {
  final String title, category, amount, time;
  final IconData icon;
  final Color color;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 10),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$category • $time",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// AMOUNT
          Text(
            "- ₹$amount",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
