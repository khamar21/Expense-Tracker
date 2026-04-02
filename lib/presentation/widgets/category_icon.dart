import 'package:flutter/material.dart';
import '../../core/utils/category_icon_helper.dart';

/// Reusable Category Icon Widget
///
/// Displays a category-specific icon based on the category name.
///
/// Example:
/// ```dart
/// CategoryIcon(category: 'Food')
/// CategoryIcon(category: 'Travel', size: 32)
/// ```
class CategoryIcon extends StatelessWidget {
  final String category;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 46,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(category);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? categoryColor.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Icon(getCategoryIcon(category), color: iconColor ?? categoryColor),
    );
  }
}
