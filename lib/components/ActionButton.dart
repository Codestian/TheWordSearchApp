import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final bool isVisible;
  final bool isDark;

  const ActionButton({
    super.key,
    required this.onTap,
    required this.iconData,
    this.isVisible = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isVisible ? 1.0 : 0.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
          child: Icon(
            iconData,
            color: isDark ? Colors.white : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
