import 'package:flutter/material.dart';

import 'Word.dart';

class FlashcardScreen extends StatefulWidget {
  final Word word;

  FlashcardScreen({required this.word});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  bool _showDefinition = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.word.word)),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showDefinition = !_showDefinition;
            });
          },
          child: Card(
            child: Container(
              width: 300,
              height: 200,
              alignment: Alignment.center,
              child: _showDefinition
                  ? Text(widget.word.definition)
                  : Text(widget.word.word),
            ),
          ),
        ),
      ),
    );
  }
}
