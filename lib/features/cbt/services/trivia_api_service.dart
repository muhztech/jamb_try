import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/question.dart';

class TriviaApiService {
  static const String _baseUrl =
      'https://opentdb.com/api.php?amount=40&type=multiple';

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load questions');
    }

    final data = jsonDecode(response.body);
    final List results = data['results'];

    return results.map((item) {
      final List<String> options = [
        ...item['incorrect_answers'].map<String>((e) => e.toString()),
        item['correct_answer'].toString(),
      ]..shuffle();

      final correctIndex =
          options.indexOf(item['correct_answer'].toString());

      return Question(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: _decode(item['question']),
        options: options.map(_decode).toList(),
        correctIndex: correctIndex,
        explanation: '',
      );
    }).toList();
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
