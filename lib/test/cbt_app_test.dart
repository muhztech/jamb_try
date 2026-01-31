import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:jamb_try/features/cbt/screens/cbt_screen.dart';
import 'package:jamb_try/features/cbt/services/exam_controller.dart';

void main() {
  testWidgets('CBT screen loads without crash', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ExamController()..startTimer(),
        child: const MaterialApp(home: CbtScreen()),
      ),
    );

    expect(find.byType(CbtScreen), findsOneWidget);
  });
}
