import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocale {
  static const supported = [
    Locale('tr'),
    Locale('en'),
    Locale('ar'),
    Locale('ru'),
  ];

  static const fallback = Locale('en');
}

final localeProvider = StateProvider<Locale?>((ref) => AppLocale.fallback);


