import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Load theme preference from shared preferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    AppTheme.isDarkMode = _isDarkMode;
    notifyListeners();
  }

  // Toggle theme mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    AppTheme.isDarkMode = _isDarkMode;
    
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    
    notifyListeners();
  }

  // Get current theme
  ThemeData get currentTheme => AppTheme.currentTheme();
}
