import 'package:flutter/material.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/puzzle/PuzzleGrid.dart';
import 'package:word_search/models/word_puzzle_model.dart';
import 'package:word_search/utils/debouncer.dart';

class SolveGridPage extends StatefulWidget {
  final List<List<String>> gridList;

  const SolveGridPage({super.key, required this.gridList});

  @override
  _SolveGridPageState createState() => _SolveGridPageState();
}

class _SolveGridPageState extends State<SolveGridPage> {
  final TextEditingController _searchController = TextEditingController();
  late final Debouncer _debouncer;
 List<List<List<int>>> solvedWords = [];

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 500);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mock search function that simulates a search action
  void _performSearch(String query) {
    setState(() {
      solvedWords = [];
    });
    if (query.isNotEmpty) {

      String queryFixed = query.toUpperCase().trim();

      // List<List<int>> listOfFirstCharacters =
      //     findCharacterIndexes(widget.gridList, queryFixed[0]);

      // List<List<List<int>>> results =
      //     wordSearch(widget.gridList, listOfFirstCharacters, queryFixed, false);

      //     setState(() {
      //       solvedWords = results;
      //     });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              ActionButton(
                onTap: () {
                  Navigator.pop(context);
                },
                iconData: Icons.arrow_back,
              ),
              const Spacer(),
              const AppBarTitle(title: 'SOLVE PUZZLE'),
              const Spacer(),
              ActionButton(
                onTap: () {
                },
                iconData: Icons.abc,
                isVisible: false,
              ),
            ],
          ),
        ),
        body: Column(children: [
          PuzzleGrid(
            transformationController: TransformationController(),
            wordGrid: widget.gridList,
            solvedWords: solvedWords,
            listOfColors: [],
            onDrag: (String word) {
              
            },
            onDragEnd: (List<List<int>> coords, String word) {
              
            },
            isPaused: false,
            overlayChildren: [],
            showOverlay: false,
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
              child: Text(''),
            ),
          ),
          TextField(
            controller: _searchController,
            onChanged: (query) {
              // Call the debouncer run method to delay search execution
              _debouncer.run(() {
                _performSearch(query); // Execute search after debounce delay
              });
            },
            decoration: InputDecoration(
              labelText: 'Type in a word...',
              border: OutlineInputBorder(),
            ),
          ),
        ]));
  }
}

void findWords(List<String> wordsToSearch) {

}



