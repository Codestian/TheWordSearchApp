class Category {
  int? id;  // Optional: for SQLite primary key
  String title;
  List<String> wordList;

  Category({this.id, required this.title, required this.wordList});

  // Convert Category into a Map (for storing in SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'wordList': wordList.join(',') // Join the list into a single string
    };
  }

  // Convert Map into a Category
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      title: map['title'],
      wordList: map['wordList'].split(','),  // Split the string back into a list
    );
  }
}
