import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/exam_controller.dart';
import 'cbt_screen.dart';
import 'review_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("UTME Result"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Text(
              "Score: ${controller.score}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text("Correct: ${controller.correctCount}"),
            Text("Wrong: ${controller.wrongCount}"),
            const SizedBox(height: 10),

            Text("Time Used: ${controller.timeUsed}"),
            const SizedBox(height: 20),

            if (controller.wrongCount > 0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.startReview();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReviewScreen()),
                    );
                  },
                  child: const Text("Review Wrong Answers"),
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // ✅ FIX: reset + replace screen to prevent blank
                  controller.resetExam();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CbtScreen()),
                  );
                },
                child: const Text("Retake Exam"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
