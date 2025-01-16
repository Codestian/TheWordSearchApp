import 'package:flutter/material.dart';

class WordChip extends StatelessWidget {
  final String title;

  const WordChip({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(right: 16),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.secondary,
      //   border: Border.all(
      //     color: Theme.of(context).colorScheme.secondary,
      //   ),
      // ),
      child: Text(
        title,
        style: TextStyle(
            color:  Theme.of(context).colorScheme.secondary,
            fontSize: 12,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
