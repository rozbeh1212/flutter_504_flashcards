import 'package:flutter/material.dart';
import 'flashcard_screen.dart';
import 'progress_screen.dart';
import 'anki_screen.dart'; // Import the AnkiScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FlashcardScreen(),
        '/progress': (context) => ProgressScreen(),
        '/anki': (context) => AnkiScreen(), // Add the AnkiScreen
      },
    );
  }
}
