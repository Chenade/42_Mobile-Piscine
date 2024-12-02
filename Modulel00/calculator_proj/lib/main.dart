import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = '';
  String result = '';

  void handleButtonPress(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        expression = '';
        result = '';
      } else if (buttonText == 'C') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (buttonText == '=') {
        try {
          result = evaluateExpression(expression);
        } catch (e) {
          result = 'Error';
        }
      } else {
        expression += buttonText;
      }
    });
  }

  String evaluateExpression(String expression) {
    String evalResult = 'Error';
    try {
      evalResult = eval(expression).toString();
    } catch (e) {
      print('Error evaluating expression: $e');
    }
    return evalResult;
  }

  double eval(String expression) {
  expression = expression.replaceAll('−', '-');
  expression = expression.replaceAll('--', '-');
  expression = expression.replaceAll('%', '/');
  expression = expression.replaceAll('x', '*');

  List<String> tokens = tokenizeExpression(expression);

  if (tokens[0] == '-') {
    tokens[1] = '-' + tokens[1];
    tokens.removeAt(0);
  }

  for (int i = 1; i < tokens.length; i += 2) {
    if (tokens[i] == '*') {
      double left = double.parse(tokens[i - 1]);
      double right = double.parse(tokens[i + 1]);
      double result = left * right;
      tokens.replaceRange(i - 1, i + 2, [result.toString()]);
      i -= 2;
    } else if (tokens[i] == '/') {
      double left = double.parse(tokens[i - 1]);
      double right = double.parse(tokens[i + 1]);
      if (right == 0) {
        throw const FormatException('Division by zero');
      }
      double result = left / right;

      tokens.replaceRange(i - 1, i + 2, [result.toString()]);
      i -= 2; 
    }
  }

  double result = double.parse(tokens[0]);
  for (int i = 1; i < tokens.length; i += 2) {
    if (tokens[i] == '+') {
      double operand = double.parse(tokens[i + 1]);
      result += operand;
    } else if (tokens[i] == '-') {
      double operand = double.parse(tokens[i + 1]);
      result -= operand;
    }
  }

  return result;
}

List<String> tokenizeExpression(String expression) {
  RegExp regExp = RegExp(r'[+\-*/()]|\d+\.?\d*');
  Iterable<RegExpMatch> matches = regExp.allMatches(expression);

  List<String> tokens = [];
  for (RegExpMatch match in matches) {
    tokens.add(match.group(0)!);
  }

  List<String> combinedTokens = [];
  for (int i = 0; i < tokens.length; i++) {
    if (tokens[i] == '-') {
      if (i == 0 || isOperator(tokens[i - 1])) {
        combinedTokens.add(tokens[i] + tokens[i + 1]);
        i++;
      } else {
        combinedTokens.add(tokens[i]);
      }
    } else {
      combinedTokens.add(tokens[i]);
    }
  }

  return combinedTokens;
}

bool isOperator(String token) {
  return ['+', '-', '*', '/'].contains(token);
}



  Widget buildButton(String buttonText) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          handleButtonPress(buttonText);
        },
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[300],
              alignment: Alignment.bottomRight,
              child: Text(
                expression.isEmpty ? '0' : expression,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              alignment: Alignment.bottomRight,
              child: Text(
                result.isEmpty ? '0' : result,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildButton('7'),
                      buildButton('8'),
                      buildButton('9'),
                      buildButton('%'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildButton('4'),
                      buildButton('5'),
                      buildButton('6'),
                      buildButton('x'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildButton('1'),
                      buildButton('2'),
                      buildButton('3'),
                      buildButton('-'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildButton('0'),
                      buildButton('.'),
                      buildButton('AC'),
                      buildButton('+'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildButton('C'),
                      buildButton('='),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
