import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/question.dart';
import '../models/subject.dart';
import '../data/subjects_data.dart';
import 'exam_storage.dart';

class ExamController extends ChangeNotifier {
  // ============================================================
  // ⏱ TIMER CONFIG
  // ============================================================
  static const int totalTimeSeconds = 40 * 60;
  static const int warningTimeSeconds = 5 * 60;

  int _remainingSeconds = totalTimeSeconds;
  Timer? _timer;

  // ============================================================
  // 🧠 EXAM STATE
  // ============================================================
  int _currentSubjectIndex = 0;
  int _currentQuestionIndex = 0;
  bool _submitted = false;

  // answers[subjectId][questionIndex] = optionIndex
  final Map<String, Map<int, int>> _answers = {};

  // ============================================================
  // 🔍 REVIEW MODE
  // ============================================================
  bool _reviewMode = false;
  final List<_WrongItem> _wrongItems = [];
  int _reviewIndex = 0;

  // ============================================================
  // 📌 GETTERS
  // ============================================================
  List<Subject> get subjects => utmeSubjects;

  int get currentSubjectIndex => _currentSubjectIndex;

  Subject get currentSubject => subjects[_currentSubjectIndex];
  List<Question> get currentQuestions => currentSubject.questions;

  Question get currentQuestion => currentQuestions[_currentQuestionIndex];

  int get currentIndex => _currentQuestionIndex;
  int get totalQuestions => currentQuestions.length;
  bool get isSubmitted => _submitted;

  int get remainingSeconds => _remainingSeconds;
  bool get isWarningTime => _remainingSeconds <= warningTimeSeconds;

  String get formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  int? get selectedOption {
    final subjectId = currentSubject.id;
    return _answers[subjectId]?[_currentQuestionIndex];
  }

  bool get isCurrentAnswered => selectedOption != null;

  /// ✅ Needed by QuestionNavigationGrid to color answered questions
  Map<int, int?> get answeredMap {
    final subjectId = currentSubject.id;
    final map = _answers[subjectId] ?? {};
    return map.map((k, v) => MapEntry(k, v));
  }

