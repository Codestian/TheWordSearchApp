import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_search/components/AbstractDialog.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/PauseButton.dart';
import 'package:word_search/components/puzzle/PuzzleGrid.dart';
import 'package:word_search/main.dart';
import 'package:word_search/models/word_puzzle_model.dart';
import 'package:word_search/screens/PlayScreen.dart';
import 'package:word_search/services/wordsearch.dart';
import 'package:word_search/utilities/GeneralUtility.dart';
import 'package:word_search/utils/colors.dart';
import 'package:word_search/utils/debouncer.dart';

class PuzzleScreen extends StatefulWidget {
  final WordPuzzleModel wordPuzzleModel;

  const PuzzleScreen({super.key, required this.wordPuzzleModel});

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final TransformationController _transformationController =
      TransformationController();

  bool isPaused = false;
  bool showOnlyWords = false;

  Timer? _timer;
  bool _isRunning = false;

  List<List<List<int>>> solvedWords = [];

  String guessedWord = '';

  List<Color> listOfColors = [];
  List<Color> listOfColorsPreset = [];

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  void showPauseMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AbstractDialog(
            onTap: () {
              Navigator.of(context).pop();
              resumeGame();
            },
            text: 'Paused',
            children: [
              PauseButton(context, () {
                Navigator.of(context).pop();
                resumeGame();
              }, 'RESUME', Theme.of(context).colorScheme.primaryFixed,
                  Theme.of(context).colorScheme.onPrimaryFixed),
              PauseButton(context, () {
                Navigator.of(context).pop();
                showRestartMenu();
              }, 'RESTART', Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.onSecondary),
              PauseButton(context, () {
                // Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                  (Route<dynamic> route) => false, // Remove all previous routes
                );
              }, 'QUIT', Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.onPrimary)
            ]);
      },
    );
  }

  void showRestartMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AbstractDialog(
          onTap: () {
            Navigator.of(context).pop();
            showPauseMenu();
          },
          text: 'Restart?',
          children: [
            PauseButton(context, () {
              restartGame();
            }, 'YES', Theme.of(context).colorScheme.error,
                Theme.of(context).colorScheme.errorContainer),
            PauseButton(context, () {
              Navigator.of(context).pop();
              showPauseMenu();
            }, 'NO', Theme.of(context).colorScheme.onErrorContainer,
                Theme.of(context).colorScheme.onError),
          ],
        );
      },
    );
  }

  void pauseGame() {
    setState(() {
      isPaused = true;
      _isRunning = false;
    });
    showPauseMenu();
  }

  void resumeGame() {
    setState(() {
      isPaused = false;
      _isRunning = true;
    });
  }

  void restartGame() {
    setState(() {
      isPaused = false;
      _isRunning = true;
      widget.wordPuzzleModel.foundWordList = [];
      guessedWord = "0/${widget.wordPuzzleModel.wordList.length} words found";
      _resetTimer();
      listOfColors = List.filled(
          widget.wordPuzzleModel.wordList.length, Colors.transparent);
    });
    Navigator.of(context).pop();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        setState(() {
          widget.wordPuzzleModel.timerLast--;
        });
      }
    });
  }

  void _resetTimer() {
    setState(() {
      widget.wordPuzzleModel.timerLast = widget.wordPuzzleModel.timer;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
      _isRunning = true;
      setState(() {
        listOfColors = List.filled(
            widget.wordPuzzleModel.wordList.length, Colors.transparent);

        List<List<List<int>>> solvedWordsList = [];

        listOfColorsPreset = colors.sublist(
          0,
          widget.wordPuzzleModel.wordList.length,
        );

        for (String word in widget.wordPuzzleModel.wordList) {
          List<List<List<int>>> result =
              WordSearch().findWord(widget.wordPuzzleModel.grid, word, true);
          solvedWordsList.add(result[0]);
        }

        for (String word in widget.wordPuzzleModel.foundWordList) {
          int index = widget.wordPuzzleModel.wordList.indexOf(word);
          listOfColors[index] = listOfColorsPreset[index];
        }
        guessedWord =
            "${widget.wordPuzzleModel.foundWordList.length}/${widget.wordPuzzleModel.wordList.length} words found";
        solvedWords = solvedWordsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO TEST ON PHYSICAL ANDROID IF BACK BUTTON WORKS
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        pauseGame();
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
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
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 56,
                                    child: Row(
                                      children: <Widget>[
                                        ActionButton(
                                          onTap: () {},
                                          iconData: Icons.abc,
                                          isVisible: false,
                                        ),
                                        const Spacer(),
                                        AppBarTitle(
                                            title: widget.wordPuzzleModel.name
                                                .toUpperCase()),
                                        const Spacer(),
                                        ActionButton(
                                          onTap: () {
                                            pauseGame();
                                          },
                                          iconData: Icons.pause,
                                        ),
                                      ],
                                    ),
                                  ),
                                  WordList(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: MainPuzzle(),
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 56,
                              child: Row(
                                children: <Widget>[
                                  ActionButton(
                                    onTap: () {},
                                    iconData: Icons.abc,
                                    isVisible: false,
                                  ),
                                  const Spacer(),
                                  AppBarTitle(
                                      title: widget.wordPuzzleModel.name
                                          .toUpperCase()),
                                  const Spacer(),
                                  ActionButton(
                                    onTap: () {
                                      pauseGame();
                                    },
                                    iconData: Icons.pause,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight / 2,
                              child: MainPuzzle(),
                            ),
                            WordList(),
                          ],
                        ));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRows(List<String> wordList, List<Color> wordColors) {
    // Generate the rows
    return LayoutBuilder(builder: (context, constraints) {
      // Extract width and height from the constraints
      final height = constraints.maxHeight;

      const rowHeight = 50.0;

      // Calculate the number of rows that can fit
      int numberOfRows = (height / rowHeight).floor();

      List<List<String>> finalList =
          GeneralUtility().chuckToRows(wordList, numberOfRows);

      List<List<Color>> colorReplacedList =
          replaceStringsWithColors(finalList, wordColors);

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(finalList.length, (rowIndex) {
            return Container(
              height: rowHeight, // Height for each row
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(finalList[rowIndex].length, (colIndex) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Measure the width of the text
                        final String text =
                            finalList[rowIndex][colIndex].toUpperCase();
                        final TextPainter textPainter = TextPainter(
                          text: TextSpan(
                            text: text,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                          textDirection: TextDirection.ltr,
                        )..layout();

                        final double textWidth = textPainter.size.width;

                        return Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Text(
                              text,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                            Container(
                              width: textWidth +
                                  16, // Add some padding around the text
                              height:
                                  rowHeight * 0.8, // Optional height adjustment
                              color: colorReplacedList[rowIndex][colIndex] ==
                                      Colors.transparent
                                  ? Colors.transparent
                                  : colorReplacedList[rowIndex][colIndex]
                                      .withValues(
                                          alpha: 0.3), // Background color
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget MainPuzzle() => Column(
        children: [
          PuzzleAction(
              context,
              GeneralUtility().formatTime(widget.wordPuzzleModel.timerLast),
              _transformationController),
          PuzzleGrid(
            transformationController: _transformationController,
            wordGrid: widget.wordPuzzleModel.grid,
            solvedWords: solvedWords,
            listOfColors: listOfColors,
            onDrag: (String word) {
              setState(() {
                guessedWord = word;
              });
            },
            onDragEnd: (List<List<int>> coordinates, String word) {
              if (coordinates.isNotEmpty) {
                setState(() {
                  if (widget.wordPuzzleModel.wordList.contains(word) &&
                      !widget.wordPuzzleModel.foundWordList.contains(word)) {
                    int index = widget.wordPuzzleModel.wordList.indexOf(word);
                    listOfColors[index] = listOfColorsPreset[index];
                    widget.wordPuzzleModel.foundWordList.add(word);
                    guessedWord =
                        "${widget.wordPuzzleModel.foundWordList.length}/${widget.wordPuzzleModel.wordList.length} words found";
                  } else {
                    guessedWord = guessedWord =
                        "${widget.wordPuzzleModel.foundWordList.length}/${widget.wordPuzzleModel.wordList.length} words found";
                  }
                });
              }
            },
            isPaused: isPaused,
          ),
          Container(
            height: 32,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
              )),
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.6),
            ),
            child: Center(
              child: Text(
                guessedWord.toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      );

  Widget WordList() => Expanded(
          child: Column(
        children: [
          Expanded(
              child: Container(
            // color: Colors.red,
            child: _buildRows(widget.wordPuzzleModel.wordList, listOfColors),
          )),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the container
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      solvedWords = [
                        [
                          [1, 2],
                          [3, 4]
                        ]
                      ];
                    });
                  },
                  child: Text('test button')),
              // child: const Center(
              //   child: Text('AD HERE'),
              // ),
            ),
          ),
        ],
      ));
}

Widget PuzzleAction(BuildContext context, String timer,
        TransformationController transformationController) =>
    Container(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // final x = Offset(MediaQuery.of(context).size.width / 2,
                //     MediaQuery.of(context).size.width / 2);
                // final offset1 = transformationController.toScene(x);
                // transformationController.value.scale(1.5);
                // final offset2 = transformationController.toScene(x);
                // final dx = offset1.dx - offset2.dx;
                // final dy = offset1.dy - offset2.dy;
                // transformationController.value.translate(-dx, -dy);
              },
              child: Container(
                width: 32,
                height: 32,
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                    child: Icon(
                  Icons.remove,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
              ),
            ),
            const Spacer(),
            Text(timer,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            const Spacer(),
            Container(
              width: 32,
              height: 32,
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                  child: Icon(
                Icons.add,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
            ),
          ],
        ));

List<List<Color>> replaceStringsWithColors(
    List<List<String>> transformedStringList, List<Color> colorList) {
  // Create a new list to store the color replacements
  List<List<Color>> colorReplacedList = [];
  int colorIndex = 0;

  // Loop through each sublist in the list of lists of strings
  for (var sublist in transformedStringList) {
    List<Color> sublistWithColors = [];

    for (var string in sublist) {
      // If there are still colors left in the colorList, use them
      if (colorIndex < colorList.length) {
        sublistWithColors.add(colorList[colorIndex]);
        colorIndex++;
      } else {
        break; // Exit if we run out of colors
      }
    }

    colorReplacedList.add(sublistWithColors);
  }

  return colorReplacedList;
}
