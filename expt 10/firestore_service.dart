import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_flutter/todo_model.dart';

class FirestoreService {
  // Get a reference to the 'todos' collection in Firestore
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  // C - Create
  Future<void> addTodo(Todo todo) {
    return _todosCollection.add(todo.toMap());
  }

  // R - Read (as a real-time stream)
  Stream<QuerySnapshot> getActiveTodosStream() {
    // Return a stream of documents where 'status' is 'active'
    return _todosCollection.where('status', isEqualTo: 'active').snapshots();
  }

  Stream<QuerySnapshot> getCompletedTodosStream() {
    // Return a stream of documents where 'status' is 'completed'
    return _todosCollection.where('status', isEqualTo: 'completed').snapshots();
  }

  Stream<QuerySnapshot> getDeletedTodosStream() {
    // Return a stream of documents where 'status' is 'deleted'
    return _todosCollection.where('status', isEqualTo: 'deleted').snapshots();
  }

  // U - Update a todo's status
  Future<void> updateTodoStatus(String id, String newStatus) {
    return _todosCollection.doc(id).update({'status': newStatus});
  }

  // D - Permanently delete a todo from the database
  Future<void> permanentDeleteTodo(String id) {
    return _todosCollection.doc(id).delete();
  }
}