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

  /// ✅ ADD THIS METHOD
  Subject copyWith({
    String? id,
    String? name,
    List<Question>? questions,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      questions: questions ?? this.questions,
    );
  }
}
