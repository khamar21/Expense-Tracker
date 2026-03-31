import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF5B67FF);
  static const bg = Color(0xFFF5F7FB);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.bg,
    useMaterial3: true,
  );
}