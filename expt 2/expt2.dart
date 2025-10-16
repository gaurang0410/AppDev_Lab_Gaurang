import 'dart:io';

void main() {
  // Input
  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();

  stdout.write("Enter a number: ");
  int? num = int.parse(stdin.readLineSync()!);

  // Output with for loop
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
