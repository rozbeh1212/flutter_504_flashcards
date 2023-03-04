import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'word.dart';

class DatabaseHelper {
  static const _databaseName = 'words_database.db';
  static const _databaseVersion = 1;

  static const table = 'words';

  static const columnId = '_id';
  static const columnWord = 'word';
  static const columnDefinition = 'definition';

  late Database _database;

  // ignore: prefer_typing_uninitialized_variables
  static var columnLearnt;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future get database async {
    return _database = _database ?? await _initDatabase();
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $table (
$columnId INTEGER PRIMARY KEY,
$columnWord TEXT NOT NULL,
$columnDefinition TEXT NOT NULL
)
''');
  }

  Future _initDatabase() async {
    final path = await getDatabasesPath();
    return await openDatabase('$path/$_databaseName',
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<int> insert(Word word) async {
    final db = await database;
    return await db.insert(table, word.toMap());
  }

  Future<List<Word>> getAllWords() async {
    final db = await database;
    final maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Word(
        id: maps[i][columnId],
        word: maps[i][columnWord],
        definition: maps[i][columnDefinition],
        lastStudied: maps[i]['lastStudied'],
        interval: maps[i]['interval'],
      );
    });
  }

  void update(Word word) {}

Future<int> insertIntoLernkartei(Word word) async {
  final db = await instance.database;
  return await db.insert(table, word.toMap());
}

  // public void insertIntoLernkartei(String question, String answer) {}
}
