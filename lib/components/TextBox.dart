import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextBox extends StatelessWidget {
  final String hintText;
  final Function(String) onTextChanged;
  final Function(String) onSubmitted;

  final TextEditingController controller;

  const TextBox({
    super.key,
    required this.hintText,
    required this.onTextChanged,
    required this.onSubmitted,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onTextChanged,
      onEditingComplete: () {},
      onSubmitted: onSubmitted,
      style: TextStyle(
        letterSpacing: 2.0,
                    color: Theme.of(context).colorScheme.primary,

        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
      ],
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          fillColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.zero,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.zero,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            letterSpacing: 2.0,
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: Icon(Icons.close, color:Theme.of(context).colorScheme.primary.withOpacity(1) ,))),
    );
  }
}
