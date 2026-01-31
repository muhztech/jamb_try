import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/exam_controller.dart';
import 'cbt_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();

    return Scaffold(
      appBar: AppBar(title: const Text('UTME CBT Simulator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Resume Exam'),
              onPressed: () async {
                final restored = await controller.restoreState();
                if (restored && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CbtScreen()),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('Start New Exam'),
              onPressed: () async {
                await controller.clearSavedExam();
                controller.resetExam();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CbtScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
