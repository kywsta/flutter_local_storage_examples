import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabaseHelper {
  static Database? _database;
  static const String _tableName = 'notes';

  // Singleton pattern
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // CRUD Operations
  static Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert(_tableName, note);
  }

  static Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query(_tableName, orderBy: 'createdAt DESC');
  }

  static Future<int> updateNote(int id, Map<String, dynamic> note) async {
    final db = await database;
    return await db.update(_tableName, note, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
