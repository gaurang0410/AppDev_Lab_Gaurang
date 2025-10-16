import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'todo_model.dart';

class TodoPage extends StatefulWidget {
  final VoidCallback onTaskUpdated;
  const TodoPage({Key? key, required this.onTaskUpdated}) : super(key: key);

  @override
  // Make the state class public so main.dart can access its methods via the GlobalKey
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  final TextEditingController _textController = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    refreshTodoList();
  }

  // Public method to be called from the parent widget
  Future<void> refreshTodoList() async {
    final data = await DBHelper.instance.getTodos();
    setState(() {
      // Filter to only show tasks that are NOT done
      _todos = data.where((todo) => !todo.isDone).toList();
    });
  }

  Future<void> _addTodo() async {
    if (_textController.text.trim().isEmpty) return;
    final newTodo = Todo(title: _textController.text);
    await DBHelper.instance.addTodo(newTodo);
    _textController.clear();
    widget.onTaskUpdated(); // Notify parent to refresh all pages
  }

  Future<void> _updateTodoStatus(Todo todo, bool isDone) async {
    final updatedTodo = Todo(id: todo.id, title: todo.title, isDone: isDone);
    await DBHelper.instance.updateTodo(updatedTodo);
    widget.onTaskUpdated(); // Notify parent to refresh all pages
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Tasks'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new task...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 40),
                  color: Colors.indigo,
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
          Expanded(
            child: _todos.isEmpty
                ? const Center(child: Text("No active tasks. Good job!"))
                : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
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
                    title: Text(todo.title),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}