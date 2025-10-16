import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'todo_model.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          isDone INTEGER NOT NULL
      )
    ''');
  }

  Future<void> addTodo(Todo todo) async {
    Database db = await instance.database;
    await db.insert('todos', todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    Database db = await instance.database;
    var todos = await db.query('todos', orderBy: 'id DESC');
    List<Todo> todoList =
        todos.isNotEmpty ? todos.map((c) => Todo.fromMap(c)).toList() : [];
    return todoList;
  }

  Future<void> updateTodo(Todo todo) async {
    Database db = await instance.database;
    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(int id) async {
    Database db = await instance.database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}