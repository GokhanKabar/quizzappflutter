import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzapp/models/quiz_question.dart';


Future<List<QuizQuestion>> loadQuizData() async {
  String jsonString = await rootBundle.loadString('assets/quiz_data.json');
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => QuizQuestion(question: json['question'], answer: json['answer'], id : json['id'])).toList();
}
// initialisation
void main() => runApp(MaterialApp(home: MyApp()));
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  int _current = 1;
  int _score = 0;
  List<QuizQuestion> _quizQuestions = [];

  @override
  void initState() {
    super.initState();
    loadQuizData().then((quizData) {
      setState(() {
        _quizQuestions = quizData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 58, 58, 58)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quizz App Gokhan Kabar'),
          backgroundColor: Color.fromARGB(255, 58, 58, 58),
        ),
        body: _quizQuestions.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(
                   'La Grèce antique',
                    style: TextStyle(fontSize: 28, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                    Text(
                   ' $_current / 10',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _quizQuestions[_currentIndex].question,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _checkAnswer(true);
                        },
                        style: ElevatedButton.styleFrom(// Text Color (Foreground color)
                        primary: Colors.green),
                        child: Text('Vrai'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _checkAnswer(false);
                        },
                          style: ElevatedButton.styleFrom(// Text Color (Foreground color)
                          primary: Colors.red),
                        child: Text('Faux'),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _checkAnswer(bool userAnswer) {
    if (_quizQuestions[_currentIndex].answer == userAnswer) {
      _score++;
    }
    setState(() {
      _currentIndex++;
      _current++;
      if (_currentIndex >= _quizQuestions.length) {
        _showResultDialog();
        _currentIndex--;
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Result'),
          content: Text('Tu as $_score sur ${_quizQuestions.length} de correcte !'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentIndex = 0;
                  _score = 0;
                  _current = 1;
                });
              },
              child: Text('Rejouer'),
            ),
          ],
        );
      },
    );
  }
}