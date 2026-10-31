import 'package:flutter/material.dart';
import '../Models/transaction_model.dart';
import '../database/database_helper.dart';
import '../Widgets/header.dart';
import '../Widgets/balance_card.dart';
import '../Widgets/summary_card.dart';
import '../Widgets/transaction_item.dart';
import 'expense_form_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();
    if (!mounted) return;
    setState(() {
      _transactions = data;
      _isLoading = false;
    });
  }

  Future<void> _openForm([Transaction? transaction]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseFormScreen(initial: transaction),
      ),
    );
    if (saved == true) {
      await _loadTransactions();
    }
  }

  Future<void> _confirmDelete(Transaction transaction) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa giao dịch'),
        content: Text('Bạn có chắc muốn xóa "${transaction.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (ok == true && transaction.id != null) {
      await DatabaseHelper.instance.deleteTransaction(transaction.id!);
      await _loadTransactions();
    }
  }

  double get _totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildDashboard(),
      _buildAllTransactions(),
      const Center(child: Text('Thống kê', style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : pages[currentIndex],
      ),
      floatingActionButton: currentIndex == 2
          ? null
          : FloatingActionButton(
        backgroundColor: const Color(0xFF1769E0),
        foregroundColor: Colors.white,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, size: 36),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: const Color(0xFF1769E0),
        unselectedItemColor: const Color(0xFF263238),
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
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final balance = _totalIncome - _totalExpense;
    final recent = _transactions.take(5).toList();

    return RefreshIndicator(
      onRefresh: _loadTransactions,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            const SizedBox(height: 20),
            BalanceCard(balance: balance),
            const SizedBox(height: 24),
            SummarySection(income: _totalIncome, expense: _totalExpense),
            const SizedBox(height: 32),
            TransactionHeader(
              onSeeAll: () => setState(() => currentIndex = 1),
            ),
            const SizedBox(height: 12),
            TransactionList(
              transactions: recent,
              onTap: _openForm,
              onLongPress: _confirmDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllTransactions() {
    return RefreshIndicator(
      onRefresh: _loadTransactions,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tất cả giao dịch',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Bấm để sửa, nhấn giữ để xóa',
              style: TextStyle(color: Color(0xFF667085)),
            ),
            const SizedBox(height: 12),
            TransactionList(
              transactions: _transactions,
              onTap: _openForm,
              onLongPress: _confirmDelete,
            ),
          ],
        ),
      ),
    );
  }
}