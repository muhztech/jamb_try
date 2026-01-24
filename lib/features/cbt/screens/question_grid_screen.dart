import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/exam_controller.dart';

class QuestionGridScreen extends StatelessWidget {
  const QuestionGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exam = context.watch<ExamController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Question Navigation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: exam.questions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final isCurrent = index == exam.currentIndex;
            final isAnswered = exam.isAnswered(index);

            Color bgColor;
            if (isCurrent) {
              bgColor = Colors.blue;
            } else if (isAnswered) {
              bgColor = Colors.green;
            } else {
              bgColor = Colors.grey.shade300;
            }

            return GestureDetector(
              onTap: () {
                exam.goToQuestion(index);
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrent || isAnswered
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
