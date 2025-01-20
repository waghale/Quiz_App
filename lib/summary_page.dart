import 'package:flutter/material.dart';
import 'package:quiz_app/quiz_database.dart';


class SummaryPage extends StatelessWidget {
  final int score;

  SummaryPage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Summary')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score'),
            ElevatedButton(
              onPressed: () async {
                await QuizDatabase.instance.insertResult(score);
                Navigator.pop(context);
              },
              child: Text('Save Score'),
            ),
          ],
        ),
      ),
    );
  }
}
