import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'todo_model.dart';

class HistoryPage extends StatefulWidget {
  final VoidCallback onTaskUpdated;
  const HistoryPage({Key? key, required this.onTaskUpdated}) : super(key: key);

  @override
  // Make the state class public
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<Todo> _completedTodos = [];

  @override
  void initState() {
    super.initState();
    refreshHistoryList();
  }

  // Public method to be called from the parent widget
  Future<void> refreshHistoryList() async {
    final data = await DBHelper.instance.getTodos();
    setState(() {
      // Filter to only show tasks that ARE done
      _completedTodos = data.where((todo) => todo.isDone).toList();
    });
  }

  Future<void> _updateTodoStatus(Todo todo, bool isDone) async {
    final updatedTodo = Todo(id: todo.id, title: todo.title, isDone: isDone);
    await DBHelper.instance.updateTodo(updatedTodo);
    widget.onTaskUpdated(); // Notify parent to refresh all pages
  }

  Future<void> _deleteTodo(int id) async {
    await DBHelper.instance.deleteTodo(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permanently deleted a task!')));
    widget.onTaskUpdated(); // Notify parent to refresh all pages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
        backgroundColor: Colors.teal,
      ),
      body: _completedTodos.isEmpty
          ? const Center(child: Text("No tasks completed yet."))
          : ListView.builder(
              itemCount: _completedTodos.length,
              itemBuilder: (context, index) {
                final todo = _completedTodos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (bool? value) {
                        if (value != null) {
                          _updateTodoStatus(todo, value);
                        }
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () => _deleteTodo(todo.id!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}