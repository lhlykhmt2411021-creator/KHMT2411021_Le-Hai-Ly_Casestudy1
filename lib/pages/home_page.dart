import 'package:flutter/material.dart';
import '../Widgets/header.dart';
import '../Widgets/balance_card.dart';
import '../Widgets/summary_card.dart';
import '../Widgets/transaction_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    Center(child: Text('Giao dịch', style: TextStyle(fontSize: 24))),
    Center(child: Text('Thống kê', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF1769E0),
        foregroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.add, size: 36),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
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
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              const BalanceCard(),
              const SizedBox(height: 24),
              const SummarySection(),
              const SizedBox(height: 32),
              const TransactionHeader(),
              const SizedBox(height: 12),
              const TransactionList(),
            ],
          ),
        ),
      ],
    );
  }
}