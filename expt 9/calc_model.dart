import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  String evaluateExpression(String expression) {
    // Replace UI-friendly 'x' with programming-friendly '*'
    String finalExpression = expression.replaceAll('x', '*');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Format the result to remove '.0' for whole numbers
      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      } else {
        return eval.toString();
      }
    } catch (e) {
      return 'Error';
    }
  }
}