  // ============================================================
  // ⏱ TIMER
  // ============================================================
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_submitted) {
        t.cancel();
        return;
      }

      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _autoSave();
        notifyListeners();
      } else {
        t.cancel();
        submitExam();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  // ============================================================
  // 🧭 NAVIGATION
  // ============================================================
  void nextQuestion() {
    if (_currentQuestionIndex < currentQuestions.length - 1) {
      _currentQuestionIndex++;
      _autoSave();
      notifyListeners();
    }
  }

  void prevQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _autoSave();
      notifyListeners();
    }
  }

  void jumpTo(int index) {
    if (index >= 0 && index < currentQuestions.length) {
      _currentQuestionIndex = index;
      _autoSave();
      notifyListeners();
    }
  }

  // ============================================================
  // 📚 SUBJECT SWITCHING
  // ============================================================
  void switchSubject(int subjectIndex) {
    if (subjectIndex < 0 || subjectIndex >= subjects.length) return;
    _currentSubjectIndex = subjectIndex;
    _currentQuestionIndex = 0;
    _autoSave();
    notifyListeners();
  }

  // ============================================================
  // ✍ ANSWERS
  // ============================================================
  void selectOption(int optionIndex) {
    final subjectId = currentSubject.id;
    _answers.putIfAbsent(subjectId, () => {});
    _answers[subjectId]![_currentQuestionIndex] = optionIndex;
    _autoSave();
    notifyListeners();
  }

  void submitAnswer() {
    _autoSave();
    notifyListeners();
  }

  // ============================================================
  // 📝 SUBMIT EXAM
  // ============================================================
  void submitExam() {
    if (_submitted) return;
    _submitted = true;
    stopTimer();
    clearSavedExam();
    notifyListeners();
  }

  // ============================================================
  // 📊 RESULT CALCULATION
  // ============================================================
  int get correctCount {
    int correct = 0;
    for (final subject in subjects) {
      final subjectAnswers = _answers[subject.id] ?? {};
      for (int i = 0; i < subject.questions.length; i++) {
        final selected = subjectAnswers[i];
        if (selected != null && selected == subject.questions[i].correctIndex) {
          correct++;
        }
      }
    }
    return correct;
  }

  int get wrongCount {
    int wrong = 0;
    for (final subject in subjects) {
      final subjectAnswers = _answers[subject.id] ?? {};
      for (int i = 0; i < subject.questions.length; i++) {
        final selected = subjectAnswers[i];
        if (selected != null && selected != subject.questions[i].correctIndex) {
          wrong++;
        }
      }
    }
    return wrong;
  }

  int get score => correctCount;

  String get timeUsed {
    final used = totalTimeSeconds - _remainingSeconds;
    final m = (used ~/ 60).toString().padLeft(2, '0');
    final s = (used % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  // ============================================================
  // 🔍 REVIEW MODE
  // ============================================================
  void startReview() {
    _reviewMode = true;
    _wrongItems.clear();
    _reviewIndex = 0;

    for (final subject in subjects) {
      final subjectAnswers = _answers[subject.id] ?? {};
      for (int i = 0; i < subject.questions.length; i++) {
        final selected = subjectAnswers[i];
        if (selected != null && selected != subject.questions[i].correctIndex) {
          _wrongItems.add(
            _WrongItem(
              subjectId: subject.id,
              subjectName: subject.name,
              questionIndex: i,
              selectedOption: selected,
            ),
          );
        }
      }
    }
    notifyListeners();
  }

  bool get isReviewMode => _reviewMode;
  bool get hasWrongQuestions => _wrongItems.isNotEmpty;

  Question get currentReviewQuestion {
    final item = _wrongItems[_reviewIndex];
    final subject = subjects.firstWhere((s) => s.id == item.subjectId);
    return subject.questions[item.questionIndex];
  }

  int? get selectedWrongOption =>
      _wrongItems.isEmpty ? null : _wrongItems[_reviewIndex].selectedOption;

  bool get hasPrevReview => _reviewIndex > 0;
  bool get hasNextReview => _reviewIndex < _wrongItems.length - 1;

  void prevReview() {
    if (!hasPrevReview) return;
    _reviewIndex--;
    notifyListeners();
  }

  void nextReview() {
    if (!hasNextReview) return;
    _reviewIndex++;
    notifyListeners();
  }

  void exitReview() {
    _reviewMode = false;
    notifyListeners();
  }

  // ============================================================
  // 💾 PERSISTENCE
  // ============================================================
  void _autoSave() {
    if (!_submitted) saveState();
  }

  Future<void> saveState() async {
    await ExamStorage.save({
      'remainingSeconds': _remainingSeconds,
      'currentSubject': _currentSubjectIndex,
      'currentQuestion': _currentQuestionIndex,
      'answers': _answers,
      'submitted': _submitted,
    });
  }

  Future<bool> restoreState() async {
    final data = await ExamStorage.load();
    if (data == null) return false;

    _remainingSeconds = data['remainingSeconds'];
    _currentSubjectIndex = data['currentSubject'];
    _currentQuestionIndex = data['currentQuestion'];
    _submitted = data['submitted'];

    _answers.clear();
    (data['answers'] as Map).forEach((k, v) {
      _answers[k] = Map<int, int>.from(v);
    });

    notifyListeners();
    startTimer();
    return true;
  }

  Future<void> clearSavedExam() async {
    await ExamStorage.clear();
  }

  // ============================================================
  // 🔄 RESET
  // ============================================================
  void resetExam() {
    stopTimer();
    _remainingSeconds = totalTimeSeconds;
    _currentSubjectIndex = 0;
    _currentQuestionIndex = 0;
    _answers.clear();
    _submitted = false;

    _reviewMode = false;
    _wrongItems.clear();
    _reviewIndex = 0;

    notifyListeners();
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}

// ============================================================
// helper class
// ============================================================
class _WrongItem {
  final String subjectId;
  final String subjectName;
  final int questionIndex;
  final int selectedOption;

  _WrongItem({
    required this.subjectId,
    required this.subjectName,
    required this.questionIndex,
    required this.selectedOption,
  });
}
