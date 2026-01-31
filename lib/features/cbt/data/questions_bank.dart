import '../models/question.dart';
import '../models/subject.dart';

final Map<UtmeSubject, List<Question>> questionsBank = {
  UtmeSubject.mathematics: [
    Question(
      question: "2 + 2 = ?",
      options: ["1", "2", "3", "4"],
      correctIndex: 3,
      explanation: "2 + 2 equals 4",
    ),
  ],

  UtmeSubject.english: [
    Question(
      question: "Choose the correct spelling",
      options: ["Recieve", "Receive", "Receeve", "Receve"],
      correctIndex: 1,
      explanation: "Receive is correct",
    ),
  ],

  UtmeSubject.physics: [
    Question(
      question: "Unit of force?",
      options: ["Joule", "Newton", "Watt", "Pascal"],
      correctIndex: 1,
      explanation: "Force is measured in Newton",
    ),
  ],

  UtmeSubject.chemistry: [
    Question(
      question: "H₂O is?",
      options: ["Oxygen", "Hydrogen", "Water", "Salt"],
      correctIndex: 2,
      explanation: "H₂O is water",
    ),
  ],
};
