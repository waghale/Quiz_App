import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuizDatabase {
  static final QuizDatabase instance = QuizDatabase._init();
  static Database? _database;

  QuizDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const quizTable = '''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        score INTEGER,
        date TEXT
      )
    ''';
    await db.execute(quizTable);
  }

  Future<int> insertResult(int score) async {
    final db = await instance.database;
    return await db.insert('quiz_results', {
      'score': score,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchResults() async {
    final db = await instance.database;
    return await db.query('quiz_results');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
