import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
    );
  }
}


