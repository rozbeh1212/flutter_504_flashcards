// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'word.dart';

class LernkarteiScreen extends StatefulWidget {
  const LernkarteiScreen({Key? key}) : super(key: key);

  @override
  _LernkarteiScreenState createState() => _LernkarteiScreenState();
}

class _LernkarteiScreenState extends State<LernkarteiScreen> {
  List<Word> _words = [];
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

 Future<void> _loadWords() async {
   final List<Word> allWords = await DatabaseHelper.instance.getAllWords();
   final List<Word> lernkarteiWords = [];
 
  for (final word in allWords) {
      if (word.lastStudied == null ||
          word.interval! <= DateTime.now().difference(word.lastStudied!).inDays) {
        lernkarteiWords.add(word);
      }
    }
 
   setState(() {
     _words = lernkarteiWords;
   });
 }
 

  void _onWordKnown(Word word) {
    setState(() {
      word.lastStudied = DateTime.now();
      word.interval = (word.interval != null ? word.interval! : 1) * 2;
    });

    DatabaseHelper.instance.update(word);
    _loadWords(); // reload the list after updating the word
  }

  void _onWordUnknown(Word word) {
    setState(() {
      word.lastStudied = DateTime.now();
      word.interval = 1;
    });

    DatabaseHelper.instance.update(word);
    _loadWords(); // reload the list after updating the word
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernkartei'),
      ),
      body: _words.isEmpty
          ? const Center(child: Text('No words to study!'))
          : ListView.builder(
              itemCount: _words.length,
              itemBuilder: (BuildContext context, int index) {
                final Word word = _words[index];
                return Card(
                  child: ListTile(
                    title: Text(word.word),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(word.definition),
                        const SizedBox(height: 4),
                        Text(
                          'Last studied: ${word.lastStudied == null ? "-" : _dateFormat.format(word.lastStudied!)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => _onWordKnown(word),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _onWordUnknown(word),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
