import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../screens/profile_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/transaction_list_screen.dart';
import '../widgets/balance_card.dart';
import '../widgets/header.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list.dart';
import 'expense_form_screen.dart';

class HomePage extends StatefulWidget {
  final TransactionRepository? repository;
  final List<Transaction>? initialTransactions;

  const HomePage({super.key, this.repository, this.initialTransactions});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late final TransactionRepository _repository;

  List<Transaction> _transactions = [];
  bool _isLoading = true;
  bool _showBalance = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? TransactionRepository();

    if (widget.initialTransactions != null) {
      _transactions = List.of(widget.initialTransactions!);
      _isLoading = false;
    } else {
      _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final data = await _repository.getAllTransactions();
      if (!mounted) return;
      setState(() {
        _transactions = data;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'Không thể tải dữ liệu: $error';
      });
    }
  }

  Future<void> _openForm([Transaction? transaction]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ExpenseFormScreen(initial: transaction, repository: _repository),
      ),
    );

    if (saved == true) {
      await _loadTransactions();
    }
  }

  Future<void> _deleteTransaction(
    Transaction transaction, {
    bool confirm = false,
  }) async {
    if (transaction.id == null) return;

    if (confirm) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Xóa giao dịch'),
          content: Text('Bạn có chắc muốn xóa "${transaction.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xóa'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    final previous = _transactions;
    setState(() {
      _transactions = _transactions
          .where((item) => item.id != transaction.id)
          .toList();
    });

    try {
      await _repository.deleteTransaction(transaction.id!);
      await _loadTransactions();
    } catch (error) {
      if (mounted) {
        setState(() => _transactions = previous);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể xóa giao dịch: $error'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${transaction.title}"'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () async {
            await _repository.insertTransaction(transaction);
            await _loadTransactions();
          },
        ),
      ),
    );
  }

  double get _totalIncome {
    return _transactions
        .where((transaction) => transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get _totalExpense {
    return _transactions
        .where((transaction) => transaction.isExpense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildDashboard(),
      TransactionListScreen(
        transactions: _transactions,
        repository: _repository,
        onRefresh: _loadTransactions,
      ),
      StatisticsScreen(transactions: _transactions),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      floatingActionButton: currentIndex <= 1
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1769E0),
              foregroundColor: Colors.white,
              onPressed: () => _openForm(),
              child: const Icon(Icons.add, size: 32),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: const Color(0xFF1769E0),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final balance = _totalIncome - _totalExpense;
    final recent = _transactions.take(5).toList();

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(onProfileTap: () => setState(() => currentIndex = 3)),
              const SizedBox(height: 20),
              BalanceCard(
                balance: balance,
                showBalance: _showBalance,
                onToggleVisibility: () {
                  setState(() => _showBalance = !_showBalance);
                },
              ),
              const SizedBox(height: 24),
              SummarySection(income: _totalIncome, expense: _totalExpense),
              const SizedBox(height: 32),
              TransactionHeader(
                onSeeAll: () => setState(() => currentIndex = 1),
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (_loadError != null) _buildErrorBanner(),
                TransactionList(
                  transactions: recent,
                  onTap: _openForm,
                  onLongPress: (transaction) =>
                      _deleteTransaction(transaction, confirm: true),
                  onDismiss: _deleteTransaction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE53935)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _loadError!,
              style: const TextStyle(fontSize: 13, color: Color(0xFFB71C1C)),
            ),
          ),
          TextButton(
            onPressed: _loadTransactions,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
