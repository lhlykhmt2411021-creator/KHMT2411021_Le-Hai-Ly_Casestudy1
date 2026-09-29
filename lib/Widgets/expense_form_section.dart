import 'package:flutter/material.dart';
import '../Models/expense.dart';

/// Chỉ chứa PHẦN NỘI DUNG form nhập liệu (không có Scaffold/AppBar) —
/// được nhúng vào bên trong ExpenseFormScreen.
/// Dùng CHUNG cho cả "Thêm giao dịch" và "Sửa giao dịch":
/// - initial == null  -> chế độ Thêm (các trường để trống)
/// - initial != null  -> chế độ Sửa (điền sẵn dữ liệu cũ)
class ExpenseFormSection extends StatefulWidget {
  final Expense? initial;
  final void Function(Expense expense) onSave;

  const ExpenseFormSection({
    super.key,
    required this.initial,
    required this.onSave,
  });

  @override
  State<ExpenseFormSection> createState() => _ExpenseFormSectionState();
}

class _ExpenseFormSectionState extends State<ExpenseFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();

  late String _selectedCategory;
  late DateTime _selectedDate;

  // Toggle Chi tiêu / Thu nhập: chỉ đổi giao diện, CHƯA lưu vào Expense
  // (giữ đúng model gốc tài liệu: id/title/amount/category/date).
  bool _isExpenseType = true;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _selectedCategory = initial?.category ?? expenseCategories.first;
    _selectedDate = initial?.date ?? DateTime.now();

    if (initial != null) {
      _amountController.text = initial.amount.toStringAsFixed(0);
      _noteController.text = initial.note;
    }
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final expense = Expense(
      id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _selectedCategory, // dùng Danh mục làm title mặc định
      amount: double.tryParse(_amountController.text) ?? 0,
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text,
    );

    widget.onSave(expense);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      label: 'Chi tiêu',
                      selected: _isExpenseType,
                      color: Colors.red,
                      onTap: () => setState(() => _isExpenseType = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton(
                      label: 'Thu nhập',
                      selected: !_isExpenseType,
                      color: Colors.green,
                      onTap: () => setState(() => _isExpenseType = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: expenseCategories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              const SizedBox(height: 20),

              const Text('Số tiền', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  suffixText: 'đ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Số tiền không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text('Ngày giao dịch', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),

              const Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Nhập ghi chú (tùy chọn)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Lưu', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}