import 'package:flutter/material.dart';
import 'package:word_search/components/AbstractDialog.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/PauseButton.dart';
import 'package:word_search/components/PuzzleCard.dart';
import 'package:word_search/main.dart';
import 'package:word_search/models/word_puzzle_model.dart';
import 'package:word_search/screens/CreatePuzzleScreen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool showDelete = false;

  List<WordPuzzleModel> listOfPuzzles = [
    WordPuzzleModel(
      horizontalSize: 8,
      verticalSize: 12,
      name: 'Demo puzzle',
      wordList: [
        'Tomato',
        'Apple',
        'Celery',
        'Orange',
        'Grape',
      ],
      foundWordList: [
        'Apple',
        'Celery',
      ],
      timer: 300,
      timerLast: 267,
      grid: [],
    ),
    WordPuzzleModel(
      horizontalSize: 28,
      verticalSize: 2,
      name: 'Demo puzzle',
      wordList: [
        'Elephant',
        'Tiger',
        'Cat',
        'Lion',
        'Zebra',
        'Kangaroo',
        'Dog',
        'Rabbit',
        'Giraffe',
      ],
      foundWordList: [],
      timer: 600,
      timerLast: 552,
      grid: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Row(
          children: <Widget>[
            ActionButton(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
              iconData: Icons.arrow_back,
            ),
            const Spacer(),
            const AppBarTitle(title: 'PUZZLES'),
            const Spacer(),
            ActionButton(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePuzzleScreen(),
                      ),
                    );
              },
              iconData: Icons.add,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.2),
              border: Border(
                top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1)),
              ),
            ),
          ),
          Column(
            children: [
              // ListView.builder to display PuzzleCard dynamically
              Expanded(
                child: ListView.builder(
                  itemCount:
                      listOfPuzzles.length, // Length of the list of puzzles
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: i == 0
                              ? 6.0
                              : 0), // Apply margin only for the first item
                      child: PuzzleCard(
                        wordPuzzleModel:
                            listOfPuzzles[i], // Passing the puzzle data
                        onRegenerate: onRegenerate,
                        onEdit: () {},
                        onDelete: onDelete,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (showDelete)
            AbstractDialog(
                onTap: () {
                  setState(() {
                    showDelete = false;
                  });
                },
                text: 'Delete puzzle?',
                children: [
                  PauseButton(
                      context,
                      () {},
                      'YES',
                      Theme.of(context).colorScheme.error,
                      Theme.of(context).colorScheme.errorContainer),
                  PauseButton(
                      context,
                      () {},
                      'NO',
                      Theme.of(context).colorScheme.onErrorContainer,
                      Theme.of(context).colorScheme.onError),
                ])
        ],
      ),
    );
  }

  void onDelete() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AbstractDialog(
          onTap: () => Navigator.of(context).pop(),
          text: 'Delete?',
          children: [
            PauseButton(
                context,
                () {},
                'YES',
                Theme.of(context).colorScheme.error,
                Theme.of(context).colorScheme.errorContainer),
            PauseButton(
                context,
                () => Navigator.of(context).pop(),
                'NO',
                Theme.of(context).colorScheme.onErrorContainer,
                Theme.of(context).colorScheme.onError),
          ],
        );
      },
    );
  }

  void onRegenerate() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AbstractDialog(
          onTap: () => Navigator.of(context).pop(),
          text: 'Renegerate?',
          children: [
            PauseButton(
                context,
                () {},
                'YES',
                Theme.of(context).colorScheme.primaryFixed,
                Theme.of(context).colorScheme.onPrimaryFixed),
            PauseButton(
                context,
                () => Navigator.of(context).pop(),
                'NO',
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.onPrimary),
          ],
        );
      },
    );
  }
}
