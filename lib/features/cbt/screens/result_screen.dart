import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/exam_controller.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();

    return Scaffold(
      appBar: AppBar(title: const Text('UTME Result')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _resultTile('Score', controller.score.toString()),
            _resultTile('Correct', controller.correctCount.toString()),
            _resultTile('Wrong', controller.wrongCount.toString()),
            _resultTile('Time Used', controller.timeUsed),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.resetExam();
                  Navigator.pop(context);
                },
                child: const Text('Retake Exam'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
