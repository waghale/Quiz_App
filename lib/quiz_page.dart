import 'package:flutter/material.dart';
import 'package:quiz_app/quiz_service.dart';
import 'package:quiz_app/summary_page.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<dynamic> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final data = await QuizService().fetchQuizData().timeout(Duration(seconds: 10));
      if (data != null ) {
        setState(() {
          questions = data; // Access the 'questions' field
          isLoading = false;
        });
      } else {
        throw Exception('Invalid API response structure.');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void nextQuestion(bool isCorrect) {
    if (isCorrect) score++;
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryPage(score: score),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading questions, please wait...'),
            ],
          ),
        ),
      );
    }

    if (hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 20),
              Text(
                'Failed to load questions.\nPlease check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchQuestions,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentIndex];
    final options = question['options']; // Access the options for the current question

    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentIndex + 1} of ${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              question['description'], // Access the question text
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => nextQuestion(option['is_correct']),
                  child: Text(option['description']), // Access the option text
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
