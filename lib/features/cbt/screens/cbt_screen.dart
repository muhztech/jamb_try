import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/exam_controller.dart';
import 'explanation_screen.dart';
import 'navigation_grid.dart';
import 'result_screen.dart';

class CbtScreen extends StatelessWidget {
  const CbtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();
    final question = controller.currentQuestion;

    if (controller.isSubmitted) {
      return const ResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('JAMB TRY – CBT'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: TimerWidget(),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Q${controller.currentIndex + 1}. ${question.question}',
              style: const TextStyle(fontSize: 18),
            ),
          ),

          ...List.generate(question.options.length, (index) {
            return RadioListTile<int>(
              title: Text(question.options[index]),
              value: index,
              groupValue: controller.selectedOption,
              onChanged: (value) =>
                  controller.selectOption(value!),
            );
          }),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: QuestionNavigationGrid(
              current: controller.currentIndex,
              total: controller.totalQuestions,
              onTap: controller.jumpTo,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.selectedOption == null
                    ? null
                    : () {
                        controller.submitAnswer();
                        if (controller.selectedOption !=
                            question.correctIndex) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExplanationScreen(
                                question: question,
                              ),
                            ),
                          );
                        }
                        controller.nextQuestion();
                      },
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();
    return Text(controller.formattedTime);
  }
}
