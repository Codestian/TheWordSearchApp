import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/models/word_puzzle_model.dart';
import 'package:word_search/providers/settings_provider.dart';
import 'package:word_search/screens/PuzzleScreen.dart';
import 'package:word_search/services/wordsearch.dart';

class PuzzleCard extends ConsumerStatefulWidget {
  final WordPuzzleModel wordPuzzleModel;
  final VoidCallback onRegenerate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PuzzleCard({
    super.key,
    required this.wordPuzzleModel,
    required this.onRegenerate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  ConsumerState<PuzzleCard> createState() => _PuzzleCardState();
}

class _PuzzleCardState extends ConsumerState<PuzzleCard> {
  bool test = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      margin:
          const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.wordPuzzleModel.name.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    Text(
                      '${widget.wordPuzzleModel.foundWordList.length}/${widget.wordPuzzleModel.wordList.length} words found'
                          .toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Theme.of(context).colorScheme.secondary,
                          child: Text(
                            '${widget.wordPuzzleModel.verticalSize} x ${widget.wordPuzzleModel.horizontalSize}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Theme.of(context).colorScheme.secondary,
                          child: Text(
                            '5 MIN',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        ActionButton(
                          onTap: () {
                            setState(() {
                              test =
                                  true; // Update state to show additional content.
                            });
                          },
                          iconData: Icons.more_horiz,
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            child: Text(
                              'play'.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4.0,
                              ),
                            ),
                          ),
                          onTap: () {
                            try {
                              List<List<String>> grid = WordSearch().generate(
                                widget.wordPuzzleModel.verticalSize,
                                widget.wordPuzzleModel.horizontalSize,
                                widget.wordPuzzleModel.wordList,
                              );

                              widget.wordPuzzleModel.grid = grid;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PuzzleScreen(
                                    wordPuzzleModel: widget.wordPuzzleModel,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 3,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.2),
                  ),
                  FractionallySizedBox(
                    widthFactor: widget.wordPuzzleModel.foundWordList.length /
                        widget.wordPuzzleModel.wordList.length,
                    child: Container(
                      height: 3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (test)
            Positioned.fill(
                child: GestureDetector(
              onTap: () {
                setState(() {
                  test = false;
                });
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 14),
                  color: ref.watch(settingsThemeBrightnessProvider)
                      ? Colors.black.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.9),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: ActionButton(
                          onTap: () {
                            setState(() {
                              test = false;
                            });
                          },
                          iconData: Icons.more_horiz,
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                MoreButton(Icons.casino, 'Regenerate',
                                    widget.onRegenerate),
                                MoreButton(Icons.edit, 'Edit', widget.onEdit),
                                MoreButton(
                                    Icons.delete, 'Delete', widget.onDelete),
                              ],
                            ),
                          )),
                    ],
                  )),
            )),
        ],
      ),
    );
  }

  Widget MoreButton(IconData icon, String text, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 40,
          child: Center(
              child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          )),
        ),
      );
}
