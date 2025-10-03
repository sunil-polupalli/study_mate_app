import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme Colors
  static const Color primaryColor = Color(0xFF8B5CF6); // Electric Purple
  static const Color secondaryColor = Color(0xFF06D6A0); // Teal
  static const Color accentColor = Color(0xFFFF6B35); // Orange
  static const Color backgroundPrimary = Color(0xFF0F0F1E); // Deep Navy
  static const Color backgroundSecondary = Color(0xFF1A0B2E); // Dark Purple
  static const Color surfaceColor = Color(0xFF1E1E2E); // Dark Card
  static const Color surfaceVariant = Color(0xFF2A2A3A); // Lighter Card
  static const Color primaryTextColor = Color(0xFFFFFFFF); // White
  static const Color secondaryTextColor = Color(0xFFB4B4B8); // Light Gray
  static const Color errorColor = Color(0xFFFF4757); // Red
  static const Color successColor = Color(0xFF2ED573); // Green
  static const Color warningColor = Color(0xFFFFD700); // Yellow

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.purple,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundPrimary,
      fontFamily: 'Inter',

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),

      // Card Theme
      // cardTheme: CardTheme(
      //   color: surfaceColor,
      //   elevation: 8,
      //   shadowColor: Colors.black.withOpacity(0.3),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16),
      //   ),
      // ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: primaryTextColor,
        size: 24,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: primaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: secondaryTextColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundPrimary,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryTextColor,
        onBackground: primaryTextColor,
        onError: Colors.white,
      ),
    );
  }

  // Gradient Decorations
  static BoxDecoration get primaryGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor,
        primaryColor.withOpacity(0.8),
      ],
    ),
    borderRadius: BorderRadius.circular(16),
  );

  static BoxDecoration get backgroundGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        backgroundPrimary,
        backgroundSecondary,
      ],
    ),
  );

  static BoxDecoration get cardGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        surfaceColor,
        surfaceVariant,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}