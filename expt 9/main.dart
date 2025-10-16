import 'package:flutter/material.dart';
// This line fixes the error by telling the app where to find CalculatorPage.
import 'package:calc_with_history/calculator_page.dart';

void main() {
  // This is required to ensure plugins are initialized before the app runs.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator with History',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // This now works correctly because of the import above.
      home: const CalculatorPage(),
    );
  }
}