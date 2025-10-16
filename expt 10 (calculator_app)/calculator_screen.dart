import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:firebase_calculator/firestore_service.dart';
import 'package:firebase_calculator/calculation_model.dart';
import 'package:firebase_calculator/history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _expression = '';
  String _output = '0';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _output = '0';
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          String result = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);

          // Save to Firebase
          final calculation = Calculation(
            expression: _expression,
            result: result,
            timestamp: Timestamp.now(),
          );
          _firestoreService.addCalculation(calculation);

          _output = result;
          _expression = result;
        } catch (e) {
          _output = 'Error';
        }
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

  Widget _buildButton(String text, {Color color = Colors.white, Color textColor = Colors.black}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [
                  _buildButton('C', color: Colors.grey.shade300),
                  _buildButton('÷', color: Colors.orange),
                ]),
                Row(children: [
                  _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('×', color: Colors.orange),
                ]),
                Row(children: [
                  _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('-', color: Colors.orange),
                ]),
                Row(children: [
                  _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('+', color: Colors.orange),
                ]),
                Row(children: [
                  _buildButton('0', color: Colors.grey.shade300),
                  _buildButton('.'),
                  _buildButton('=', color: Colors.orange),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}