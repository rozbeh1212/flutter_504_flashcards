import 'Word.dart';

class LeitnerSystem {
  List<List<Word>> boxes = [[], [], [], []];

  void addWord(Word word) {
    boxes[0].add(word);
  }

  Word? getNextWord() {
    for (var i = 0; i < boxes.length - 1; i++) {
      if (boxes[i].isNotEmpty) {
        return boxes[i].removeAt(0);
      }
    }
    if (boxes.last.isNotEmpty) {
      return boxes.last.removeAt(0);
    }
    return null;
  }

  void updateWord(Word word, bool memorized) {
    if (memorized) {
      if (boxes.first.contains(word)) {
        boxes.first.remove(word);
        boxes[1].add(word);
      } else if (boxes[1].contains(word)) {
        boxes[1].remove(word);
        boxes[2].add(word);
      } else if (boxes[2].contains(word)) {
        boxes[2].remove(word);
        boxes[3].add(word);
      }
    } else {
      if (boxes.last.contains(word)) {
        boxes.last.remove(word);
        boxes[2].add(word);
      } else if (boxes[3].contains(word)) {
        boxes[3].remove(word);
        boxes[2].add(word);
      } else if (boxes[2].contains(word)) {
        boxes[2].remove(word);
        boxes[1].add(word);
      } else if (boxes[1].contains(word)) {
        boxes[1].remove(word);
        boxes.first.add(word);
      }
    }
  }
}
