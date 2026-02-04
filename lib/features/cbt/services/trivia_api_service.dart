import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/question.dart';

class TriviaApiService {
  Future<List<Question>> fetchQuestions(String subjectId) async {
    final category = _mapSubjectToCategory(subjectId);

    final url =
        'https://opentdb.com/api.php?amount=40&type=multiple&category=$category';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load questions');
    }

    final data = jsonDecode(response.body);
    final List results = data['results'];

    return results.map<Question>((item) {
      final List<String> options = [
        ...item['incorrect_answers']
            .map<String>((e) => _decode(e)),
        _decode(item['correct_answer']),
      ]..shuffle();

      return Question(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // 🔥 REQUIRED
        question: _decode(item['question']),
        options: options,
        correctIndex:
            options.indexOf(_decode(item['correct_answer'])),
        explanation: _decode(item['correct_answer']),
      );
    }).toList();
  }

  int _mapSubjectToCategory(String subjectId) {
    switch (subjectId.toLowerCase()) {
      case 'english':
        return 9; // General Knowledge
      case 'mathematics':
        return 19; // Math
      case 'physics':
        return 17; // Science & Nature
      case 'chemistry':
        return 17; // Science & Nature
      default:
        return 9;
    }
  }

  static String _decode(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }
}
