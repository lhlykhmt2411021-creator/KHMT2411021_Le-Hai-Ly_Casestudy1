import 'package:flutter/material.dart';
import '../Models/expense.dart';
import '../Widgets/expense_form_section.dart';

/// "Màn hình" Thêm/Sửa giao dịch — chỉ là lớp Scaffold + AppBar bọc ngoài
/// ExpenseFormSection. Nút back chỉ gọi onBack() (setState ở trang cha),
/// KHÔNG dùng Navigator.pop() (đúng phạm vi Buổi 3 - chưa học Navigation thật).
class ExpenseFormScreen extends StatelessWidget {
  final Expense? initial;
  final void Function(Expense expense) onSave;
  final VoidCallback onBack;

  const ExpenseFormScreen({
    super.key,
    required this.initial,
    required this.onSave,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = initial != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch'),
      ),
      body: SafeArea(
        child: ExpenseFormSection(
          initial: initial,
          onSave: onSave,
        ),
      ),
    );
  }
}