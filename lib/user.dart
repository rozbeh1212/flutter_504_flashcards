import 'Word.dart';

class User {
  int points;
  int level;
  List<String> badges;
  List<Word> words;

  User({
    required this.points,
    required this.level,
    required this.badges,
    required this.words,
  });

  void updateLevel() {
    level = (points / 100).floor() + 1;
  }
}
