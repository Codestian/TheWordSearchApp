class WordPuzzleModel {
  late int horizontalSize;
  late int verticalSize;
  late String name;
  late List<String> wordList;
  late List<String> foundWordList;
  late int timer;
  late int timerLast;
  late List<List<String>> grid;

  WordPuzzleModel({
    required this.horizontalSize,
    required this.verticalSize,
    required this.name,
    required this.wordList,
    required this.foundWordList,
    required this.timer,
    required this.timerLast,
    required this.grid,
  });

  // Optional constructor for initializing late variables
  WordPuzzleModel.init({
    required this.horizontalSize,
    required this.verticalSize,
    required this.name,
    required this.wordList,
    required this.foundWordList,
    required this.timer,
    required this.timerLast,
    required this.grid,
  }) {
    horizontalSize = horizontalSize;
    verticalSize = verticalSize;
    name = name;
    timer = timer;
    timerLast = timerLast;
    wordList = wordList;
    foundWordList = foundWordList;
    grid = grid;
  }
}
