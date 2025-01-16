import 'dart:async';
import 'package:flutter/material.dart';

// Debouncer class with Timer
class Debouncer {
  final int milliseconds;  // Delay in milliseconds
  Timer? _timer;

  Debouncer({required this.milliseconds});

  // This method will be called whenever you want to debounce a function
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();  // Cancel any existing timer before starting a new one
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);  // Schedule the action to run after the debounce period
  }

  // Optionally, a method to manually cancel the debounce if needed
  void cancel() {
    _timer?.cancel();
  }
}
