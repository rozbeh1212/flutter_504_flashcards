// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'word.dart';

class DatabaseHelper {
  static const _databaseName = "word_database.db";
  static const _databaseVersion = 1;

  static const table = 'word_table';

  static const columnId = '_id';
  static const columnWord = 'word';
  static const columnMeaning = 'meaning';
  static const columnPhonetic = 'phonetic';
  static const columnDescription = 'description';
  static const columnExamples = 'examples';
  static const columnPronunciationUK = 'pronunciation_uk';
  static const columnPronunciationUS = 'pronunciation_us';
  static const columnPartOfSpeech = 'part_of_speech';
  static const columnKnown = 'known';



  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }
  

  // Open the database connection.
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    // Delete any existing database.
    await deleteDatabase(path);

    // Create the database and return the connection.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database table.
  // ignore: prefer_const_declarations
  static final String _onCreateSql = '''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnWord TEXT NOT NULL,
      $columnMeaning TEXT NOT NULL,
      $columnPhonetic TEXT NOT NULL,
      $columnDescription TEXT NOT NULL,
      $columnExamples TEXT NOT NULL,
      $columnPronunciationUK TEXT NOT NULL,
      $columnPronunciationUS TEXT NOT NULL,
      $columnPartOfSpeech TEXT NOT NULL,
      $columnKnown INTEGER NOT NULL
    )
  ''';

  // Create the database table.
  Future _onCreate(Database db, int version) async {
    await db.execute(_onCreateSql);
  }

  // Insert a word into the database.
  Future<int> insert(Word word) async {
    var db = await database;
    return await db.insert(table, word.toMap());
  }

  // Update a word in the database.
  Future<int> update(Word word) async {
    var db = await database;
   return await db.update(table, word.toMap(),
           where: '${DatabaseHelper.columnId} = ?', whereArgs: [word.id]);
   
  }

  // Delete a word from the database.
  Future<int> delete(int id) async {
    var db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Get all the words from the database.
  Future<List<Word>> getAllWords() async {
    var db = await database;
    var result = await db.query(table);
    return result.map((e) => Word.fromMap(e)).toList();
  }

  // Get a specific word from the database by ID.
  Future<Word?> getWordById(int id) async {
var db = await database;
var result =
await db.query(table, where: '$columnId = ?', whereArgs: [id]);
return result.isNotEmpty ? Word.fromMap(result.first) : null;
}


// Get the count of all words in the database.
Future getCount() async {
var db = await database;
return Sqflite.firstIntValue(
await db.rawQuery('SELECT COUNT(*) FROM $table'));
}


// Close the database connection.
Future close() async {
var db = await database;
db.close();
}

}