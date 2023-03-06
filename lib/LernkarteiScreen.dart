import 'dart:math';
import 'package:flutter/material.dart';
import 'word.dart';
import 'database_helper.dart';

class LernkarteiScreen extends StatefulWidget {
  const LernkarteiScreen({Key? key}) : super(key: key);

  @override
  _LernkarteiScreenState createState() => _LernkarteiScreenState();
}

class _LernkarteiScreenState extends State<LernkarteiScreen> {
  late List<Word> _words;
  late List<Word> _unknownWords;
  late int _currentIndex;
  late bool _showAnswer;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _showAnswer = false;
    _currentIndex = -1;
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await _databaseHelper.getAllWords();
    setState(() {
      _words = words;
      _unknownWords = words.where((word) => !word.known).toList();
    });
    _nextWord();
  }

  void _nextWord() {
    setState(() {
      _showAnswer = false;
      if (_unknownWords.isEmpty) {
        _currentIndex = -1;
      } else {
        _currentIndex = Random().nextInt(_unknownWords.length);
      }
    });
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _toggleKnown() async {
    if (_currentIndex >= 0) {
      final currentWord = _unknownWords[_currentIndex];
      final updatedWord = currentWord.copyWith(known:true);
      await _databaseHelper.update(updatedWord);
      setState(() {
        _words[_words.indexWhere((word) => word.id == currentWord.id)] =
            updatedWord;
        _unknownWords.removeAt(_currentIndex);
      });
      _nextWord();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernkartei'),
      ),
      body: Center(
        child: _currentIndex < 0
            ? const Text('Alle Wörter gelernt!')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _showAnswer
                        ? _unknownWords[_currentIndex].meaning
                        : _unknownWords[_currentIndex].word,
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center ),
                    const SizedBox(height: 32),
                  _showAnswer
                      ? Text(
                          _unknownWords[_currentIndex].word,
                          style: const TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        )
                      : ElevatedButton(
                          onPressed: _toggleAnswer,
                          child: const Text('Antwort anzeigen'),
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _toggleKnown,
                    child: const Text('Gelernt'),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextWord,
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}
