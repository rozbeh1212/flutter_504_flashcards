import 'package:flutter/material.dart';
import 'User.dart';
import 'LeitnerSystem.dart';
import 'Word.dart';

class LearnLaterScreen extends StatefulWidget {
  final List<Word> words;

  var user;
  LearnLaterScreen({required this.words, required  this.user});

  @override
  _LearnLaterScreenState createState() => _LearnLaterScreenState();
}

class _LearnLaterScreenState extends State<LearnLaterScreen> {
  
  LeitnerSystem _leitnerSystem = LeitnerSystem();
  Word? _currentWord;

  @override
  void initState() {
    super.initState();
    for (var word in widget.words) {
      _leitnerSystem.addWord(word);
    }
    _getNextWord();
  }

  void _getNextWord() {
    var word = _leitnerSystem.getNextWord();
    if (word != null) {
      setState(() {
        _currentWord = word;
      });
    } else {
      setState(() {
        _currentWord = null;
      });
    }
  }

void _updateWord(bool memorized) {
    if (_currentWord != null) {
      if (memorized) {
        if (_leitnerSystem.boxes.last.contains(_currentWord)) {
          setState(() {
            widget.user.points += 10;
            widget.user.updateLevel();
          });
        } else if (_leitnerSystem.boxes[3].contains(_currentWord)) {
          setState(() {
            widget.user.points += 5;
            widget.user.updateLevel();
          });
        }
        _leitnerSystem.updateWord(_currentWord!, true);
      } else {
        _leitnerSystem.updateWord(_currentWord!, false);
      }
      _getNextWord();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learn Later')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (_currentWord != null) {
                _updateWord(true);
              }
            });
          },
          onLongPress: () {
            setState(() {
              if (_currentWord != null) {
                _updateWord(false);
              }
            });
          },
          child: Card(
            child: Container(
              width: 300,
              height: 200,
              alignment: Alignment.center,
              child: _currentWord != null
                  ? Text(_currentWord!.word)
                  : Text('No more words to memorize!'),
            ),
          ),
        ),
      ),
    );
  }
}
