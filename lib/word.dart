class Word {
  final String word;
  final String definition;

  Word({required this.word, required this.definition});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      definition: json['definition'],
    );
  }
}
