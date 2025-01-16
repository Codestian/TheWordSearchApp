import 'package:flutter/material.dart';
import 'package:word_search/components/WordChip.dart';

class WordsExpansionPanel extends StatefulWidget {
  final List<String> listOfWords;

  const WordsExpansionPanel({
    super.key,
    required this.listOfWords,
  });

  @override
  _WordsExpansionPanelState createState() => _WordsExpansionPanelState();
}

class _WordsExpansionPanelState extends State<WordsExpansionPanel> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              child: Row(
                children: <Widget>[
                  Text(
                    'FRUITS',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              )),
        ),
        AnimatedContainer(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          duration: const Duration(milliseconds: 300),
          height: _isExpanded ? 200 : 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: widget.listOfWords.map((String title) {
                    return WordChip(title: title);
                  }).toList()),
            ),
          ),
        ),
      ],
    );
  }
}
