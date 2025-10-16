# Experiment 2 - Dart Input/Output and Loops

## Aim
To write a Dart program that demonstrates user input/output and different types of loops (`for`, `while`, and `do-while`).

## Software Requirements
- Dart SDK installed
- VS Code (or any editor with Dart support)

## Program (expt2.dart)
```dart
import 'dart:io';

void main() {
  // Input
  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();

  stdout.write("Enter a number: ");
  int? num = int.parse(stdin.readLineSync()!);

  // For loop example
  print("\nHello, $name! Numbers from 1 to $num:");
  for (int i = 1; i <= num; i++) {
    print(i);
  }

  // While loop example
  print("\nCountdown using while loop:");
  int j = num;
  while (j > 0) {
    print(j);
    j--;
  }

  // Do-while loop example
  print("\nDo-while loop prints at least once:");
  int k = 0;
  do {
    print("This is iteration $k");
    k++;
  } while (k < 3);
}
