import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const AppBarTitle({
    super.key,
    required this.title,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: isDark ? Colors.white : Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 4.0),
    );
  }
}
