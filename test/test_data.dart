import 'package:casestudy1/models/transaction.dart';

String isoDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// Dữ liệu mẫu dùng chung cho widget test (không cần SQLite).
List<Transaction> buildSampleTransactions() {
  final now = DateTime.now();
  final lastMonth = DateTime(now.year, now.month - 1, 15);

  return [
    Transaction(
      id: 1,
      title: 'Ăn trưa',
      amount: 50000,
      type: 'expense',
      date: isoDate(now),
      category: 'Ăn uống',
    ),
    Transaction(
      id: 2,
      title: 'Xăng xe',
      amount: 100000,
      type: 'expense',
      date: isoDate(now),
      category: 'Đi lại',
    ),
    Transaction(
      id: 3,
      title: 'Lương tháng này',
      amount: 8000000,
      type: 'income',
      date: isoDate(now),
      category: 'Lương',
    ),
    Transaction(
      id: 4,
      title: 'Mua sắm tháng trước',
      amount: 300000,
      type: 'expense',
      date: isoDate(lastMonth),
      category: 'Mua sắm',
    ),
  ];
}
