class Word {
  final int id;
  final String word;
  final String meaning;
  final String phonetic;
  final String description;
  final String examples;
  final String pronunciationUK;
  final String pronunciationUS;
  final String partOfSpeech;
  final int known;

  Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.phonetic,
    required this.description,
    required this.examples,
    required this.pronunciationUK,
    required this.pronunciationUS,
    required this.partOfSpeech,
    required this.known,
  });

  // Define the copyWith method here
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

  // Define the fromMap method here
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map[columnId],
      word: map[columnWord],
      meaning: map[columnMeaning],
      phonetic: map[columnPhonetic],
      description: map[columnDescription],
      examples: map[columnExamples],
      pronunciationUK: map[columnPronunciationUK],
      pronunciationUS: map[columnPronunciationUS],
      partOfSpeech: map[columnPartOfSpeech],
      known: map[columnKnown],
    );
  }

  // Define the toMap method here
  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnWord: word,
      columnMeaning: meaning,
      columnPhonetic: phonetic,
      columnDescription: description,
      columnExamples: examples,
      columnPronunciationUK: pronunciationUK,
      columnPronunciationUS: pronunciationUS,
      columnPartOfSpeech: partOfSpeech,
      columnKnown: known,
    };
  }
}
