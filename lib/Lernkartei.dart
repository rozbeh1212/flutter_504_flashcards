import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


import 'Word.dart';
import 'WordCard.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Word> words;
  Set<String> unknownWords = {};

  @override
  void initState() {
    super.initState();

    loadWords().then((loadedWords) {
      setState(() {
        words = loadedWords;
      });
    });
  }

  Future<List<Word>> loadWords() async {
    // Load words from JSON file
    String jsonString = await rootBundle.loadString('assets/words.json');
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Word.fromJson(json)).toList();
  }

  void addToUnknownWords(String word) {
    setState(() {
      unknownWords.add(word);
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = Word(
      word: 'example', // Replace with the actual word you want to display
      definition: 'def'
    );

    if (words == null) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Words'),
                  Tab(text: 'Lernkartei'),
                ],
              ),
              title: Text('Flutter Demo'),
            ),
            body: TabBarView(
              children: [
                ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    Word word = words[index];

                    return GestureDetector(
                      onTap: () {
                        addToUnknownWords(word.word);
                      },
                      child: WordCard(
                        word: 'abandon',
                        definition: 'to leave behind; to give up; to desert',
                      ),
                    );
                  },
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Started Learning: 1'),
                      Text('Last Day Learned: 30'),
                      Text('Total Words In It: ${unknownWords.length}'),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: unknownWords.length,
                          itemBuilder: (context, index) {
                            String word = unknownWords.elementAt(index);
                            return ListTile(title: Text(word));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
