import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class ThemeApp extends StateNotifier<bool> {
  ThemeApp() : super(false);

  void toggle() {
    state = !state;
  }
}

final themeApp = StateNotifierProvider<ThemeApp, bool>(
        (ref) => ThemeApp()
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    background: Color(0xfff3f1f7),
    primary: Color(0xff2AABEE),
    secondary: Color(0xff229ED9),
    inversePrimary: Color(0xff333333)
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
      background: Color(0xff333333),
      primary: Color(0xff2AABEE),
      secondary: Color(0xff229ED9),
      inversePrimary: Color(0xfff3f1f7)
  ),
);