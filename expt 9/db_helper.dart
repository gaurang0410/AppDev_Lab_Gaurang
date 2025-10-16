import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calculator.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expression TEXT NOT NULL,
        result TEXT NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Insert a calculation into the database
  Future<int> addCalculation(String expression, String result) async {
    final db = await database;
    return await db.insert('calculations', {
      'expression': expression,
      'result': result,
    });
  }

  // Retrieve all calculations from the database, newest first
  Future<List<Map<String, dynamic>>> getCalculations() async {
    final db = await database;
    return await db.query('calculations', orderBy: 'timestamp DESC');
  }

  // Clear all history
  Future<int> clearHistory() async {
      final db = await database;
      return await db.delete('calculations');
  }
}