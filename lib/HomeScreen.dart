import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_2/User.dart';
import 'FlashcardScreen.dart';
import 'LearnLaterScreen.dart';
import 'Word.dart';
import 'badge.dart';
import 'package:http/http.dart'as http;
void main() {
  User user = User(points: 0, level: 1, badges: [], words: []);
  runApp(MaterialApp(
    home: HomeScreen(user: user),
  ));
}

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Word>> _wordsFuture;
  final List<Badges> _badges = [
    Badges(
      name: 'Beginner',
      description: 'Memorize your first 10 words',
      isEarned: (user) => user.level >= 1,
    ),
    Badges(
      name: 'Intermediate',
      description: 'Memorize your first 50 words',
      isEarned: (user) => user.level >= 2,
    ),
    Badges(
      name: 'Advanced',
      description: 'Memorize your first 100 words',
      isEarned: (user) => user.level >= 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _wordsFuture = loadWords();
  }

  Future<List<Word>> loadWords() async {
    String data = await rootBundle.loadString('assets/vocabulary.json');
    List<dynamic> jsonList = jsonDecode(data);
    List<Word> words = jsonList
        .map((json) => Word(word: json['word'], definition: json['definition']))
        .toList();
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Builder')),
      body: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Word>> snapshot) {
          if (snapshot.hasData) {
            List<Word> words = snapshot.data!;
            return ListView.builder(
              itemCount: words.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Points: ${widget.user.points}'),
                        const SizedBox(height: 16),
                        const Text('Badges:'),
                        Column(
                          children: _badges.map((badge) {
                            return Row(
                              children: [
                                Icon(
                                  badge.isEarned(widget.user)
                                      ? Icons.check
                                      : Icons.clear,
                                ),
                                const SizedBox(width: 8),
                                Text('${badge.name}: ${badge.description}'),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                } else {
                  var word = words[index - 1];
                  return ListTile(
                    title: Text(word.word),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FlashcardScreen( word:word, user: widget.user,)),
                      );
                    },
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load words'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LearnLaterScreen(
                words: widget.user.words,
                user: widget.user,
              ),
            ),
          );
  
        },
      ),
    );
  }
}

