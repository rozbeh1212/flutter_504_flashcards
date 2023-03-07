
import '/database_helper.dart';

class Word {
  final int id;
  final String word;
  final String meaning;
  final String? phonetic;
  final String? description;
  final String? examples;
  final String? pronunciationUK;
  final String? pronunciationUS;
  final String? partOfSpeech;
  final int known;

  Word({
    required this.id,
    required this.word,
    required this.meaning,
    this.phonetic,
    this.description,
    this.examples,
    this.pronunciationUK,
    this.pronunciationUS,
    this.partOfSpeech,
    required this.known,
  });

  Word copyWith({
    int? id,
    String? word,
    String? meaning,
    String? phonetic,
    String? description,
    String? examples,
    String? pronunciationUK,
    String? pronunciationUS,
    String? partOfSpeech,
    int? known,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      phonetic: phonetic ?? this.phonetic,
      description: description ?? this.description,
      examples: examples ?? this.examples,
      pronunciationUK: pronunciationUK ?? this.pronunciationUK,
      pronunciationUS: pronunciationUS ?? this.pronunciationUS,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      known: known ?? this.known,
    );
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map[DatabaseHelper.columnId],
      word: map[DatabaseHelper.columnWord],
      meaning: map[DatabaseHelper.columnMeaning],
      phonetic: map[DatabaseHelper.columnPhonetic],
      description: map[DatabaseHelper.columnDescription],
      examples: map[DatabaseHelper.columnExamples],
      pronunciationUK: map[DatabaseHelper.columnPronunciationUK],
      pronunciationUS: map[DatabaseHelper.columnPronunciationUS],
      partOfSpeech: map[DatabaseHelper.columnPartOfSpeech],
      known: map[DatabaseHelper.columnKnown],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnWord: word,
      DatabaseHelper.columnMeaning: meaning,
      DatabaseHelper.columnPhonetic: phonetic,
      DatabaseHelper.columnDescription: description,
      DatabaseHelper.columnExamples: examples,
      DatabaseHelper.columnPronunciationUK: pronunciationUK,
      DatabaseHelper.columnPronunciationUS: pronunciationUS,
      DatabaseHelper.columnPartOfSpeech: partOfSpeech,
      DatabaseHelper.columnKnown: known,
    };
  }
}
