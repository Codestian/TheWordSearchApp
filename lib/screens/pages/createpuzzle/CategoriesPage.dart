import 'package:flutter/material.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/TextBox.dart';
import 'package:word_search/models/category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Category> categories = <Category>[
    Category(
        title: 'Fruits',
        wordList: ['Apple', 'Banana', 'Cherry', 'Orange', 'Grape']),
    Category(
        title: 'Colors',
        wordList: ['Red', 'Blue', 'Green', 'Orange', 'Pink', 'Purple']),
    Category(title: 'Animals', wordList: [
      'Dog',
      'Cat',
      'Elephant',
      'Lion',
      'Tiger',
      'Monkey',
      'Bear'
    ]),
    Category(
        title: 'Countries',
        wordList: ['Canada', 'Japan', 'Brazil', 'Australia', 'Germany']),
    Category(title: 'Sports', wordList: [
      'Soccer',
      'Basketball',
      'Tennis',
      'Baseball',
      'Hockey',
      'Rugby'
    ]),
    Category(
        title: 'Vegetables',
        wordList: ['Carrot', 'Potato', 'Broccoli', 'Spinach', 'Lettuce']),
    Category(
        title: 'Seasons', wordList: ['Spring', 'Summer', 'Autumn', 'Winter']),
    Category(title: 'Professions', wordList: [
      'Teacher',
      'Doctor',
      'Engineer',
      'Nurse',
      'Artist',
      'Lawyer'
    ]),
    Category(
        title: 'Vehicles',
        wordList: ['Car', 'Bus', 'Bicycle', 'Airplane', 'Train']),
    Category(
        title: 'Flowers',
        wordList: ['Rose', 'Tulip', 'Daisy', 'Orchid', 'Lily']),
    Category(
        title: 'Insects',
        wordList: ['Ant', 'Bee', 'Butterfly', 'Mosquito', 'Fly']),
    Category(
        title: 'Cities',
        wordList: ['Paris', 'London', 'Tokyo', 'New York', 'Sydney']),
    Category(
        title: 'Shapes',
        wordList: ['Circle', 'Square', 'Triangle', 'Rectangle']),
    Category(
        title: 'Food',
        wordList: ['Pizza', 'Burger', 'Salad', 'Sandwich', 'Pasta']),
    Category(
        title: 'Ocean',
        wordList: ['Whale', 'Shark', 'Dolphin', 'Coral', 'Wave']),
  ];

  List<Category> results = <Category>[];

  @override
  void initState() {
    super.initState();
    results = categories;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            forceMaterialTransparency: true,
            title: Row(
              children: <Widget>[
                ActionButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  iconData: Icons.arrow_back,
                ),
                const Spacer(),
                const AppBarTitle(title: 'CATEGORIES'),
                const Spacer(),
                ActionButton(
                  onTap: () {},
                  iconData: Icons.abc,
                  isVisible: false,
                ),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextBox(
                  hintText: 'SEARCH...',
                  onTextChanged: (String value) {
                    setState(() {
                      if (value.isEmpty) {
                        results = categories; // Show all data if query is empty
                      } else {
                        results = categories
                            .where((Category item) => item.title
                                .toUpperCase()
                                .contains(value.toUpperCase())) // Filter
                            .toList();
                      }
                    });
                  },
                  onSubmitted: (String value) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: _searchController,
                ),
              ),
              Expanded(
                  child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.2),
                        border: Border(
                          left: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1)),
                          right: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1)),
                          bottom: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1)),
                        ),
                      ),
                      child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                padding: EdgeInsets.all(12),
                                color: Theme.of(context).colorScheme.primary,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          results[index].title.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              letterSpacing: 4,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                          child: Text(
                                            ("${results[index].wordList.length} words")
                                                .toUpperCase(),
                                            style: TextStyle(
                                                letterSpacing: 2,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(
                                            context, results[index].wordList);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        child: Center(
                                            child: Icon(Icons.add,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                      ),
                                    )
                                  ],
                                ));
                          })),
                ),
              )),
            ],
          ),
        ));
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: <Widget>[
      Expanded(
        child: Text('list'),
      ),
    ]);
  }
}
