import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTimeRange _selectedDateRange;
  String _selectedCategory = 'All';

  final List<_ExpenseItem> _expenses = const [
    _ExpenseItem(
      title: 'Apple Store',
      category: 'Shopping',
      amount: '999.00',
      time: '14:20 PM',
    ),
    _ExpenseItem(
      title: 'The Green Bistro',
      category: 'Dining',
      amount: '42.50',
      time: '12:30 PM',
    ),
    _ExpenseItem(
      title: 'Uber Trip',
      category: 'Travel',
      amount: '18.20',
      time: '21:15 PM',
    ),
    _ExpenseItem(
      title: 'Monthly Gym',
      category: 'Health',
      amount: '65.00',
      time: '09:00 AM',
    ),
  ];

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

  List<_ExpenseItem> get _filteredExpenses {
    if (_selectedCategory == 'All') {
      return _expenses;
    }

    return _expenses
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
    return Scaffold(
      backgroundColor: AppColors.bg,

      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFF2F3F7),
                    child: Icon(Icons.person, color: Colors.orange),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Expense Tracker",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            /// 🏷 TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "All Expenses",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Your curated financial narrative for this month.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// 📅 DATE FILTER
            InkWell(
              onTap: _pickDateRange,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(_formattedDateRange)),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// 🔘 FILTER CHIPS
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _chip("All"),
                  _chip("Shopping"),
                  _chip("Dining"),
                  _chip("Travel"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// 📋 LIST
            Expanded(
              child: _filteredExpenses.isEmpty
                  ? const Center(
                      child: Text(
                        'No expenses in this category',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView(
                      children: [
                        const SectionTitle('TRANSACTIONS'),
                        ..._filteredExpenses.map(
                          (expense) => ExpenseCard(
                            title: expense.title,
                            category: expense.category,
                            amount: expense.amount,
                            time: expense.time,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'SWIPE LEFT TO DELETE',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
              ),
            
          ],
        ),
      ),
    );
  }

  /// CHIP
  Widget _chip(String text) {
    final bool selected = _selectedCategory == text;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = text;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(color: selected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class _ExpenseItem {
  final String title;
  final String category;
  final String amount;
  final String time;

  const _ExpenseItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
  });
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
        ),
      ),
    );
  }
}

/// 💳 EXPENSE CARD
class ExpenseCard extends StatelessWidget {
  final String title, category, amount, time;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// ICON
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.shopping_bag),
          ),

          const SizedBox(width: 10),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "$category • $time",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// AMOUNT
          Text(
            "- \$$amount",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
