import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Word.dart';
import 'WordCard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Word> _vocabulary = [];

  Future<void> _loadVocabulary() async {
    try {
      final jsonString = await rootBundle.loadString('assets/vocabulary.json');
      final jsonList = json.decode(jsonString) as List;
      setState(() {
        _vocabulary = jsonList.map((word) => Word.fromJson(word)).toList();
      });
    } catch (e) {
      print('Error loading vocabulary: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Vocabulary',
      home: Scaffold(
        appBar: AppBar(title: Text('My Vocabulary')),
        body: ListView.builder(
          itemCount: _vocabulary.length,
          itemBuilder: (context, index) => WordCard(
            word: _vocabulary[index].word,
            definition: _vocabulary[index].definition,
          ),
        ),
      ),
    );
  }
}
