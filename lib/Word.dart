class Word {
  final String word;
  final String definition;

  Word({required this.word, required this.definition});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] as String,
      definition: json['definition'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': this.word,
      'definition': this.definition,
    };
  }
}
