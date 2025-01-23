import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class CustomSwitch extends StatelessWidget {
  final ValueNotifier<bool> controller;
  final String activeText;
  final String inactiveText;

  const CustomSwitch({
    required this.controller,
    required this.activeText,
    required this.inactiveText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (context, value, child) {
        return AdvancedSwitch(
          controller: controller,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withAlpha(102), // Equivalent to 0.4 transparency
          activeChild: Text(
            activeText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          inactiveChild: Text(
            inactiveText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.zero),
          width: 56.0,
          height: 28.0,
          enabled: true,
        );
      },
    );
  }
}
