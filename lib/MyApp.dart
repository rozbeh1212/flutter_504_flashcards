import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'Word.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Word> _vocabulary = [];
  final _formKey = GlobalKey<FormState>();
  String _newWord = '';
  String _newDefinition = '';

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

  void _handleNewWordSubmitted() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newWord =
          Word(word: _newWord.trim(), definition: _newDefinition.trim());
      setState(() {
        _vocabulary.add(newWord);
      });
      _saveVocabulary();
      _showAddedConfirmationDialog(newWord);
    }
  }

  Future<void> _showAddedConfirmationDialog(Word word) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New word added'),
        content: Text(
            'The word "${word.word}" has been added to your vocabulary list.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _saveVocabulary() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/vocabulary.json');
    final jsonString =
        json.encode(_vocabulary.map((word) => word.toJson()).toList());
    await file.writeAsString(jsonString);
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
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'New word'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a word';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _newWord = value!;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Definition'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a definition';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _newDefinition = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _handleNewWordSubmitted,
              child: Text('Add Word'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _vocabulary.length,
                itemBuilder: (context, index) {
                  final word = _vocabulary[index];
                  return ListTile(
                    title: Text(word.word),
                    subtitle: Text(word.definition),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
