import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_calculator/firestore_service.dart';
import 'package:firebase_calculator/calculation_model.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              // Optional: Add a confirmation dialog before clearing
              _firestoreService.clearHistory();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No history yet.'));
          }

          final calculations = snapshot.data!.docs.map((doc) {
            return Calculation.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: calculations.length,
            itemBuilder: (context, index) {
              final calc = calculations[index];
              final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(calc.timestamp.toDate());

              return ListTile(
                title: Text(calc.expression, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("= ${calc.result}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _firestoreService.deleteCalculation(calc.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}