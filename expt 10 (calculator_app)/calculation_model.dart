import 'package:cloud_firestore/cloud_firestore.dart';

class Calculation {
  final String? id;
  final String expression;
  final String result;
  final Timestamp timestamp;

  Calculation({
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  // Convert a Firestore document to a Calculation object
  factory Calculation.fromMap(Map<String, dynamic> map, String id) {
    return Calculation(
      id: id,
      expression: map['expression'] ?? '',
      result: map['result'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert a Calculation object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp,
    };
  }
}