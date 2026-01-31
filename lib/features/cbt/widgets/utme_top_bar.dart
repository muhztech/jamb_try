import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/exam_controller.dart';

class UtmeTopBar extends StatelessWidget {
  const UtmeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExamController>();

    return Container(
      color: Colors.green.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.account_circle, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            "Candidate: DEMO USER",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          Text(
            "Time: ${controller.formattedTime}",
            style: TextStyle(
              color: controller.isWarningTime ? Colors.redAccent : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
