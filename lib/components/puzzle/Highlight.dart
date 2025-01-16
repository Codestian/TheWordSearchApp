import 'dart:math';
import 'package:flutter/material.dart';

Widget Highlight(double size, List<double> start, List<double> end, Color color) {
  Map<String, double> test = calculateLineProperties(start, end);

  return Positioned(
    top: start[0] * size,
    left: start[1] * size,
    child: Transform.rotate(
      angle: test['angle']!,
      origin: Offset(size / 2, size / 2),
      alignment: Alignment.topLeft,
      child: Container(
        width: (size * test['length']!),
        height: size,
        decoration: BoxDecoration(
          color: color == Colors.transparent ? Colors.transparent : color.withValues(alpha: 0.3),
        ),
      ),
    ),
  );
}

Map<String, double> calculateLineProperties(
    List<double> start, List<double> end) {
  // Unpack start and end points (column, row -> x, y)
  double y1 = start[0], x1 = start[1];
  double y2 = end[0], x2 = end[1];

  // // Calculate the length of the line
  double length = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2)) + 1;

  // // Calculate the angle in radians
  double angleRadians = atan2(y2 - y1, x2 - x1);

  return {
    "length": length,
    "angle": angleRadians,
  };
}
