import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/exam_controller.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();
    final question = controller.currentReviewQuestion;
    final selected = controller.selectedWrongOption;

    return Scaffold(
      appBar: AppBar(title: const Text('Review Failed Questions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...List.generate(question.options.length, (index) {
              Color color = Colors.transparent;

              if (index == question.correctIndex) {
                color = Colors.green.withOpacity(0.2);
              } else if (index == selected) {
                color = Colors.red.withOpacity(0.2);
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: color,
                child: ListTile(
                  title: Text(question.options[index]),
                ),
              );
            }),

            const SizedBox(height: 16),
            Text(
              'Explanation:\n${question.explanation}',
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.hasPrevReview
                        ? controller.prevReview
                        : null,
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.hasNextReview
                        ? controller.nextReview
                        : null,
                    child: const Text('Next'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
