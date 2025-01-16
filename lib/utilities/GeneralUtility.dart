import 'package:flutter/material.dart';

class GeneralUtility {
  void showSnackbarError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        margin: const EdgeInsets.only(bottom: 80),
      ),
    );
  }

  void showSnackbarSuccess(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        margin: const EdgeInsets.only(bottom: 80),
      ),
    );
  }

  String formatTime(int seconds) {
    // Calculate days, hours, minutes, and seconds
    int days = seconds ~/ (24 * 3600); // Days
    int remainingSeconds = seconds % (24 * 3600);
    int hours = remainingSeconds ~/ 3600; // Hours
    remainingSeconds %= 3600;
    int minutes = remainingSeconds ~/ 60; // Minutes
    int secs = remainingSeconds % 60; // Seconds

    if (days > 0) {
      // Format as DD:HH:MM:SS
      return '${days}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else if (hours > 0) {
      // Format as HH:MM:SS
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      // Format as MM:SS
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  List<List<String>> chuckToRows(List<String> words, int numRows) {
    int totalChars = words.fold(0, (sum, str) => sum + str.length);
    int maxCharPerRow = (totalChars / numRows).floor();

    List<List<String>> finalList = [];
    finalList.add([]);
    int index = 0;

    words.forEach((String word) {
      int totalCharsRow =
          finalList[index].fold(0, (sum, str) => sum + str.length);
      if (totalCharsRow >= maxCharPerRow) {
        index++;
        finalList.add([word]);
      } else {
        finalList[index].add(word);
      }
    });

    return finalList;
  }

  
}
