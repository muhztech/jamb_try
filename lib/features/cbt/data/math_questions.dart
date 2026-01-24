import '../models/question.dart';

final List<Question> mathQuestions = [
  Question(
    id: '1',
    question: 'Solve for x: 2x + 5 = 15',
    options: ['3', '5', '10', '15'],
    correctIndex: 1,
    explanation:
        'Subtract 5 from both sides: 2x = 10. Divide both sides by 2: x = 5.',
  ),
  Question(
    id: '2',
    question: 'What is the square root of 144?',
    options: ['10', '11', '12', '14'],
    correctIndex: 2,
    explanation:
        '12 × 12 = 144, therefore the square root of 144 is 12.',
  ),
];
