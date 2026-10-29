import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'database/database_helper.dart';
import 'Models/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ĐOẠN KIỂM TRA TẠM - xóa trước khi commit
  final id = await DatabaseHelper.instance.insertTransaction(
    Transaction(
      title: 'Test',
      amount: 50000,
      type: 'expense',
      date: '2026-10-10',
      category: 'Ăn uống',
    ),
  );
  final all = await DatabaseHelper.instance.getTransactions();
  print('Đã thêm id=$id, tổng=${all.length}');
  // HẾT ĐOẠN KIỂM TRA TẠM

  runApp(const ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý thu chi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1769E0),
        ),
      ),
      home: const HomePage(),
    );
  }
}