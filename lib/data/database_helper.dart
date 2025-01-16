import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
// Create a singleton instance of DatabaseHelper using the _init() method
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const _databaseVersion = 1;

  // Declare a static nullable variable for holding the actual database instance
  static Database? _database;

  // Private constructor for the DatabaseHelper class, called by the instance variable to create the singleton instance
  DatabaseHelper._init();

  Future<Database> get database async {
    // If the database instance exists, return it
    if (_database != null) return _database!;

    // Otherwise, create a new database instance using the _initDB() method and assign it to the _database variable
    _database = await _initDB('bus_ahead.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // print(path);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future<void> _createDB(Database db, int version) async {
   
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {

  }
}
