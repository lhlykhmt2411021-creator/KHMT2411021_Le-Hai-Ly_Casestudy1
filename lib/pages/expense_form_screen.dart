import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../widgets/expense_form_section.dart';

class ExpenseFormScreen extends StatelessWidget {
  final Transaction? initial;
  final TransactionRepository? repository;
  final Future<void> Function(Transaction transaction)? onSave;

  const ExpenseFormScreen({
    super.key,
    this.initial,
    this.repository,
    this.onSave,
  });

  Future<void> _save(BuildContext context, Transaction transaction) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      if (onSave != null) {
        await onSave!(transaction);
      } else {
        final repo = repository ?? TransactionRepository();
        if (initial == null) {
          await repo.insertTransaction(transaction);
        } else {
          await repo.updateTransaction(transaction);
        }
      }

      navigator.pop(true);
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Không thể lưu giao dịch: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
