import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0D0F14);
  static const surface = Color(0xFF151820);
  static const surface2 = Color(0xFF1C2030);
  static const surface3 = Color(0xFF232840);
  static const accent = Color(0xFF6C63FF);
  static const accent2 = Color(0xFF00D4AA);
  static const accent3 = Color(0xFFFF6B6B);
  static const text1 = Color(0xFFF0F2FF);
  static const text2 = Color(0xFF9AA3C8);
  static const text3 = Color(0xFF5A6380);
  static const border = Color(0xFF1E2340);
  static const cardBlue = Color(0xFF1A2A4A);
  static const cardGreen = Color(0xFF0D3028);
  static const cardPurple = Color(0xFF1E1A40);
  static const cardRed = Color(0xFF3A1A1A);
  static const cardAmber = Color(0xFF2A2010);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accent2,
        surface: AppColors.surface,
        error: AppColors.accent3,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.text1,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.text2),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.text3,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
