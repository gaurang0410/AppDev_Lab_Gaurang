class Todo {
  final int? id;
  final String title;
  final bool isDone;

  Todo({this.id, required this.title, this.isDone = false});

  // Helper method to convert a Todo object into a Map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0, // SQLite doesn't have a boolean type, so we use 0 and 1
    };
  }

  // Helper method to create a Todo object from a Map from the database.
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}