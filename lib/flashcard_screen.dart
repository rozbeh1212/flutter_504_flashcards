import 'package:flutter/material.dart';
import 'json_parser.dart';
import 'word.dart';
import 'progress.dart';
import 'anki_screen.dart';

class FlashcardScreen extends StatefulWidget {
@override
_FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
List<Word> _words = [];

Future<void> _loadWords() async {
final words = await JsonParser.loadWords();
setState(() {
_words = words;
});
}

void _addToAnkiDeck(Word word) {
// Create a new Anki instance
final anki = AnkiScreen();
// Add the word to the Anki deck
anki.addWord(word.word, word.definition);

// Update the progress for the word
final progress = Progress(word: 'word' ,definition: 'definition',  date: DateTime.now().toString(), total: 10, correct: 8 );
progress.save();

// Show a confirmation message
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Added "${word.word}" to Anki deck!'),
    duration: Duration(seconds: 2),
  ),
);
}

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Learning App'),
        actions: [
          IconButton(
            icon: Icon(Icons.track_changes),
            onPressed: () => Navigator.pushNamed(context, '/progress'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _words.length,
          itemBuilder: (BuildContext context, int index) {
            final word = _words[index];
            return Card(
              child: ListTile(
                title: Text(word.word),
                subtitle: Text(word.definition),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addToAnkiDeck(word),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
