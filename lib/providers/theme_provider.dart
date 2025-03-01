// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';

  // Singleton pattern
  static final ThemeProvider _instance = ThemeProvider._internal();
  factory ThemeProvider() => _instance;
  ThemeProvider._internal();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Initialize theme from preferences
  Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePreferenceKey);

    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();
  }

  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themePreferenceKey,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  // Get app theme data
  ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFD4AF37), // Gold
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4AF37),
        brightness: Brightness.light,
        primary: const Color(0xFFD4AF37),
        secondary: const Color(0xFFF8E8B0),
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F1E9), // Soft off-white
      cardColor: Colors.white,
      shadowColor: Colors.black,
      dividerColor: Colors.grey.withOpacity(0.2),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFD4AF37)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFD4AF37), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(
        0xFFD4AF37,
      ), // Keep gold as primary even in dark mode
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4AF37),
        brightness: Brightness.dark,
        primary: const Color(0xFFD4AF37),
        secondary: const Color(0xFFA48929), // Darker gold for dark mode
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
        background: const Color(0xFF121212),
        onBackground: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      cardColor: const Color(0xFF1E1E1E), // Dark card
      canvasColor: const Color(0xFF1E1E1E),
      shadowColor: Colors.black,
      dividerColor: Colors.white.withOpacity(0.1),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFD4AF37)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFD4AF37), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
        fillColor: const Color(0xFF2C2C2C),
      ),
    );
  }
}
