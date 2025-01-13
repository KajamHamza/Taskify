import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0080FF), // Primary color: Blue
      brightness: Brightness.light,
      primary: const Color(0xFF0080FF), // Blue primary color
      secondary: const Color(0xFFCCCCCC), // Subtle gray for secondary use
      surface: const Color(0xFFF6F6F6), // Light gray surface
      background: const Color(0xFFFFFFFF), // White background
      error: const Color(0xFF666666), // Gray error placeholder (consistent styling)
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Black titles
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.grey, // Gray descriptions
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey, // Gray descriptions for smaller text
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white, // Button text is white
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // White button text
        backgroundColor: const Color(0xFF0080FF), // Blue button background
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF6F6F6), // Light gray input background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF6F6F6), // Light gray card background
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF), // White background
  );
}
