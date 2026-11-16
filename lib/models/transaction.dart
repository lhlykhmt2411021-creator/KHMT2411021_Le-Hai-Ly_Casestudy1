/// Model giao dịch dùng với SQLite.
/// Tên trường trùng tên cột trong bảng `transactions`.
///
/// type : 'expense' (chi tiêu) hoặc 'income' (thu nhập)
/// date : chuỗi ISO yyyy-MM-dd, ví dụ '2026-09-26'
class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String date;
  final String category;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  bool get isIncome => type == 'income';

  bool get isExpense => type == 'expense';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      date: map['date'] as String,
      category: map['category'] as String,
    );
  }

  Transaction copyWith({
    int? id,
    String? title,
    double? amount,
    String? type,
    String? date,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, '
        'type: $type, date: $date, category: $category)';
  }
}
