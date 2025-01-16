import 'package:flutter/material.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/BottomButton.dart';
import 'package:word_search/models/word_puzzle_model.dart';
import 'package:word_search/screens/PuzzleScreen.dart';
import 'package:word_search/screens/pages/createpuzzle/CreateWordListPage.dart';
import 'package:word_search/services/wordsearch.dart';
import 'package:word_search/utilities/GeneralUtility.dart';

class CreatePuzzleScreen extends StatefulWidget {
  const CreatePuzzleScreen({super.key});

  @override
  _CreatePuzzleScreenState createState() => _CreatePuzzleScreenState();
}

class _CreatePuzzleScreenState extends State<CreatePuzzleScreen> {
  WordSearch ws = WordSearch();
  WordPuzzleModel wordPuzzleModel = WordPuzzleModel(
    horizontalSize: 10,
    verticalSize: 10,
    name: 'My Puzzle',
    wordList: <String>[],
    foundWordList: <String>[],
    timer: 60,
    timerLast: 0,
    grid: [],
  );

  Widget Topbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      title: Row(
        children: <Widget>[
          ActionButton(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pop(context);
            },
            iconData: Icons.arrow_back,
          ),
          const Spacer(),
          const AppBarTitle(title: 'CREATE PUZZLE'),
          const Spacer(),
          ActionButton(
            onTap: () {},
            iconData: Icons.abc,
            isVisible: false,
          ),
        ],
      ),
    );
  }

  Widget Config() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Number of rows (${wordPuzzleModel.verticalSize})',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Slider(
          value: wordPuzzleModel.verticalSize.toDouble(),
          onChanged: (double value) {
            setState(() {
              wordPuzzleModel.verticalSize = value.round();
            });
          },
          min: 5,
          max: 20,
          divisions: 15,
          label: wordPuzzleModel.verticalSize.toString(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Number of columns (${wordPuzzleModel.horizontalSize})',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Slider(
          value: wordPuzzleModel.horizontalSize.toDouble(),
          onChanged: (double value) {
            setState(() {
              wordPuzzleModel.horizontalSize = value.round();
            });
          },
          min: 5,
          max: 20,
          divisions: 15,
          label: wordPuzzleModel.horizontalSize.toString(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Ensures space between Text and Switch
            children: [
              Text(
                'Timer duration',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Switch(
                value:
                    true, // Boolean variable controlling the state of the switch
                onChanged: (bool value) {
                  setState(() {
                    // true = value; // Update the state when the switch is toggled
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  TimerBox(context, 30, wordPuzzleModel.timer == 30, () {
                    setState(() {
                      wordPuzzleModel.timer = 30;
                    });
                  }),
                  SizedBox(width: 12),
                  TimerBox(context, 60, wordPuzzleModel.timer == 60, () {
                    setState(() {
                      wordPuzzleModel.timer = 60;
                    });
                  }),
                  SizedBox(width: 12),
                  TimerBox(context, 180, wordPuzzleModel.timer == 180, () {
                    setState(() {
                      wordPuzzleModel.timer = 180;
                    });
                  }),
                  SizedBox(width: 12),
                  TimerBox(context, 300, wordPuzzleModel.timer == 300, () {
                    setState(() {
                      wordPuzzleModel.timer = 300;
                    });
                  }),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: <Widget>[
                  TimerBox(context, 600, wordPuzzleModel.timer == 600, () {
                    setState(() {
                      wordPuzzleModel.timer = 600;
                    });
                  }),
                  SizedBox(width: 12),
                  TimerBox(context, 900, wordPuzzleModel.timer == 900, () {
                    setState(() {
                      wordPuzzleModel.timer = 900;
                    });
                  }),
                  SizedBox(width: 12),
                  TimerBox(context, 1800, wordPuzzleModel.timer == 1800, () {
                    setState(() {
                      wordPuzzleModel.timer = 1800;
                    });
                  }),
                  SizedBox(width: 12),
                  TimerBox(context, 3600, wordPuzzleModel.timer == 3600, () {
                    setState(() {
                      wordPuzzleModel.timer = 3600;
                    });
                  }),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Text(
                  'Word list (${wordPuzzleModel.wordList.length})',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateWordListPage(
                            wordPuzzleModel: wordPuzzleModel),
                      ),
                    );

                    if (result is WordPuzzleModel) {
                      setState(() {
                        wordPuzzleModel = result;
                      });
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      'EDIT',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          letterSpacing: 2.0,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )),
      ],
    );
  }

  Widget Preview() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.2),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 3.0,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(
                wordPuzzleModel.verticalSize,
                (verticalIndex) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      wordPuzzleModel.horizontalSize,
                      (horizontalIndex) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget PlayButton() {
    return BottomButton(
        context,
        'PLAY',
        wordPuzzleModel.wordList.isEmpty,
        wordPuzzleModel.wordList.isEmpty
            ? null
            : () {
                if (wordPuzzleModel.name.isNotEmpty) {
                  try {
                    List<List<String>> puzzle = ws.generate(
                        wordPuzzleModel.verticalSize,
                        wordPuzzleModel.horizontalSize,
                        wordPuzzleModel.wordList);
                    wordPuzzleModel.grid = puzzle;

                    wordPuzzleModel.timerLast = wordPuzzleModel.timer;
                    wordPuzzleModel.foundWordList = [];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PuzzleScreen(wordPuzzleModel: wordPuzzleModel),
                      ),
                    );
                  } catch (e) {
                    GeneralUtility().showSnackbarError(context, e.toString());
                  }
                } else {
                  GeneralUtility()
                      .showSnackbarError(context, 'List name is empty');
                }
              });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints) {
        bool isLandscape = constraints.maxWidth > constraints.maxHeight;

        return SafeArea(
            child: isLandscape
                ? Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Topbar(),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Config(),
                          )),
                          PlayButton(),
                        ],
                      )),
                      Expanded(
                        child: Container(
                          child: Preview(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Topbar(),
                      SizedBox(
                        height: 128 + 32,
                        child: Preview(),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Config(),
                      )),
                      PlayButton(),
                    ],
                  ));
      }),
    );
  }
  // appBar:
  // body: Column(
  //   children: <Widget>[

  // ),
  //   );
  // }
}

Widget TimerBox(
    BuildContext context, int seconds, bool isSelected, VoidCallback onTap) {
  String formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds s'; // Seconds
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return remainingSeconds == 0
          ? '$minutes min' // Only minutes
          : '$minutes min $remainingSeconds s'; // Minutes and seconds
    } else {
      final hours = seconds ~/ 3600;
      final remainingMinutes = (seconds % 3600) ~/ 60;
      return remainingMinutes == 0
          ? '$hours h' // Only hours
          : '$hours h $remainingMinutes min'; // Hours and minutes
    }
  }

  String formatted = formatDuration(seconds);

  return Expanded(
    child: GestureDetector(
      onTap: onTap, // Handle tap to notify the parent widget
      child: Container(
        padding: EdgeInsets.all(12),
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.5),
        child: Center(
          child: Text(
            formatted.toUpperCase(),
            style: TextStyle(
              letterSpacing: 2,
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ),
  );
}
