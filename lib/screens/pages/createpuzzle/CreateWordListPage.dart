import 'package:flutter/material.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/TextBox.dart';
import 'package:word_search/models/word_puzzle_model.dart';
import 'package:word_search/screens/pages/createpuzzle/CategoriesPage.dart';
import 'package:word_search/utilities/GeneralUtility.dart';
// import 'package:word_search/screens/pages/WordListPage.dart';

class CreateWordListPage extends StatefulWidget {
  final WordPuzzleModel wordPuzzleModel;

  const CreateWordListPage({
    super.key,
    required this.wordPuzzleModel,
  });

  @override
  _CreateWordListPageState createState() => _CreateWordListPageState();
}

class _CreateWordListPageState extends State<CreateWordListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addWordController = TextEditingController();

  WordPuzzleModel wordPuzzleModel = WordPuzzleModel(
      horizontalSize: 0,
      verticalSize: 0,
      name: 'My Puzzle',
      wordList: <String>[],
      foundWordList: <String>[],
      timer: 0,
      timerLast: 0,
      grid: <List<String>>[],);

  @override
  void initState() {
    super.initState();
    wordPuzzleModel = widget.wordPuzzleModel;
    _nameController.text = 'My Puzzle';
  }

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
                Navigator.pop(context, wordPuzzleModel);
              },
              iconData: Icons.arrow_back,
            ),
            const Spacer(),
            const AppBarTitle(title: 'WORD LIST'),
            const Spacer(),
            ActionButton(
              onTap: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriesPage(),
                  ),
                );

                if (result is List<String>) {
                  setState(() {
                    // wordPuzzleModel.wordList =
                    //     [...wordPuzzleModel.wordList, ...result].toList();

                    Set<String> set1 = wordPuzzleModel.wordList.toSet();
                    Set<String> set2 = result.toSet();

                    // Find the new words that are in list2 but not in list1
                    Set<String> newWords = set2.difference(set1);

                    // Calculate the length of new words
                    int newWordsLength = newWords.length;

                    wordPuzzleModel.wordList = [...set1, ...newWords].toList();

                    GeneralUtility().showSnackbarSuccess(
                        context, 'Added $newWordsLength words, total is now ${wordPuzzleModel.wordList.length}');
                  });
                }
              },
              iconData: Icons.library_books,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextBox(
              hintText: 'LIST NAME...',
              onTextChanged: (String value) {
                setState(() {
                  wordPuzzleModel.name = value;
                });
              },
              onSubmitted: (String value) {
                setState(() {
                  wordPuzzleModel.name = value;
                });
                FocusScope.of(context).unfocus();
              },
              controller: _nameController,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.2),
                  border: Border(
                    left: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1)),
                    right: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1)),
                    bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1)),
                  ),
                ),
                child: wordPuzzleModel.wordList.isNotEmpty
                    ? ListView.builder(
                        itemCount: wordPuzzleModel.wordList.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                              color: Theme.of(context).colorScheme.primary,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    wordPuzzleModel.wordList[index]
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          wordPuzzleModel.wordList
                                              .removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ))
                                ],
                              ));
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.list_alt,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start typing below or choose\nfrom categories at the top right.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5)),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                      top: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextBox(
                  hintText: 'TYPE WORD AND ENTER...',
                  onTextChanged: (String value) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  onSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      if (value.length >= 3) {
                        if (!wordPuzzleModel.wordList
                            .contains(value.toUpperCase())) {
                          setState(() {
                            wordPuzzleModel.wordList.add(value.toUpperCase());
                            _addWordController.clear();
                          });
                        } else {
                          GeneralUtility().showSnackbarError(
                              context, 'Word already exists');
                        }
                      } else {
                        GeneralUtility()
                            .showSnackbarError(context, 'Word must be longer');
                      }
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  controller: _addWordController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
