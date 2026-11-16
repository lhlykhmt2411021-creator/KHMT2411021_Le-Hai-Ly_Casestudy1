import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/category_constants.dart';
import '../models/filter_criteria.dart';
import '../models/transaction.dart';
import '../pages/expense_form_screen.dart';
import '../repositories/transaction_repository.dart';
import '../widgets/transaction_item.dart';
import 'filter_screen.dart';

class TransactionListScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final TransactionRepository? repository;
  final Future<void> Function()? onRefresh;

  const TransactionListScreen({
    super.key,
    required this.transactions,
    this.repository,
    this.onRefresh,
  });

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  late List<Transaction> _items;
  String _selectedTypeChip = 'all';
  FilterCriteria? _filterCriteria;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.transactions);
  }

  @override
  void didUpdateWidget(covariant TransactionListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.transactions, widget.transactions)) {
      _items = List.of(widget.transactions);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() {});
    });
  }

  List<Transaction> get _filteredTransactions {
    final query = _searchController.text.trim().toLowerCase();

    return _items.where((transaction) {
      if (query.isNotEmpty) {
        final titleMatch = transaction.title.toLowerCase().contains(query);
        final categoryMatch = transaction.category.toLowerCase().contains(
          query,
        );
        if (!titleMatch && !categoryMatch) return false;
      }

      if (_selectedTypeChip == 'income' && !transaction.isIncome) {
        return false;
      }
      if (_selectedTypeChip == 'expense' && !transaction.isExpense) {
        return false;
      }

      final criteria = _filterCriteria;
      if (criteria != null) {
        if (!criteria.isAllTypes) {
          if (criteria.isIncome &&
              !criteria.isExpense &&
              !transaction.isIncome) {
            return false;
          }
          if (criteria.isExpense &&
              !criteria.isIncome &&
              !transaction.isExpense) {
            return false;
          }
        }

        if (criteria.category != 'Tất cả danh mục') {
          final itemCategory = CategoryConstants.normalizeCategory(
            transaction.category,
          );
          final filterCategory = CategoryConstants.normalizeCategory(
            criteria.category,
          );
          if (itemCategory != filterCategory) return false;
        }

        if (criteria.timeRange != null) {
          final itemDate = DateTime.tryParse(transaction.date);
          if (itemDate != null) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final itemDay = DateTime(
              itemDate.year,
              itemDate.month,
              itemDate.day,
            );

            switch (criteria.timeRange) {
              case 'Hôm nay':
                if (itemDay != today) return false;
                break;
              case '7 ngày qua':
                final sevenDaysAgo = today.subtract(const Duration(days: 7));
                if (itemDay.isBefore(sevenDaysAgo) || itemDay.isAfter(today)) {
                  return false;
                }
                break;
              case 'Tháng này':
                if (itemDate.year != now.year || itemDate.month != now.month) {
                  return false;
                }
                break;
              case 'Tùy chỉnh':
                final range = criteria.customDateRange;
                if (range != null) {
                  final start = DateTime(
                    range.start.year,
                    range.start.month,
                    range.start.day,
                  );
                  final end = DateTime(
                    range.end.year,
                    range.end.month,
                    range.end.day,
                  );
                  if (itemDay.isBefore(start) || itemDay.isAfter(end)) {
                    return false;
                  }
                }
                break;
            }
          }
        }
      }

      return true;
    }).toList();
  }

  Future<void> _openFilterScreen() async {
    final result = await Navigator.push<FilterCriteria>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          initialCriteria: _filterCriteria ?? const FilterCriteria(),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => _filterCriteria = result);
    }
  }

  Future<void> _openEditScreen(Transaction transaction) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseFormScreen(
          initial: transaction,
          repository: widget.repository,
        ),
      ),
    );

    if (saved == true) {
      await widget.onRefresh?.call();
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    final repository = widget.repository;
    if (repository == null || transaction.id == null) return;

    setState(() {
      _items = _items.where((item) => item.id != transaction.id).toList();
    });

    await repository.deleteTransaction(transaction.id!);
    await widget.onRefresh?.call();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${transaction.title}"'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () async {
            await repository.insertTransaction(transaction);
            await widget.onRefresh?.call();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    final hasFilter = _filterCriteria != null || _selectedTypeChip != 'all';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Giao dịch',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm giao dịch...',
                          hintStyle: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF94A3B8),
                            size: 22,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _openFilterScreen,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: hasFilter
                            ? const Color(0xFFEAF2FF)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: hasFilter
                            ? const Color(0xFF1769E0)
                            : const Color(0xFF64748B),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _buildTypeChip('Tất cả', 'all')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTypeChip('Thu nhập', 'income')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTypeChip('Chi tiêu', 'expense')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        hasFilter
                            ? 'Không tìm thấy giao dịch phù hợp'
                            : 'Chưa có giao dịch nào',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 15,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await widget.onRefresh?.call();
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        itemBuilder: (context, index) {
                          final transaction = filtered[index];
                          return Dismissible(
                            key: ValueKey(
                              'list_transaction_${transaction.id}_$index',
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              color: const Color(0xFFE53935),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            onDismissed: (_) => _deleteTransaction(transaction),
                            child: TransactionItem(
                              transaction: transaction,
                              onTap: () => _openEditScreen(transaction),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, String value) {
    final isSelected = _selectedTypeChip == value;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedTypeChip = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1769E0) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
