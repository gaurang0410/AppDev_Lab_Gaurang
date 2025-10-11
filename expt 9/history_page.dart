import 'package:flutter/material.dart';
import 'calculator_logic.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: CalculatorLogic.loadHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final history = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('History')),
          body: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(history[index]),
              );
            },
          ),
        );
      },
    );
  }
}