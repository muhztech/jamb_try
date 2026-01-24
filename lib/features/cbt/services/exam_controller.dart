import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';

class ExamController extends ChangeNotifier {
  final List<Question> _questions = List.generate(
    40,
    (index) => Question(
      question: 'Sample Question ${index + 1}: What is 2 + 3?',
      options: ['1', '3', '4', '5'],
      correctIndex: 3,
      explanation: '2 + 3 = 5',
    ),
  );

  int _currentIndex = 0;
  int? _selectedOption;

  static const int _examDuration = 60 * 40; // 40 mins
  int _remainingSeconds = _examDuration;

  int _correct = 0;
  int _wrong = 0;
  bool _submitted = false;

  Timer? _timer;

  // ================= GETTERS =================

  int get currentIndex => _currentIndex;
  int? get selectedOption => _selectedOption;
  int get totalQuestions => _questions.length;
  int get correctCount => _correct;
  int get wrongCount => _wrong;
  bool get isSubmitted => _submitted;

  Question get currentQuestion => _questions[_currentIndex];

  String get formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  int get score => (_correct * 400 / totalQuestions).round();

  String get timeUsed {
    final used = _examDuration - _remainingSeconds;
    final m = used ~/ 60;
    final s = used % 60;
    return '${m}m ${s}s';
  }

  // ================= TIMER =================

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0 && !_submitted) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        submitExam();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  // ================= CBT LOGIC =================

  void selectOption(int index) {
    _selectedOption = index;
    notifyListeners();
  }

  void submitAnswer() {
    if (_selectedOption == currentQuestion.correctIndex) {
      _correct++;
    } else {
      _wrong++;
    }
  }

  void nextQuestion() {
    _selectedOption = null;
    if (_currentIndex < totalQuestions - 1) {
      _currentIndex++;
    } else {
      submitExam();
    }
    notifyListeners();
  }

  void jumpTo(int index) {
    _currentIndex = index;
    _selectedOption = null;
    notifyListeners();
  }

  void submitExam() {
    if (_submitted) return;
    _submitted = true;
    stopTimer();
    notifyListeners();
  }

  void resetExam() {
    stopTimer();
    _currentIndex = 0;
    _selectedOption = null;
    _remainingSeconds = _examDuration;
    _correct = 0;
    _wrong = 0;
    _submitted = false;
    startTimer();
    notifyListeners();
  }

  // ================= LIFECYCLE =================

  ExamController() {
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
