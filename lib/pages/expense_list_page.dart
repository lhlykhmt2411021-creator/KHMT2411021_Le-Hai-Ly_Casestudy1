import 'package:flutter/material.dart';
import '../Models/expense.dart';
import '../Widgets/expense_list_section.dart';
import 'expense_form_screen.dart';

enum _ExpenseScreenMode { list, form }

/// Trang gốc quản lý toàn bộ khoản chi. Việc chuyển giữa "màn hình danh sách"
/// và "màn hình Thêm/Sửa" chỉ là đổi state (_mode) bằng setState(),
/// KHÔNG dùng Navigator.push (đúng phạm vi Buổi 3 - chưa học Navigation thật).
class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final List<Expense> _expenses = [];
  _ExpenseScreenMode _mode = _ExpenseScreenMode.list;
  Expense? _editingExpense;

  void _openAddForm() {
    setState(() {
      _editingExpense = null;
      _mode = _ExpenseScreenMode.form;
    });
  }

  void _openEditForm(Expense expense) {
    setState(() {
      _editingExpense = expense;
      _mode = _ExpenseScreenMode.form;
    });
  }

  void _closeForm() {
    setState(() {
      _mode = _ExpenseScreenMode.list;
      _editingExpense = null;
    });
  }

  void _saveExpense(Expense expense) {
    setState(() {
      if (_editingExpense == null) {
        _expenses.add(expense);
      } else {
        final index = _expenses.indexWhere((e) => e.id == _editingExpense!.id);
        if (index != -1) {
          _expenses[index] = expense;
        }
      }
      _mode = _ExpenseScreenMode.list;
      _editingExpense = null;
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == _ExpenseScreenMode.form) {
      return ExpenseFormScreen(
        initial: _editingExpense,
        onSave: _saveExpense,
        onBack: _closeForm,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý chi tiêu')),
      body: SafeArea(
        child: ExpenseListSection(
          expenses: _expenses,
          onEdit: _openEditForm,
          onDelete: _deleteExpense,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}