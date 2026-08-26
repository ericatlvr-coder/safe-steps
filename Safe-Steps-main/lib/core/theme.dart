import 'package:flutter/material.dart';

class SafeStepsColors {
  static const purple = Color(0xFF6847FF);
  static const lime = Color(0xFFD2FFA1);
  static const limeMuted = Color(0xFFC2DEA2);
  static const ink = Color(0xFF171717);
  static const softGrey = Color(0xFFF1F1F1);
  static const fieldGrey = Color(0xFFC8C8C8);
  static const danger = Color(0xFFB3261E);
}

ThemeData buildSafeStepsTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: SafeStepsColors.purple,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF7F7F7),
    fontFamily: 'Arial',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SafeStepsColors.fieldGrey.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: SafeStepsColors.purple, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: SafeStepsColors.lime,
        foregroundColor: SafeStepsColors.purple,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
