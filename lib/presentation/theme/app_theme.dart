// lib/presentation/theme/app_theme.dart
import 'package:flutter/material.dart';

/// App theme configuration - change [useNavyMode] to switch themes
class AppTheme {
  // ============================================================
  // SET THIS TO true FOR NAVY MODE, false FOR LIGHT MODE
  // ============================================================
  static const bool useNavyMode = true;
  // ============================================================

  // Private constructor
  AppTheme._();

  // ============================================================
  // Color Palette
  // ============================================================

  // Primary colors
  static const Color _primaryLight = Color(0xFF6C3B9A);
  static const Color _primaryDark = Color(0xFF9B6DCF);
  static const Color _primaryContainerLight = Color(0xFFEDE3F5);
  static const Color _primaryContainerDark = Color(0xFF2D1B3D);

  // Secondary colors
  static const Color _secondaryLight = Color(0xFF03A9F4);
  static const Color _secondaryDark = Color(0xFF4FC3F7);

  // Surface colors
  static const Color _surfaceLight = Color(0xFFF8F5FA);
  static const Color _surfaceDark = Color(0xFF1A1A2E);    // Dark navy

  // Background colors
  static const Color _backgroundLight = Color(0xFFF5F0F8);
  static const Color _backgroundDark = Color(0xFF16213E); // Deep navy blue

  // Card colors
  static const Color _cardLight = Color(0xFFFFFFFF);
  static const Color _cardDark = Color(0xFF1F2A44);      // Slightly lighter navy

  // Text colors
  static const Color _textPrimaryLight = Color(0xFF1A1A1A);
  static const Color _textPrimaryDark = Color(0xFFE8E8E8);

  // Status colors
  static const Color _error = Color(0xFFE53935);

  // ============================================================
  // Theme Getter - Returns the active theme based on useNavyMode
  // ============================================================

  static ThemeData get theme => useNavyMode ? navyTheme : lightTheme;

  // ============================================================
  // Light Theme
  // ============================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryLight,
        primaryContainer: _primaryContainerLight,
        secondary: _secondaryLight,
        surface: _surfaceLight,
        error: _error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textPrimaryLight,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: _backgroundLight,
      cardColor: _cardLight,
      cardTheme: CardThemeData(
        color: _cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryLight,
          side: BorderSide(color: _primaryLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryContainerLight,
        selectedColor: _primaryLight,
        labelStyle: TextStyle(color: _textPrimaryLight),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 0,
      ),
    );
  }

  // ============================================================
  // Navy Theme
  // ============================================================

  static ThemeData get navyTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        primaryContainer: _primaryContainerDark,
        secondary: _secondaryDark,
        surface: _surfaceDark,
        error: _error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textPrimaryDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: _backgroundDark,
      cardColor: _cardDark,
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D2B), // Dark navy ribbon
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryDark,
        foregroundColor: Colors.white,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryDark,
          side: BorderSide(color: _primaryDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1A2A4A), // Dark navy fill for input fields
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryDark, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF2A3A5A)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIconColor: Colors.grey.shade400,
        suffixIconColor: Colors.grey.shade400,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryContainerDark,
        selectedColor: _primaryDark,
        labelStyle: TextStyle(color: _textPrimaryDark),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF333333),
        thickness: 1,
        space: 0,
      ),
    );
  }
}