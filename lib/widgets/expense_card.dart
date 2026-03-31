import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(category),
            ],
          ),
          Text("- ₹$amount",
              style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}