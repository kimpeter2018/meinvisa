// lib/core/debug/debug_logger.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugLogger extends ChangeNotifier {
  static final DebugLogger _instance = DebugLogger._internal();
  factory DebugLogger() => _instance;
  DebugLogger._internal();

  final List<String> _logs = [];

  // Overlay visibility
  final ValueNotifier<bool> isOverlayOpen = ValueNotifier(false);

  void openOverlay() {
    isOverlayOpen.value = true;
  }

  void closeOverlay() {
    isOverlayOpen.value = false;
  }

  List<String> get logs => List.unmodifiable(_logs);

  void log(String message) {
    final entry = "[LOG] ${DateTime.now()}  →  $message";
    _logs.add(entry);
    debugPrint(entry);
    notifyListeners();
  }

  void error(String message, [Object? e, StackTrace? st]) {
    final entry =
        "[ERROR] ${DateTime.now()}  →  $message\n${e ?? ''}\n${st ?? ''}";
    _logs.add(entry);
    debugPrint(entry);
    notifyListeners();
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }
}
