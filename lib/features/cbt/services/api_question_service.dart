import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/question.dart';

class ApiQuestionService {
  static Future<List<Question>> fetchQuestions(String subject) async {
    final url =
        Uri.parse("https://opentdb.com/api.php?amount=40&type=multiple");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load questions");
    }

    final data = jsonDecode(response.body);
    final results = data['results'] as List;

    return results.map((q) {
      final options = List<String>.from(q['incorrect_answers']);
      options.add(q['correct_answer']);
      options.shuffle();

      final correctIndex = options.indexOf(q['correct_answer']);

      return Question(
        question: q['question'],
        options: options,
        correctIndex: correctIndex,
      );
    }).toList();
  }
}
