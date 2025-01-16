import 'package:flutter/material.dart';

class AbstractDialog extends StatelessWidget {
  final VoidCallback onTap; // Callback for dismissing the dialog
  final String text; // Main text of the dialog
  final List<Widget> children; // Buttons (PauseButton widgets)

  const AbstractDialog({
    Key? key,
    required this.onTap,
    required this.text,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text.toUpperCase(),
                  textAlign: TextAlign.center, // Center-align for multiline
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                  ),
                ),
                const SizedBox(height: 16),
                ...children, // Dynamically added buttons
              ],
            ),
          ),
        ),
      ),
    );
  }
}
