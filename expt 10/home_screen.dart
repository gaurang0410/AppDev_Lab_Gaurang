// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_flutter/firestore_service.dart';
import 'package:todo_app_flutter/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0; // 0: Active, 1: History, 2: Trash

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['Active To-Dos', 'History', 'Trash'];
    final List<Stream<QuerySnapshot>> streams = [
      _firestoreService.getActiveTodosStream(),
      _firestoreService.getCompletedTodosStream(),
      _firestoreService.getDeletedTodosStream(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: streams[_selectedIndex],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items here.'));
          }

          final todos = snapshot.data!.docs.map((doc) {
            return Todo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return _buildTodoList(todos);
        },
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddTodoDialog,
              tooltip: 'Add To-Do',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Active'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.delete_outline), label: 'Trash'),
        ],
      ),
    );
  }

  Widget _buildTodoList(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        bool isTrashTab = _selectedIndex == 2;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            // Show a checkbox for active/history, or a restore button for trash
            leading: isTrashTab
                ? IconButton(
                    icon: const Icon(Icons.restore_from_trash, color: Colors.green),
                    onPressed: () {
                      _firestoreService.updateTodoStatus(todo.id!, 'active');
                    },
                  )
                : Checkbox(
                    value: todo.status == 'completed',
                    onChanged: (value) {
                      String newStatus = (value ?? false) ? 'completed' : 'active';
                      _firestoreService.updateTodoStatus(todo.id!, newStatus);
                    },
                  ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.status == 'completed' ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            // Trash icon now moves items to the 'deleted' state
            // or permanently deletes them if already in the trash
            trailing: IconButton(
              icon: Icon(
                isTrashTab ? Icons.delete_forever : Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                if (isTrashTab) {
                  _firestoreService.permanentDeleteTodo(todo.id!);
                } else {
                  _firestoreService.updateTodoStatus(todo.id!, 'deleted');
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddTodoDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New To-Do'),
        content: TextField(controller: textController, autofocus: true, decoration: const InputDecoration(hintText: 'Enter your to-do...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                // New todos are always 'active'
                _firestoreService.addTodo(Todo(title: textController.text, status: 'active'));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}