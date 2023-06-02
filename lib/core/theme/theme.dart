import 'package:devsocy/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier(); // Need not to pass mode here because already passed in Constructor
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({
    ThemeMode mode = ThemeMode.dark,
  })  : _mode = mode,
        super(Pallete.darkModeAppTheme) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  // We will be using sharedPreferences for storing the theme setting when opening app
  void getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final theme = sharedPreferences.getString('theme');
    if (theme == 'dark') {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
    } else {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      sharedPreferences.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      sharedPreferences.setString('theme', 'dark');
    }
  }
}
