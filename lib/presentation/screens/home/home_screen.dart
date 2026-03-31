import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../add_expense/add_expense_page.dart';
import '../splash/splash_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedFilter = 'All';
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  final List<_ExpenseItem> expenses = const [
    _ExpenseItem(
      title: 'Starbucks',
      category: 'Food',
      amount: '250',
      time: '10:45 AM',
      icon: Icons.local_cafe,
      color: Colors.orange,
    ),
    _ExpenseItem(
      title: 'Zara Fashion',
      category: 'Shopping',
      amount: '4200',
      time: '04:20 PM',
      icon: Icons.shopping_bag,
      color: Colors.blue,
    ),
    _ExpenseItem(
      title: 'Uber Ride',
      category: 'Travel',
      amount: '850',
      time: 'Yesterday',
      icon: Icons.directions_car,
      color: Colors.green,
    ),
    _ExpenseItem(
      title: 'Electricity Bill',
      category: 'Bills',
      amount: '3100',
      time: '2 days ago',
      icon: Icons.receipt,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = selectedFilter == 'All'
        ? expenses
        : expenses
              .where((expense) => expense.category == selectedFilter)
              .toList();
    final totalBalance = expenses.fold<double>(
      0,
      (sum, expense) => sum + (double.tryParse(expense.amount) ?? 0),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Alex Johnson'),
              accountEmail: const Text('alex.johnson@email.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Name'),
              subtitle: const Text('Alex Johnson'),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email'),
              subtitle: const Text('alex.johnson@email.com'),
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Phone'),
              subtitle: const Text('+91 98765 43210'),
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      /// 🔽 BODY
      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu),
                      );
                    },
                  ),
                  // const CircleAvatar(
                  //   backgroundColor: Color(0xFFF2F3F7),
                  //   child: Icon(Icons.person, color: Colors.orange),
                  // ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, User 👋",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   "October 24, 2023",
                        //   style: TextStyle(fontSize: 12, color: Colors.grey),
                        // ),
                      ],
                    ),
                  ),
                 // const Icon(Icons.notifications_none),
                ],
              ),
            ),

            /// 💳 TOTAL CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TOTAL BALANCE",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currencyFormatter.format(totalBalance),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Chip(
                        label: Text(
                          "${expenses.length} entries",
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.white24,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔘 FILTER CHIPS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChip('All'),
                _buildChip('Food'),
                _buildChip('Travel'),
                _buildChip('Shopping'),
              ],
            ),

            const SizedBox(height: 16),

            /// 🧾 LIST HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Activity",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => setState(() => selectedFilter = 'All'),
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
                      "SEE ALL",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            ///  LIST
            Expanded(
              child: ListView(
                children: filteredExpenses
                    .map(
                      (expense) => ExpenseTile(
                        title: expense.title,
                        category: expense.category,
                        amount: expense.amount,
                        time: expense.time,
                        icon: expense.icon,
                        color: expense.color,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),

      ///  FLOATING BUTTON
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddExpensePage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    final isSelected = selectedFilter == text;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = text),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
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
  final IconData icon;
  final Color color;

  const _ExpenseItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
    required this.icon,
    required this.color,
  });
}

/// 💳 EXPENSE TILE
class ExpenseTile extends StatelessWidget {
  final String title, category, amount, time;
  final IconData icon;
  final Color color;

  const ExpenseTile({
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withAlpha(38),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 10),

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

          Text(
            "- ₹$amount",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
