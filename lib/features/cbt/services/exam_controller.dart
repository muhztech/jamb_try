import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/question.dart';
import '../models/subject.dart';
import '../data/subjects_data.dart';
import '../services/trivia_api_service.dart';
import 'exam_storage.dart';

class ExamController extends ChangeNotifier {
  // ============================================================
  // TIMER
  // ============================================================
  static const int totalTimeSeconds = 40 * 60;
  static const int warningTimeSeconds = 5 * 60;

  int _remainingSeconds = totalTimeSeconds;
  Timer? _timer;

  // ============================================================
  // EXAM STATE
  // ============================================================
  int _currentSubjectIndex = 0;
  int _currentQuestionIndex = 0;
  bool _submitted = false;

  final Map<String, Map<int, int>> _answers = {};

  // ============================================================
  // REVIEW STATE
  // ============================================================
  bool _reviewMode = false;
  final List<_WrongItem> _wrongItems = [];
  int _reviewIndex = 0;

  // ============================================================
  // GETTERS
  // ============================================================
  List<Subject> get subjects => utmeSubjects;

  int get currentSubjectIndex => _currentSubjectIndex;

  Subject get currentSubject => subjects[_currentSubjectIndex];
  List<Question> get currentQuestions => currentSubject.questions;
  Question get currentQuestion => currentQuestions[_currentQuestionIndex];

  int get remainingSeconds => _remainingSeconds;
  bool get isSubmitted => _submitted;
  bool get isWarningTime => _remainingSeconds <= warningTimeSeconds;

  int get currentIndex => _currentQuestionIndex;
  int get totalQuestions => currentQuestions.length;

  String get formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  String get timeUsed {
    final used = totalTimeSeconds - _remainingSeconds;
    final m = (used ~/ 60).toString().padLeft(2, '0');
    final s = (used % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  int? get selectedOption =>
      _answers[currentSubject.id]?[_currentQuestionIndex];

  Map<int, int?> get answeredMap =>
      _answers[currentSubject.id] ?? {};

  // ============================================================
  // SUBJECT SWITCHING  ✅ ADDED
  // ============================================================
  void switchSubject(int index) {
  if (index < 0 || index >= subjects.length) return;

  _currentSubjectIndex = index;
  _currentQuestionIndex = 0;

  // 🔥 LOAD 40 QUESTIONS FROM API
  loadOnlineQuestionsForCurrentSubject();

  notifyListeners();
}

  // ============================================================
  // API LOADING (FREE API)
  // ============================================================
  Future<void> loadOnlineQuestionsForCurrentSubject() async {
    try {
      final api = TriviaApiService();
     final questions =
    await api.fetchQuestions(currentSubject.id);


      currentSubject.questions
        ..clear()
        ..addAll(questions);

      _currentQuestionIndex = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('API failed – using local questions');
    }
  }

  // ============================================================
  // TIMER
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
        submitExam();
      }
    });
  }

  void stopTimer() => _timer?.cancel();

  // ============================================================
  // NAVIGATION
  // ============================================================
  void nextQuestion() {
    if (_currentQuestionIndex < totalQuestions - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void prevQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void jumpTo(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  // ============================================================
  // ANSWERS
  // ============================================================
  void selectOption(int optionIndex) {
    _answers.putIfAbsent(currentSubject.id, () => {});
    _answers[currentSubject.id]![_currentQuestionIndex] = optionIndex;
    notifyListeners();
  }

  // ============================================================
  // SUBMIT
  // ============================================================
  void submitExam() {
    _submitted = true;
    stopTimer();
    clearSavedExam();
    notifyListeners();
  }

  // ============================================================
  // RESET EXAM  ✅ ADDED
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

    clearSavedExam();
    startTimer();
    notifyListeners();
  }

  // ============================================================
  // RESULTS
  // ============================================================
  int get correctCount {
    int c = 0;
    for (final s in subjects) {
      final a = _answers[s.id] ?? {};
      for (int i = 0; i < s.questions.length; i++) {
        if (a[i] == s.questions[i].correctIndex) c++;
      }
    }
    return c;
  }

  int get wrongCount {
    int w = 0;
    for (final s in subjects) {
      final a = _answers[s.id] ?? {};
      for (int i = 0; i < s.questions.length; i++) {
        if (a[i] != null && a[i] != s.questions[i].correctIndex) w++;
      }
    }
    return w;
  }

  int get score => correctCount;

  // ============================================================
  // REVIEW MODE
  // ============================================================
  void startReview() {
    _reviewMode = true;
    _wrongItems.clear();
    _reviewIndex = 0;

    for (final s in subjects) {
      final a = _answers[s.id] ?? {};
      for (int i = 0; i < s.questions.length; i++) {
        if (a[i] != null && a[i] != s.questions[i].correctIndex) {
          _wrongItems.add(
            _WrongItem(
              subjectId: s.id,
              questionIndex: i,
              selectedOption: a[i]!,
            ),
          );
        }
      }
    }
    notifyListeners();
  }

  Question get currentReviewQuestion {
    final item = _wrongItems[_reviewIndex];
    final subject = subjects.firstWhere((s) => s.id == item.subjectId);
    return subject.questions[item.questionIndex];
  }

  int? get selectedWrongOption =>
      _wrongItems[_reviewIndex].selectedOption;

  bool get hasPrevReview => _reviewIndex > 0;
  bool get hasNextReview => _reviewIndex < _wrongItems.length - 1;

  void prevReview() {
    if (hasPrevReview) _reviewIndex--;
    notifyListeners();
  }

  void nextReview() {
    if (hasNextReview) _reviewIndex++;
    notifyListeners();
  }

  // ============================================================
  // STORAGE
  // ============================================================
  Future<bool> restoreState() async {
    final data = await ExamStorage.load();
    if (data == null) return false;

    _remainingSeconds = data['remainingSeconds'];
    _currentSubjectIndex = data['currentSubject'];
    _currentQuestionIndex = data['currentQuestion'];
    _submitted = data['submitted'];

    _answers.clear();
    (data['answers'] as Map).forEach(
      (k, v) => _answers[k] = Map<int, int>.from(v),
    );

    startTimer();
    notifyListeners();
    return true;
  }

  Future<void> clearSavedExam() async {
    await ExamStorage.clear();
  }

  void _autoSave() {
    if (!_submitted) {
      ExamStorage.save({
        'remainingSeconds': _remainingSeconds,
        'currentSubject': _currentSubjectIndex,
        'currentQuestion': _currentQuestionIndex,
        'answers': _answers,
        'submitted': _submitted,
      });
    }
  }
}

// ============================================================
// REVIEW HELPER
// ============================================================
class _WrongItem {
  final String subjectId;
  final int questionIndex;
  final int selectedOption;

  _WrongItem({
    required this.subjectId,
    required this.questionIndex,
    required this.selectedOption,
  });
}
