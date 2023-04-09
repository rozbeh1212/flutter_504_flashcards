
import 'dart:convert';
import 'package:flutter/services.dart';
import 'word.dart';

class JsonParser {
  static Future<List<Word>> loadWords() async {
    final jsonStr = await rootBundle.loadString('assets/words.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => Word.fromJson(json)).toList();
  }
}
