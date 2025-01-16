import 'package:flutter/material.dart';

Widget PauseButton(
  BuildContext context,
  void Function() onTap,
  String text,
  Color backgroundColor,
  Color textColor,
) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(width: 0, color: Colors.transparent)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 4.0),
          ),
        ),
      ),
    );
