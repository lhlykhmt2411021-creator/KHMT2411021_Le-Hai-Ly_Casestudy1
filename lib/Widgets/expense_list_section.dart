import 'package:flutter/material.dart';
import '../Models/expense.dart';

/// Chỉ chứa PHẦN NỘI DUNG danh sách (không có Scaffold/AppBar/FAB) —
/// được nhúng vào bên trong ExpenseListPage.
class ExpenseListSection extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense expense) onEdit;
  final void Function(int index) onDelete;

  const ExpenseListSection({
    super.key,
    required this.expenses,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text('Chưa có khoản chi nào'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ListTile(
          title: Text(expense.title),
          subtitle: Text(expense.category),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${expense.amount.toStringAsFixed(0)} đ'),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(expense),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(index),
              ),
            ],
          ),
        );
      },
    );
  }
}