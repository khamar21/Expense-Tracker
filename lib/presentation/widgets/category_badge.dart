import 'package:flutter/material.dart';
import '../../core/utils/category_icon_helper.dart';

/// Reusable Category Badge Widget
///
/// Displays a category with color-coded badge. Perfect for category chips, tags, and labels.
///
/// Example:
/// ```dart
/// CategoryBadge(category: 'Food')
/// CategoryBadge(category: 'Travel', variant: 'filled')
/// CategoryBadge(category: 'Shopping', size: 'small')
/// ```
class CategoryBadge extends StatelessWidget {
  final String category;
  final String variant; // 'filled', 'outlined', 'soft'
  final String size; // 'small', 'medium', 'large'

  const CategoryBadge({
    super.key,
    required this.category,
    this.variant = 'soft',
    this.size = 'medium',
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(category);

    // Size configuration
    late double paddingHorizontal, paddingVertical, fontSize;
    switch (size) {
      case 'small':
        paddingHorizontal = 10;
        paddingVertical = 6;
        fontSize = 11;
        break;
      case 'large':
        paddingHorizontal = 16;
        paddingVertical = 10;
        fontSize = 14;
        break;
      case 'medium':
      default:
        paddingHorizontal = 12;
        paddingVertical = 8;
        fontSize = 12;
    }

    // Variant configuration
    late Color backgroundColor, textColor, borderColor;
    switch (variant) {
      case 'filled':
        backgroundColor = categoryColor;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case 'outlined':
        backgroundColor = Colors.transparent;
        textColor = categoryColor;
        borderColor = categoryColor;
        break;
      case 'soft':
      default:
        backgroundColor = categoryColor.withAlpha(25);
        textColor = categoryColor;
        borderColor = Colors.transparent;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
