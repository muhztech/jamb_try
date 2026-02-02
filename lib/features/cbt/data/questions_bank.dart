import '../models/question.dart';
import '../models/subject.dart';

final Map<Subject, List<Question>> questionsBank = {
  Subject.english: [
    Question(
      id: "eng_1",
      question: "Choose the word that best completes the sentence:\nHe was accused ___ cheating in the examination.",
      options: [
        "with",
        "of",
        "for",
        "on",
      ],
      correctIndex: 1,
    ),
    Question(
      id: "eng_2",
      question: "Choose the option nearest in meaning to the underlined word:\nShe spoke in a *harsh* tone.",
      options: [
        "Soft",
        "Gentle",
        "Rough",
        "Calm",
      ],
      correctIndex: 2,
    ),
  ],

  Subject.mathematics: [
    Question(
      id: "math_1",
      question: "What is the value of 3² + 4²?",
      options: [
        "7",
        "12",
        "25",
        "49",
      ],
      correctIndex: 2,
    ),
    Question(
      id: "math_2",
      question: "Solve: 5x = 20",
      options: [
        "2",
        "4",
        "5",
        "10",
      ],
      correctIndex: 1,
    ),
  ],

  Subject.biology: [
    Question(
      id: "bio_1",
      question: "Which of the following is the basic unit of life?",
      options: [
        "Tissue",
        "Cell",
        "Organ",
        "System",
      ],
      correctIndex: 1,
    ),
    Question(
      id: "bio_2",
      question: "Photosynthesis occurs mainly in the:",
      options: [
        "Root",
        "Stem",
        "Leaf",
        "Flower",
      ],
      correctIndex: 2,
    ),
  ],

  Subject.government: [
    Question(
      id: "gov_1",
      question: "The primary duty of the legislature is to:",
      options: [
        "Interpret laws",
        "Make laws",
        "Execute laws",
        "Enforce laws",
      ],
      correctIndex: 1,
    ),
    Question(
      id: "gov_2",
      question: "Nigeria operates which system of government?",
      options: [
        "Monarchy",
        "Military",
        "Presidential",
        "Confederal",
      ],
      correctIndex: 2,
    ),
  ],
};
