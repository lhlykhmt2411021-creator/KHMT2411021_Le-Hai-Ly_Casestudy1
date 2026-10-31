import 'package:flutter/material.dart';
import '../Models/transaction_model.dart';
import '../Widgets/expense_form_section.dart';
import '../database/database_helper.dart';

class ExpenseFormScreen extends StatelessWidget {
  final Transaction? initial;

  const ExpenseFormScreen({super.key, this.initial});

  Future<void> _save(BuildContext context, Transaction transaction) async {
    final navigator = Navigator.of(context);

    if (initial == null) {
      await DatabaseHelper.instance.insertTransaction(transaction);
    } else {
      await DatabaseHelper.instance.updateTransaction(transaction);
    }

    navigator.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = initial != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch'),
      ),
      body: SafeArea(
        child: ExpenseFormSection(
          initial: initial,
          onSave: (transaction) => _save(context, transaction),
        ),
      ),
    );
  }
}