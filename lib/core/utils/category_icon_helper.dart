import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Helper function to get icon for expense category
IconData getCategoryIcon(String category) {
  const categoryIcons = {
    'Food': Icons.restaurant_rounded,
    'Groceries': Icons.shopping_cart_rounded,
    'Travel': Icons.directions_car_rounded,
    'Transport': Icons.directions_transit_rounded,
    'Entertainment': Icons.movie_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Dining': Icons.local_dining_rounded,
    'Health': Icons.health_and_safety_rounded,
    'Medical': Icons.local_hospital_rounded,
    'Fitness': Icons.fitness_center_rounded,
    'Utilities': Icons.bolt_rounded,
    'Bills': Icons.receipt_rounded,
    'Education': Icons.school_rounded,
    'Games': Icons.sports_esports_rounded,
    'Books': Icons.book_rounded,
    'Subscription': Icons.subscriptions_rounded,
    'Fuel': Icons.local_gas_station_rounded,
  };

  return categoryIcons[category] ?? Icons.shopping_bag_rounded;
}

/// Helper function to get color for expense category
Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'food':
    case 'groceries':
      return Colors.orange;
    case 'shopping':
      return Colors.blue;
    case 'transport':
    case 'travel':
      return Colors.green;
    case 'bills':
      return Colors.purple;
    default:
      return AppColors.primary;
  }
}
