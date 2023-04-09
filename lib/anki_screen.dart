import 'package:flutter/material.dart';
import 'package:flutter_application_2/database_helper.dart';
import 'package:flutter_application_2/progress.dart';

class AnkiScreen extends StatefulWidget {
  @override
  _AnkiScreenState createState() => _AnkiScreenState();

  void addWord(String word, String definition) {}
}

class _AnkiScreenState extends State<AnkiScreen> {
  late TextEditingController _wordController;
  late TextEditingController _definitionController;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _definitionController = TextEditingController();
    _databaseHelper = DatabaseHelper.instance;
  }

  @override
  void dispose() {
    _wordController.dispose();
    _definitionController.dispose();
    super.dispose();
  }
//
  void addWord() async {
    final word = _wordController.text;
    final definition = _definitionController.text;
    final id = await _databaseHelper.insertWord(word, definition);
    setState(() {
      _wordController.clear();
      _definitionController.clear();
    });
    print('Added word with id: $id');
  }

  void save() async {
    final total = 10; // example total
    final correct = 7; // example correct
    final date = DateTime.now().toString(); // example date
    final progress = Progress(
      word: 'example word',
      definition: 'example definition',
      total: total,
      correct: correct,
      date: date,
    );
    await _databaseHelper.saveProgress(progress);
    print('Progress saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Learning App'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _wordController,
              decoration: InputDecoration(hintText: 'Word'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _definitionController,
              decoration: InputDecoration(hintText: 'Definition'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addWord,
              child: Text('Add Word'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: save,
              child: Text('Save Progress'),
            ),
          ],
        ),
      ),
    );
  }
}
