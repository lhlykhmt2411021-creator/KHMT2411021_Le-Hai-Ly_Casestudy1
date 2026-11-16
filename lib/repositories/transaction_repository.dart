import '../database/database_helper.dart';
import '../models/transaction.dart';

/// Tầng trung gian giữa UI và SQLite.
/// UI chỉ làm việc với Transaction, không cần biết câu lệnh SQL.
class TransactionRepository {
  final DatabaseHelper _dbHelper;

  TransactionRepository({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<int> insertTransaction(Transaction transaction) {
    return _dbHelper.insertTransaction(transaction);
  }

  Future<List<Transaction>> getAllTransactions() {
    return _dbHelper.getTransactions();
  }

  Future<List<Transaction>> getRecentTransactions({int limit = 5}) async {
    final all = await _dbHelper.getTransactions();
    return all.take(limit).toList();
  }

  Future<List<Transaction>> searchTransactions(String keyword) {
    return _dbHelper.searchTransactions(keyword);
  }

  Future<List<Transaction>> getTransactionsByType(String type) {
    return _dbHelper.getTransactionsByType(type);
  }

  Future<int> updateTransaction(Transaction transaction) {
    return _dbHelper.updateTransaction(transaction);
  }

  Future<int> deleteTransaction(int id) {
    return _dbHelper.deleteTransaction(id);
  }
}
