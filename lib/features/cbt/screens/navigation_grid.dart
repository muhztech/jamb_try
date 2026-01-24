import 'package:flutter/material.dart';

class QuestionNavigationGrid extends StatelessWidget {
  final int current;
  final int total;
  final Function(int) onTap;

  const QuestionNavigationGrid({
    super.key,
    required this.current,
    required this.total,
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
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: index == current ? Colors.green : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
