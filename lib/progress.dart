class Progress {
  final String word;
  final String definition;
  final String date;
   final int total;
  final int correct;


  double get percentage => (correct / total) * 100;

  Progress({required this.word, required this.definition, required this.date,required this.total,required this.correct});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      word: json['word'],
      definition: json['definition'],
      date: json['date'],
       total: 10,
        correct: 8
    );
  }
    void save() {
      
  }
}
