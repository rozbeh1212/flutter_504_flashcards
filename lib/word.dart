import 'package:intl/intl.dart';

class Word {
  late int id;
  late String word;
  late String definition;
  late int lastStudied;
  late num interval;

  Word({required this.word, required this.definition, required this.lastStudied, required this.interval, required this.id});

  // other methods

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'interval': interval,
      'lastStudied': lastStudied != null
          ? DateTime.fromMillisecondsSinceEpoch(lastStudied)
          : null,
    };
  }
  set intervalValue(num value) {
    interval = value;
    lastStudied = DateTime.now().millisecondsSinceEpoch;
  }
}

