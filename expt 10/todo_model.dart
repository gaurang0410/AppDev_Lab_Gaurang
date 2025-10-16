// lib/todo_model.dart

class Todo {
  final String? id;
  final String title;
  final String status; // 'active', 'completed', or 'deleted'

  Todo({
    this.id,
    required this.title,
    this.status = 'active', // Default to active
  });

  factory Todo.fromMap(Map<String, dynamic> map, String id) {
    return Todo(
      id: id,
      title: map['title'] ?? '',
      status: map['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'status': status,
    };
  }
}