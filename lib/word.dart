class Word {
  int? id;
  String word;
  String definition;
  DateTime? lastStudied;
  int? interval;

  Word({
    required this.word,
    required this.definition,
    required this.lastStudied,
    required this.interval,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'interval': interval,
      'lastStudied': lastStudied != null ? lastStudied!.millisecondsSinceEpoch : null,
    };
  }

  set intervalValue(num value) {
    interval = value.toInt();
    lastStudied = DateTime.now();
  }
}
