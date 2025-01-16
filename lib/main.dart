import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/models/word_puzzle_model.dart';
import 'package:word_search/providers/settings_provider.dart';
import 'package:word_search/screens/CreatePuzzleScreen.dart';
import 'package:word_search/screens/PlayScreen.dart';
import 'package:word_search/screens/PuzzleScreen.dart';
import 'package:word_search/screens/SettingsScreen.dart';
import 'package:word_search/screens/SolveWithCamera.dart';
import 'package:word_search/services/wordsearch.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TheWordSearchApp(),
    ),
  );
}

class TheWordSearchApp extends ConsumerStatefulWidget {
  const TheWordSearchApp({super.key});

  @override
  ConsumerState<TheWordSearchApp> createState() => _TheWordSearchState();
}

class _TheWordSearchState extends ConsumerState<TheWordSearchApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ref.watch(settingsThemeSeedColorProvider),
          brightness: ref.watch(settingsThemeBrightnessProvider)
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return 
   
    Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the usable width and height inside the SafeArea
            final usableWidth = constraints.maxWidth;
            final usableHeight = constraints.maxHeight;

            // Determine the size of each cell
            final size = usableWidth < usableHeight
                ? usableWidth / 11
                : usableHeight / 11;

            // Calculate the number of rows and columns
            final columnCount = (usableWidth ~/ size).toInt();
            final rowCount = (usableHeight ~/ size).toInt();

            return Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    rowCount,
                    (rowIndex) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        columnCount,
                        (colIndex) => SizedBox(
                          width: size,
                          height: size,
                          child: Center(
                            child: Text(
                              String.fromCharCode(
                                65 + Random().nextInt(26),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                NewMenuButton(
                    size,
                    1,
                    0,
                    'THE',
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.onPrimary,
                    () {}),
                NewMenuButton(
                    size,
                    1,
                    3,
                    'WORD',
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.onSecondary,
                    () {}),
                NewMenuButton(
                    size,
                    2,
                    0,
                    'SEARCH',
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.onTertiary,
                    () {}),
                NewMenuButton(
                    size,
                    2,
                    6,
                    'APP',
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.onPrimary,
                    () {}),
                NewMenuButton(
                  size,
                  4,
                  0,
                  'DAILY',
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.primary,
                  () {
                    WordPuzzleModel wordPuzzleModel = WordPuzzleModel(
                      horizontalSize: 20,
                      verticalSize: 20,
                      name: 'Fruits',
                      wordList: [
                        "Cherry",
                        "Date",
                        "Elderberry",
                        "Grape",
                        "Honeydew",
                        "Jackfruit",
                        "Kiwi",
                        "Lemon",
                        "Tomato",
                        "Mango",
                        "Nectarine",
                        "Orange",
                        "Papaya",
                      ],
                      foundWordList: [],
                      timer: 360,
                      timerLast: 360,
                      grid: [],
                    );
                    try {
                      List<List<String>> grid = WordSearch().generate(
                          wordPuzzleModel.verticalSize,
                          wordPuzzleModel.horizontalSize,
                          wordPuzzleModel.wordList);

                      wordPuzzleModel.grid = grid;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PuzzleScreen(
                            wordPuzzleModel: wordPuzzleModel,
                          ),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                NewMenuButton(
                  size,
                  5,
                  0,
                  'PLAY',
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.primary,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlayScreen(),
                      ),
                    );
                  },
                ),
                NewMenuButton(
                  size,
                  6,
                  0,
                  'CREATE',
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.primary,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePuzzleScreen(),
                      ),
                    );
                  },
                ),
                NewMenuButton(
                  size,
                  7,
                  0,
                  'SOLVE',
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.primary,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SolveWithCameraScreen(),
                      ),
                    );
                  },
                ),
                NewMenuButton(
                  size,
                  8,
                  0,
                  'SETTINGS',
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.primary,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    )
  
    ;

  }
}

Widget NewMenuButton(double cellSize, int top, int left, String string,
        Color backgroundColor, Color textColor, void Function() onTap) =>
    Positioned(
      top: cellSize * top,
      left: cellSize * left,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row size will fit the children
          children: List.generate(string.length, (index) {
            return Container(
              color: Colors.white,
              child: Container(
                width: cellSize,
                height: cellSize,
                color: backgroundColor.withValues(alpha: 0.8),
                child: Center(
                  child: Text(
                    string[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );

Widget Title(BuildContext context, String text) => Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Theme.of(context).colorScheme.primary,
          height: 48,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4.0),
            ),
          ),
        ),
      ],
    );

Widget MenuButton(BuildContext context, void Function() onTap, String text,
        Color backgroundColor, Color textColor) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36, // Height per character
        width: 36 *
            text.length
                .toDouble(), // Width proportional to the number of characters
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: 0, color: Colors.transparent),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: text
                .toUpperCase()
                .split('')
                .map((char) => Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: Text(
                        char,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14, // Font size adjusted to fit into 48x48
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
