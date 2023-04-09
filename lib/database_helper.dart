import 'package:flutter_application_2/progress.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "my_database.db";
  static final _databaseVersion = 1;

  static final tableWords = 'words';
  static final columnId = '_id';
  static final columnWord = 'word';
  static final columnDefinition = 'definition';

  static final progressTable = 'progress';
  static final columnCorrect = 'correct';
  static final columnTotal = 'total';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = await getDatabasesPath();
    String fullPath = join(path, _databaseName);
    return await openDatabase(fullPath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableWords (
        $columnId INTEGER PRIMARY KEY,
        $columnWord TEXT NOT NULL,
        $columnDefinition TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $progressTable (
        $columnId INTEGER PRIMARY KEY,
        $columnWord TEXT NOT NULL,
        $columnCorrect INTEGER NOT NULL,
        $columnTotal INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertWord(String word, String definition) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {columnWord: word, columnDefinition: definition};
    return await db.insert(tableWords, row);
  }

  Future<List<Map<String, dynamic>>> queryAllWords() async {
    Database db = await instance.database;
    return await db.query(tableWords);
  }

  Future<void> saveProgress(Progress progress) async {
    final db = await database;

    await db.insert(
      progressTable,
      {
        columnWord: progress.word,
        columnCorrect: progress.correct,
        columnTotal: progress.total,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
