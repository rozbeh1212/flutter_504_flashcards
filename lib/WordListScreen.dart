import 'package:flutter/material.dart';
import 'word.dart';
import 'database_helper.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({Key? key}) : super(key: key);

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  late List<Word> _words;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await _databaseHelper.getAllWords();
    setState(() {
      _words = words;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word List'),
      ),
      body: ListView.builder(
        itemCount: _words.length,
        itemBuilder: (context, index) {
          final word = _words[index];
          return ListTile(
            title: Text(word.word),
            subtitle: Text(word.meaning),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordDetailScreen(word: word),
                ),
              ).then((value) {
                _loadWords();
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addword');
          if (result == true) {
            _loadWords();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
