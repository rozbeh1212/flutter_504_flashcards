// ignore: file_names
// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'word.dart';
import 'database_helper.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> words = [];

  late Word currentWord;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    // load the list of 504 words from the database
    words = await DatabaseHelper.instance.getAllWords();

    // set the currentWord to the first word in the list
    setState(() {
      currentWord = words[0];
    });
  }

  void _showNextWord() {
    // get the index of the current word in the list
    int index = words.indexOf(currentWord);

    // if the current word is not the last word in the list, show the next word
    if (index < words.length - 1) {
      setState(() {
        currentWord = words[index + 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentWord.word,
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              currentWord.definition,
              style: TextStyle(fontSize: 18.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _showNextWord,
                  child: Text('Know This Word'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.insertIntoLernkartei(currentWord);
                    _showNextWord();
                  },
                  child: Text('Do Not Know'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
