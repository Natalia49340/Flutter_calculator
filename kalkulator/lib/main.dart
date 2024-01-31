import 'package:flutter/material.dart';
import 'package:kalkulator/buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'historyscreen.dart';
import 'converter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: [
              MyHomePage(title: 'Kalkulator'),
              ConverterScreen(),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 80,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.calculate), text: 'Kalkulator'),
                Tab(icon: Icon(Icons.compare_arrows), text: 'Konwerter'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '';
  bool isMathFunctionPanelVisible = false;

  List<String> historyEquations = [];
  List<String> historyResults = [];
  int openParenthesesCount = 0;

  void clearPressed() {
    setState(() {
      userQuestion = '';
      userAnswer = '';
      openParenthesesCount = 0;
    });
  }

  final List<String> buttons = [
    'C',
    '/',
    '( )',
    '⌫',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    ',',
    '0',
    '%',
    '=',
  ];

  List<String> mathFunctions = ['√', '³√', 'x²', 'x^y', '!', '|x|'];
  bool isLastCharacterOpenParenthesis() {
    if (userQuestion.isNotEmpty) {
      return userQuestion.characters.last == '(';
    }
    return false;
  }

  bool isLastCharacterCloseParenthesis() {
    if (userQuestion.isNotEmpty) {
      return userQuestion.characters.last == ')';
    }
    return false;
  }

  void parenthesesPressed() {
    setState(() {
      if (userQuestion.isEmpty || isLastCharacterOpenParenthesis()) {
        userQuestion += '(';
        openParenthesesCount++;
      } else if (openParenthesesCount > 0 &&
          !isLastCharacterCloseParenthesis()) {
        userQuestion += ')';
        openParenthesesCount--;
      }
    });
  }

  void mathFunctionPressed(String function) {
    setState(() {
      if (function == '√') {
        userQuestion += 'sqrt(';
      } else if (function == 'x²') {
        userQuestion += '^2';
      } else if (function == 'x^y') {
        userQuestion += '^';
      } else if (function == '³√') {
        userQuestion += '^(1/3)';
      } else if (function == '!') {
        userQuestion += '!';
      } else if (function == '|x|') {
        userQuestion += 'abs(';
        openParenthesesCount++;
      }
    });
  }

  Widget buildMathFunctionsPanel() {
    return GridView.builder(
      itemCount: mathFunctions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return MyButton(
          buttonTapped: () {
            mathFunctionPressed(mathFunctions[index]);
          },
          buttonText: mathFunctions[index],
          color: Color.fromARGB(255, 46, 7, 108),
          textColor: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 192, 175, 219),
      body: Padding(
        padding: EdgeInsets.only(top: 22.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(
                      historyEquations: historyEquations,
                      historyResults: historyResults,
                    ),
                  ),
                );
              },
              child: Text('Historia'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isMathFunctionPanelVisible = !isMathFunctionPanelVisible;
                });
              },
              child: Text('Funkcje Matematyczne'),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 43,
                ),
                Text(
                  userQuestion,
                  style: TextStyle(fontSize: 29),
                  textAlign: TextAlign.left,
                ),
                Text(
                  userAnswer,
                  style: TextStyle(fontSize: 32),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: isMathFunctionPanelVisible
                    ? buildMathFunctionsPanel()
                    : GridView.builder(
                        itemCount: buttons.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return MyButton(
                              buttonTapped: () {
                                clearPressed();
                              },
                              buttonText: buttons[index],
                              color: Colors.deepPurple,
                              textColor: Colors.white,
                            );
                          } else if (index == 19) {
                            return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  equalPressed(context);
                                });
                              },
                              buttonText: buttons[index],
                              color: isOperator(buttons[index])
                                  ? Color.fromARGB(255, 46, 7, 108)
                                  : Colors.white,
                              textColor: Colors.white,
                            );
                          } else if (index == 3) {
                            return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  if (userQuestion.isNotEmpty) {
                                    userQuestion = userQuestion.substring(
                                        0, userQuestion.length - 1);
                                  }
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.white,
                              textColor: Colors.black,
                            );
                          } else if (index == 2) {
                            return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  parenthesesPressed();
                                });
                              },
                              buttonText: buttons[index],
                              color: isOperator(buttons[index])
                                  ? Color.fromARGB(255, 150, 69, 221)
                                  : Colors.white,
                              textColor: isOperator(buttons[index])
                                  ? Colors.white
                                  : Colors.deepPurple,
                            );
                          } else if (index == buttons.length - 1) {
                            return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  equalPressed(context);
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.deepPurple,
                              textColor: Colors.black,
                            );
                          } else if (index == buttons.length - 2) {
                            return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  if (!userQuestion.contains(',')) {
                                    userQuestion =
                                        userQuestion + buttons[index];
                                  }
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.white,
                              textColor: Colors.deepPurple,
                            );
                          } else {
                            return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  userQuestion = userQuestion + buttons[index];
                                });
                              },
                              buttonText: buttons[index],
                              color: isOperator(buttons[index])
                                  ? Color.fromARGB(255, 150, 69, 221)
                                  : Colors.white,
                              textColor: isOperator(buttons[index])
                                  ? Colors.white
                                  : Colors.deepPurple,
                            );
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '%' ||
        x == '/' ||
        x == 'x' ||
        x == '-' ||
        x == '+' ||
        x == '=' ||
        x == '( )' ||
        x == ',') {
      return true;
    }
    return false;
  }

  void equalPressed(BuildContext context) {
    try {
      
      String finalQuestion = userQuestion;
      finalQuestion = finalQuestion.replaceAll('x', '*');
      finalQuestion = finalQuestion.replaceAll('%', '/100');
      finalQuestion = finalQuestion.replaceAll(',', '.');

      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      userAnswer = eval.toStringAsFixed(2);
      userAnswer = userAnswer.replaceAll('.', ',');
      addToHistory(finalQuestion, userAnswer);

      while (openParenthesesCount > 0 || openParenthesesCount < 0) {
        userQuestion += ')';
        openParenthesesCount--;
      }

      setState(() {
        userAnswer = userAnswer.replaceAll('.', ',');
      });
      
    } catch (error) {
      
      print("Wystąpił błąd: $error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Błąd'),
            content: Text(
                'Wystąpił błąd podczas przetwarzania równania. Sprawdź poprawność wprowadzonych danych.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void addToHistory(String equation, String result) {
    setState(() {
      historyEquations.insert(0, equation);
      historyResults.insert(0, result);
    });
  }
}
