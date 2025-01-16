import 'package:flutter/material.dart';

Widget BottomButton(
        BuildContext context, String title, bool isDisabled, Function? onTap, {bool showBackground = true}) =>
    SafeArea(
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          decoration: BoxDecoration(
              color: showBackground ? Theme.of(context).colorScheme.surface : Colors.transparent,
              border: Border(
                  top: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (onTap != null) {
                          onTap();
                        }
                      },
                      child: Container(
                          height: 48,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              title,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4.0),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
