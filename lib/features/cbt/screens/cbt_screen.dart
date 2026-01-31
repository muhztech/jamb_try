import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/exam_controller.dart';
import 'explanation_screen.dart';
import 'result_screen.dart';
import '../widgets/question_navigation_grid.dart';
import '../widgets/utme_top_bar.dart';

class CbtScreen extends StatefulWidget {
  const CbtScreen({super.key});

  @override
  State<CbtScreen> createState() => _CbtScreenState();
}

class _CbtScreenState extends State<CbtScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();

    // If exam already submitted
    if (controller.isSubmitted) {
      return const ResultScreen();
    }

    final question = controller.currentQuestion;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Official UTME Top Bar
            const UtmeTopBar(),

            // ✅ SUBJECT SWITCHER TABS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.grey.shade200,
              child: Row(
                children: List.generate(controller.subjects.length, (index) {
                  final subject = controller.subjects[index];
                  final isSelected = index == controller.currentSubjectIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.switchSubject(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          subject.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ✅ Question + Options Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question ${controller.currentIndex + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      question.question,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 15),

                    ...List.generate(question.options.length, (index) {
                      return Card(
                        elevation: 0,
                        color: Colors.grey.shade100,
                        child: RadioListTile<int>(
                          title: Text(question.options[index]),
                          value: index,
                          groupValue: controller.selectedOption,
                          onChanged: (value) {
                            if (value == null) return;
                            controller.selectOption(value);
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // ✅ Question Navigation Grid
                    QuestionNavigationGrid(
                      current: controller.currentIndex,
                      total: controller.totalQuestions,
                      answeredMap: controller.answeredMap,
                      onTap: controller.jumpTo,
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Bottom Buttons
            Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: controller.currentIndex == 0
                          ? null
                          : () => controller.prevQuestion(),
                      child: const Text("Previous"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: controller.selectedOption == null
                          ? null
                          : () {
                              // show explanation if wrong
                              if (controller.selectedOption !=
                                  question.correctIndex) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ExplanationScreen(question: question),
                                  ),
                                );
                              }

                              final isLast = controller.currentIndex ==
                                  controller.totalQuestions - 1;

                              if (isLast) {
                                controller.submitExam();
                              } else {
                                controller.nextQuestion();
                              }
                            },
                      child: Text(
                        controller.currentIndex == controller.totalQuestions - 1
                            ? "Submit"
                            : "Next",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
