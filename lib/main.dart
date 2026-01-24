import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/cbt/screens/cbt_screen.dart';
import 'features/cbt/services/exam_controller.dart';

void main() {
  runApp(const JambTryApp());
}

class JambTryApp extends StatelessWidget {
  const JambTryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const CbtScreen(),
      ),
    );
  }
}
