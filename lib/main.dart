import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> _questions = [
    {'question': '5 + 3 = ?', 'options': [7, 8, 9], 'answer': 8},
    {'question': '2 * 2 = ?', 'options': [2, 4, 6], 'answer': 4},
    {'question': '9 - 3 = ?', 'options': [6, 5, 4], 'answer': 6},
    {'question': '6 / 2 = ?', 'options': [2, 3, 4], 'answer': 3},
    {'question': '7 + 5 = ?', 'options': [11, 12, 13], 'answer': 12},
    {'question': '10 - 7 = ?', 'options': [1, 2, 3], 'answer': 3},
    {'question': '4 * 3 = ?', 'options': [10, 11, 12], 'answer': 12},
    {'question': '15 / 5 = ?', 'options': [2, 3, 5], 'answer': 3},
    {'question': '8 + 1 = ?', 'options': [8, 9, 10], 'answer': 9},
    {'question': '3 * 3 = ?', 'options': [6, 7, 9], 'answer': 9},
  ];

  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedOption;

  void _checkAnswer(int selectedOption) {
    setState(() {
      _selectedOption = selectedOption;
      if (selectedOption == _questions[_currentQuestion]['answer']) {
        _score += 2;
      }

      // Delay to allow the user to see the feedback before moving to the next question
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (_currentQuestion < _questions.length - 1) {
            _currentQuestion++;
            _selectedOption = null; // Reset selected option for the next question
          } else {
            _showResult();
          }
        });
      });
    });
  }

  void _showResult() {
    String resultMessage = _score >= 10 ? 'Pass' : 'Fail';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text(
          'Your score is $_score.\nYou $resultMessage!',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestion = 0;
                _score = 0;
                _selectedOption = null;
              });
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math QuizApp'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to the Quiz World',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Question ${_currentQuestion + 1}/${_questions.length}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _questions[_currentQuestion]['question'] as String,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 20),
            ...(_questions[_currentQuestion]['options'] as List<int>).map((option) {
              Color? optionColor;
              if (_selectedOption != null) {
                if (option == _questions[_currentQuestion]['answer']) {
                  optionColor = Colors.green;
                } else if (option == _selectedOption) {
                  optionColor = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: _selectedOption == null
                      ? () => _checkAnswer(option)
                      : null, // Disable button after selection
                  style: ElevatedButton.styleFrom(
                    backgroundColor: optionColor ?? Colors.white,
                    foregroundColor: optionColor == null ? Colors.black : Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.grey.shade400,
                    elevation: 6,
                  ),
                  child: Text(
                    option.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
