// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Word {
  final String word;
  final String definition;
  final String phonetics;
  final String example;
  final String partOfSpeech;

  Word({
    required this.word,
    required this.definition,
    required this.phonetics,
    required this.example,
    required this.partOfSpeech,
  });

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'definition': definition,
      'phonetics': phonetics,
      'example': example,
      'partOfSpeech': partOfSpeech,
    };
  }

  @override
  String toString() {
    return 'Word{word: $word, definition: $definition, phonetics: $phonetics, example: $example, partOfSpeech: $partOfSpeech}';
  }
}

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<Word> words = [];
  List<Word> leitnerWords = [];
  int leitnerBadgeCount = 0;

  late File _vocabularyFile;
  late File _leitnerFile;

  @override
  void initState() {
    super.initState();
    _initFiles();
  }

  void _initFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    _vocabularyFile = File('${directory.path}/vocabulary.json');
    _leitnerFile = File('${directory.path}/leitner.json');
    await _loadWords();
    await _loadLeitnerWords();
  }

  Future<void> _loadWords() async {
    final contents = await _vocabularyFile.readAsString();
    final json = jsonDecode(contents) as List<dynamic>;
    setState(() {
      words = json
          .map(
            (j) => Word(
              word: j['word'],
              definition: j['definition'],
              phonetics: j['phonetics'],
              example: j['example'],
              partOfSpeech: j['partOfSpeech'],
            ),
          )
          .toList();
    });
  }

  Future<void> _loadLeitnerWords() async {
    if (await _leitnerFile.exists()) {
      final contents = await _leitnerFile.readAsString();
      final json = jsonDecode(contents) as List<dynamic>;
      setState(() {
        leitnerWords = json
            .map(
              (j) => Word(
                word: j['word'],
                definition: j['definition'],
                phonetics: j['phonetics'],
                example: j['example'],
                partOfSpeech: j['partOfSpeech'],
              ),
            )
            .toList();
        leitnerBadgeCount = leitnerWords.length;
      });
    }
  }

  void memorizeWord(Word word) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Memorized word'),
            content: Text('You memorized the word "${word.word}"'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'))
            ],
          );
        });
  }

  void dontKnowWord(Word word) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do not know word'),
            content: Text('You do not know the word "${word.word}"'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      leitnerWords.add(word);
                      leitnerBadgeCount = leitnerWords.length;
                    });
                    _saveLeitnerWords();
                  },
                  child 
: const Text('Add to Leitner'))
            ],
          );
        });
  }

  Future _localFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$filename');
  }

  void _saveLeitnerWords() async {
    final file = await _localFile('leitner.json');
    final json = jsonEncode(leitnerWords.map((w) => w.toMap()).toList());
    await file.writeAsString(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return ListTile(
            title: Text(word.word),
            subtitle: Text(word.definition),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => memorizeWord(word),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => dontKnowWord(word),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.search),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Words',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (leitnerBadgeCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$leitnerBadgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Leitner System',
          ),
        ],
      ),
    );
  }
}
