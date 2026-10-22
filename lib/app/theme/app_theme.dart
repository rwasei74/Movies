import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  );
}
