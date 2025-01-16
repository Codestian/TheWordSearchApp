import 'dart:math';

class WordSearch {
  // Generates the word search puzzle and returns a 2D list representing the grid
  List<List<String>> generate(int col, int row, List<String> wordList) {
    List<List<String>> grid =
        List.generate(row, (i) => List.generate(col, (j) => '.'));

    int maxAttempts = 5;
    int attempts = 0;

    // Try to generate the puzzle for a maximum of 5 attempts
    while (attempts < maxAttempts) {
      bool success = _placeWords(grid, wordList);

      if (success) {
        // for (var row in grid) {
        //   for (var i = 0; i < row.length; i++) {
        //     if (row[i] == '.') {
        //       row[i] = _getRandomUppercase();
        //     }
        //   }
        // }

        return grid;
      } else {
        // Reset grid and try again
        grid = List.generate(row, (i) => List.generate(col, (j) => '.'));
        attempts++;
      }
    }

    // If unable to place words after 5 attempts, throw an exception
    throw Exception('Grid is too small, select bigger');
  }

  // Tries to place all words in the grid
  bool _placeWords(List<List<String>> grid, List<String> wordList) {
    var directions = [
      [0, 1], // Horizontal (right)
      [1, 0], // Vertical (down)
      [0, -1], // Horizontal (left)
      [-1, 0], // Vertical (up)
      [1, 1], // Diagonal (down-right)
      [1, -1], // Diagonal (down-left)
      [-1, 1], // Diagonal (up-right)
      [-1, -1] // Diagonal (up-left)
    ];

    for (String word in wordList) {
      bool placed = false;
      int wordLength = word.length;

      // Try placing the word in random directions
      for (int attempt = 0; attempt < 100; attempt++) {
        int startRow = Random().nextInt(grid.length);
        int startCol = Random().nextInt(grid[0].length);
        var direction = directions[Random().nextInt(directions.length)];

        // Check if the word can be placed at the given start position and direction
        if (_canPlaceWord(grid, word, startRow, startCol, direction)) {
          _placeWord(grid, word, startRow, startCol, direction);
          placed = true;
          break;
        }
      }

      // If a word couldn't be placed, return false to indicate failure
      if (!placed) {
        return false;
      }
    }

    return true; // All words placed successfully
  }

  // Check if a word can be placed at the given position and direction
  bool _canPlaceWord(List<List<String>> grid, String word, int row, int col,
      List<int> direction) {
    int rowDirection = direction[0];
    int colDirection = direction[1];

    // Check if the word fits in the grid within the given direction
    for (int i = 0; i < word.length; i++) {
      int newRow = row + i * rowDirection;
      int newCol = col + i * colDirection;

      // If out of bounds or the cell is not empty or already contains a conflicting letter, return false
      if (newRow < 0 ||
          newRow >= grid.length ||
          newCol < 0 ||
          newCol >= grid[0].length) {
        return false;
      }
      if (grid[newRow][newCol] != '.' && grid[newRow][newCol] != word[i]) {
        return false;
      }
    }

    return true;
  }

  // Place a word in the grid at the specified position and direction
  void _placeWord(List<List<String>> grid, String word, int row, int col,
      List<int> direction) {
    int rowDirection = direction[0];
    int colDirection = direction[1];

    for (int i = 0; i < word.length; i++) {
      int newRow = row + i * rowDirection;
      int newCol = col + i * colDirection;
      grid[newRow][newCol] = word[i];
    }
  }

  List<List<List<int>>> findWord(
      List<List<String>> grid, String word, bool findFirstOnly) {
    List<List<int>> startIndexes = _findCharacterIndexes(grid, word[0]);
    // Define the 8 possible directions: (rowDelta, colDelta)
    List<List<int>> directions = [
      [-1, 0], // Up
      [1, 0], // Down
      [0, -1], // Left
      [0, 1], // Right
      [-1, -1], // Top-left diagonal
      [-1, 1], // Top-right diagonal
      [1, -1], // Bottom-left diagonal
      [1, 1], // Bottom-right diagonal
    ];

    // Function to check if a position is within bounds
    bool isInBounds(int row, int col) {
      return row >= 0 && row < grid.length && col >= 0 && col < grid[0].length;
    }

    // List to store all occurrences
    List<List<List<int>>> occurrences = [];

    // Loop through each starting index
    for (List<int> start in startIndexes) {
      int startRow = start[0];
      int startCol = start[1];

      // Check if the starting character matches the first character of the word
      if (grid[startRow][startCol] != word[0]) continue;

      // Explore in each of the 8 directions
      for (List<int> direction in directions) {
        int rowDelta = direction[0];
        int colDelta = direction[1];

        int currentRow = startRow;
        int currentCol = startCol;
        bool matched = true;

        // Check characters in the current direction
        for (int i = 1; i < word.length; i++) {
          currentRow += rowDelta;
          currentCol += colDelta;

          // If out of bounds or character doesn't match, break
          if (!isInBounds(currentRow, currentCol) ||
              grid[currentRow][currentCol] != word[i]) {
            matched = false;
            break;
          }
        }

        // If the word is fully matched, save the start and end coordinates
        if (matched) {
          List<List<int>> result = [
            [startRow, startCol], // Start coordinates
            [currentRow, currentCol] // End coordinates
          ];
          occurrences.add(result);

          // If findFirstOnly is true, stop searching and return the first match
          if (findFirstOnly) {
            return occurrences;
          }
        }
      }
    }

    return occurrences;
  }

  List<List<int>> _findCharacterIndexes(
      List<List<String>> lists, String target) {
    List<List<int>> indexes = [];

    for (int i = 0; i < lists.length; i++) {
      for (int j = 0; j < lists[i].length; j++) {
        if (lists[i][j] == target) {
          indexes.add([i, j]);
        }
      }
    }

    return indexes;
  }
}
