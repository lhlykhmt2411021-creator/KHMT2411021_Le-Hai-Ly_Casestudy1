class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
  });
}

const List<String> expenseCategories = [
  'Ăn uống',
  'Di chuyển',
  'Mua sắm',
  'Học tập',
  'Khác',
];