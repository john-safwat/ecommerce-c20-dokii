import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void d(String message, {String tag = 'App'}) {
    if (!kDebugMode) return;
    developer.log(message, name: tag, level: 500);
  }

  static void i(String message, {String tag = 'App'}) {
    if (!kDebugMode) return;
    developer.log(message, name: tag, level: 800);
  }

  static void w(String message, {String tag = 'App'}) {
    if (!kDebugMode) return;
    developer.log(message, name: tag, level: 900);
  }

  static void e(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: tag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
