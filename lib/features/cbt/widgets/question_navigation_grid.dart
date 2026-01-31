import 'package:flutter/material.dart';

class QuestionNavigationGrid extends StatelessWidget {
  final int current;
  final int total;
  final Map<int, int?> answeredMap;
  final Function(int) onTap;

  const QuestionNavigationGrid({
    super.key,
    required this.current,
    required this.total,
    required this.answeredMap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: total,
      itemBuilder: (_, index) {
        final isCurrent = index == current;
        final isAnswered = answeredMap.containsKey(index);

        Color bgColor = Colors.grey.shade300;

        if (isCurrent) {
          bgColor = Colors.green;
        } else if (isAnswered) {
          bgColor = Colors.blue;
        }

        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
