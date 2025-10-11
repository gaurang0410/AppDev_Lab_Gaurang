import 'package:flutter/material.dart';
import 'calculator_logic.dart';
import 'history_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';
  List<String> _history = [];

  final List<String> buttons = [
    'C', '', '', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=', '',
  ];

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = CalculatorLogic.evaluate(_expression);
          _history.add('$_expression = $_result');
          CalculatorLogic.saveHistory(_history);
        } catch (e) {
          _result = 'Error';
        }
      } else if (value.isNotEmpty) {
        _expression += value;
      }
    });
  }

  void _openHistory() async {
    final history = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    );
    if (history != null) {
      setState(() {
        _history = history;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    CalculatorLogic.loadHistory().then((value) {
      setState(() {
        _history = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            height: 120, // smaller display area
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_expression,
                    style: const TextStyle(fontSize: 32, color: Colors.white)),
                const SizedBox(height: 8),
                Text(_result,
                    style: const TextStyle(fontSize: 20, color: Colors.grey)),
              ],
            ),
          ),
          const Divider(color: Colors.white),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 4,   // tighter spacing
                crossAxisSpacing: 4,
                childAspectRatio: 1.4, // makes boxes narrower and shorter
                children: buttons.map((value) {
                  final isOperator = ['/', '*', '-', '+', '='].contains(value);
                  final isClear = value == 'C';

                  return ElevatedButton(
                    onPressed: value.isNotEmpty ? () => _onPressed(value) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOperator
                          ? Colors.blue
                          : isClear
                              ? Colors.red
                              : Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2), // less padding
                      minimumSize: const Size(50, 50), // force smaller button size
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16, // smaller text
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openHistory,
        label: const Text('History'),
        icon: const Icon(Icons.history),
        backgroundColor: Colors.orange,
      ),
    );
  }
}