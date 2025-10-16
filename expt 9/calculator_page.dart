import 'package:flutter/material.dart';
import 'package:calc_with_history/db_helper.dart';
import 'package:calc_with_history/history_page.dart';
import 'package:calc_with_history/calc_model.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = '0';
  String _expression = '';

  // Correctly create instances of the classes using ()
  final dbHelper = DatabaseHelper();
  final calculatorLogic = CalculatorLogic();

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _expression = '';
      } else if (buttonText == '=') {
        String result = calculatorLogic.evaluateExpression(_expression);
        
        if (result != 'Error') {
          dbHelper.addCalculation(_expression, result);
        }
        
        _output = result;
        _expression = result;
      } else {
        if (_expression == '0' || _expression == 'Error') {
          _expression = buttonText;
        } else {
          _expression += buttonText;
        }
        _output = _expression;
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... The rest of your build method remains the same ...
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/')]),
                Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('x')]),
                Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-')]),
                Row(children: [_buildButton('C'), _buildButton('0'), _buildButton('='), _buildButton('+')]),
              ],
            ),
          )
        ],
      ),
    );
  }
}