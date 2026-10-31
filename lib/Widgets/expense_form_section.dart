import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/transaction_model.dart';
import '../utils/transaction_utils.dart';

class ExpenseFormSection extends StatefulWidget {
  final Transaction? initial;
  final void Function(Transaction transaction) onSave;

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

  late bool _isExpenseType;
  late String _selectedCategory;
  late DateTime _selectedDate;

  List<String> get _categories =>
      _isExpenseType ? expenseCategories : incomeCategories;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;

    _isExpenseType = initial == null ? true : !initial.isIncome;
    _selectedDate = initial == null
        ? DateTime.now()
        : (DateTime.tryParse(initial.date) ?? DateTime.now());

    if (initial != null) {
      _amountController.text = initial.amount.toStringAsFixed(0);
      _noteController.text =
      initial.title == initial.category ? '' : initial.title;
      _selectedCategory = _categories.contains(initial.category)
          ? initial.category
          : _categories.first;
    } else {
      _selectedCategory = _categories.first;
    }
    _dateController.text = formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _changeType(bool isExpense) {
    setState(() {
      _isExpenseType = isExpense;
      if (!_categories.contains(_selectedCategory)) {
        _selectedCategory = _categories.first;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatDate(picked);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final note = _noteController.text.trim();

    final transaction = Transaction(
      id: widget.initial?.id,
      title: note.isEmpty ? _selectedCategory : note,
      amount: double.parse(_amountController.text),
      type: _isExpenseType ? 'expense' : 'income',
      date: toIsoDate(_selectedDate),
      category: _selectedCategory,
    );

    widget.onSave(transaction);
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
                      onTap: () => _changeType(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton(
                      label: 'Thu nhập',
                      selected: !_isExpenseType,
                      color: Colors.green,
                      onTap: () => _changeType(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Danh mục',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                key: ValueKey(_isExpenseType),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              const SizedBox(height: 20),
              const Text('Số tiền',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'Nhập số tiền',
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
              const Text('Ngày giao dịch',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              const Text('Ghi chú',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                    backgroundColor: const Color(0xFF1769E0),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
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