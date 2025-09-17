import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // --- STATE VARIABLES ---
  String output = "0"; // What the user sees
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";

  // --- LOGIC FUNCTION ---
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // Clear everything
        _output = "0";
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/") {
        // Operator pressed
        num1 = double.parse(output);
        operand = buttonText;
        _output = "0";
      } else if (buttonText == ".") {
        // Decimal point pressed
        if (!_output.contains(".")) {
          _output = _output + buttonText;
        }
      } else if (buttonText == "=") {
        // Equals pressed
        num2 = double.parse(output);

        if (operand == "+") {
          _output = (num1 + num2).toString();
        }
        if (operand == "-") {
          _output = (num1 - num2).toString();
        }
        if (operand == "*") {
          _output = (num1 * num2).toString();
        }
        if (operand == "/") {
          // *** ERROR HANDLING for division by zero ***
          if (num2 == 0) {
            _output = "Error";
          } else {
            _output = (num1 / num2).toString();
          }
        }
        
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
      } else {
        // Number pressed
        if (_output == "0" || _output == "Error") {
          _output = buttonText;
        } else {
          _output = _output + buttonText;
        }
      }
    });

    // Clean up trailing .0 if it's a whole number
    if (_output.contains(".") && double.parse(_output) % 1 == 0) {
      output = double.parse(_output).toStringAsFixed(0);
    } else {
      output = _output;
    }
  }

  // --- HELPER FUNCTION TO BUILD BUTTONS ---
  Widget buildButton(String buttonText, {Color color = Colors.black54}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(24.0),
            shape: const CircleBorder(),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          // --- DISPLAY SCREEN ---
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                output,
                style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(),
          // --- BUTTON ROWS ---
          Column(
            children: [
              Row(
                children: [
                  buildButton("C", color: Colors.grey),
                  buildButton("+/-", color: Colors.grey), // Note: +/- and % logic not implemented
                  buildButton("%", color: Colors.grey),
                  buildButton("/", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("*", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("-", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("+", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2, // Takes up twice the space
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () => _buttonPressed("0"),
                        child: const Text("0", style: TextStyle(fontSize: 22.0, color: Colors.white)),
                      ),
                    ),
                  ),
                  buildButton("."),
                  buildButton("=", color: Colors.orange),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}