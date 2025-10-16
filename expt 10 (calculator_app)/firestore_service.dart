import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_calculator/calculation_model.dart';

class FirestoreService {
  final CollectionReference _historyCollection =
      FirebaseFirestore.instance.collection('history');

  // Add a new calculation to the history
  Future<void> addCalculation(Calculation calculation) {
    return _historyCollection.add(calculation.toMap());
  }

  // Get a real-time stream of all calculations, ordered by newest first
  Stream<QuerySnapshot> getHistoryStream() {
    return _historyCollection.orderBy('timestamp', descending: true).snapshots();
  }

  // Delete a calculation from the history
  Future<void> deleteCalculation(String id) {
    return _historyCollection.doc(id).delete();
  }
  
  // Clear the entire history
  Future<void> clearHistory() async {
    final snapshot = await _historyCollection.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}