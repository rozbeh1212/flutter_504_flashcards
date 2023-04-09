import 'dart:convert';
import 'package:flutter/services.dart';
import 'progress.dart';

class ProgressService {
  static Future<List> loadProgressList() async {
    final jsonStr = await rootBundle.loadString('assets/progress.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => Progress.fromJson(json)).toList();
  }
}
