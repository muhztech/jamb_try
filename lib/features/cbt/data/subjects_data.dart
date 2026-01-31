import '../models/subject.dart';
import '../models/question.dart';

final List<Subject> utmeSubjects = [
  Subject(
    id: "eng",
    name: "English",
    questions: [
      Question(
        id: "eng_001",
        question: "Choose the correct spelling:",
        options: ["Accomodate", "Accommodate", "Acommodate", "Acomodate"],
        correctIndex: 1,
        explanation: "The correct spelling is 'Accommodate'.",
      ),
      Question(
        id: "eng_002",
        question: "Select the synonym of 'Happy':",
        options: ["Sad", "Angry", "Joyful", "Weak"],
        correctIndex: 2,
        explanation: "'Joyful' means happy.",
      ),
      Question(
        id: "eng_003",
        question: "Choose the correct sentence:",
        options: [
          "He don't like football",
          "He doesn't likes football",
          "He doesn't like football",
          "He not like football"
        ],
        correctIndex: 2,
        explanation: "Correct grammar: He doesn't like football.",
      ),
    ],
  ),

  Subject(
    id: "math",
    name: "Mathematics",
    questions: [
      Question(
        id: "math_001",
        question: "What is 5 + 7?",
        options: ["10", "11", "12", "13"],
        correctIndex: 2,
        explanation: "5 + 7 = 12",
      ),
      Question(
        id: "math_002",
        question: "Solve: 15 ÷ 3",
        options: ["3", "4", "5", "6"],
        correctIndex: 2,
        explanation: "15 ÷ 3 = 5",
      ),
      Question(
        id: "math_003",
        question: "Simplify: 6 × 4",
        options: ["20", "22", "24", "26"],
        correctIndex: 2,
        explanation: "6 × 4 = 24",
      ),
    ],
  ),

  Subject(
    id: "phy",
    name: "Physics",
    questions: [
      Question(
        id: "phy_001",
        question: "Unit of Force is?",
        options: ["Joule", "Newton", "Watt", "Pascal"],
        correctIndex: 1,
        explanation: "Force is measured in Newton.",
      ),
      Question(
        id: "phy_002",
        question: "Speed = ?",
        options: ["Distance/Time", "Time/Distance", "Mass/Volume", "Force/Area"],
        correctIndex: 0,
        explanation: "Speed = Distance ÷ Time",
      ),
      Question(
        id: "phy_003",
        question: "SI unit of Power is?",
        options: ["Watt", "Joule", "Volt", "Ampere"],
        correctIndex: 0,
        explanation: "Power is measured in Watts.",
      ),
    ],
  ),

  Subject(
    id: "che",
    name: "Chemistry",
    questions: [
      Question(
        id: "che_001",
        question: "H2O is the chemical formula for?",
        options: ["Oxygen", "Hydrogen", "Water", "Salt"],
        correctIndex: 2,
        explanation: "H2O means water.",
      ),
      Question(
        id: "che_002",
        question: "pH value of neutral solution is?",
        options: ["0", "7", "14", "10"],
        correctIndex: 1,
        explanation: "Neutral solution has pH 7.",
      ),
      Question(
        id: "che_003",
        question: "NaCl is commonly known as?",
        options: ["Sugar", "Salt", "Baking Soda", "Lime"],
        correctIndex: 1,
        explanation: "NaCl is table salt.",
      ),
    ],
  ),
];
