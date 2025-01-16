import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:word_search/enums/Angle.dart';

Widget DragHighlight(
  double size, List<int> origin, Angle direction, double width, Color color) {
  return Positioned(
    top: (origin[0]) * size,
    left: (origin[1]) * size,
    child: Transform.rotate(
      angle: getAngleFromDirection(direction),
      origin: Offset(size/2, size/2),
      alignment: Alignment.topLeft,
      child: Container(
        width: width,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
        ),
      ),
    ),
  );
}

// Function to get angle in radians from direction enum
double getAngleFromDirection(Angle direction) {
  switch (direction) {
    case Angle.right:
      return 0.0;
    case Angle.bottomRight:
      return math.pi / 4;
    case Angle.bottom:
      return math.pi / 2;
    case Angle.bottomLeft:
      return 3 * math.pi / 4;
    case Angle.left:
      return math.pi;
    case Angle.topLeft:
      return 5 * math.pi / 4;
    case Angle.top:
      return 3 * math.pi / 2;
    case Angle.topRight:
      return 7 * math.pi / 4;
  }
}
