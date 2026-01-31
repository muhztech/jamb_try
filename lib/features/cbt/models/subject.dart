import 'question.dart';

class Subject {
  final String id;
  final String name;
  final List<Question> questions;

  const Subject({
    required this.id,
    required this.name,
    required this.questions,
  });
}
