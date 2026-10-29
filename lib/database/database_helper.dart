import 'package:path/path.dart';
// sqflite cũng có class tên Transaction, nên phải ẩn đi để không trùng
// với model Transaction của project.
import 'package:sqflite/sqflite.dart' hide Transaction;

import '../Models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'expense.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;

    return await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  // READ: mới nhất lên đầu (cùng ngày thì id lớn hơn đứng trước)
  Future<List<Transaction>> getTransactions() async {
    final db = await database;

    final maps = await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );

    return maps.map((map) => Transaction.fromMap(map)).toList();
  }

  // UPDATE
  Future<int> updateTransaction(Transaction transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Không thể cập nhật giao dịch chưa có id');
    }

    final db = await database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // DELETE
  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}