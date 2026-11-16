import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/category_constants.dart';
import '../models/transaction.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const StatisticsScreen({super.key, required this.transactions});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  // 'this_month' | 'last_month' | 'this_year'
  String _selectedPeriod = 'this_month';

  List<Transaction> get _periodExpenses {
    final now = DateTime.now();

    return widget.transactions.where((transaction) {
      if (!transaction.isExpense) return false;

      final date = DateTime.tryParse(transaction.date);
      if (date == null) return false;

      switch (_selectedPeriod) {
        case 'this_month':
          return date.year == now.year && date.month == now.month;
        case 'last_month':
          final lastMonth = DateTime(now.year, now.month - 1);
          return date.year == lastMonth.year && date.month == lastMonth.month;
        case 'this_year':
          return date.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  List<_CategoryStat> get _categoryStats {
    final expenses = _periodExpenses;
    if (expenses.isEmpty) return [];

    final categorySums = <String, double>{};
    double total = 0.0;

    for (final transaction in expenses) {
      final category = CategoryConstants.normalizeCategory(
        transaction.category,
      );
      categorySums[category] =
          (categorySums[category] ?? 0.0) + transaction.amount;
      total += transaction.amount;
    }

    if (total <= 0) return [];

    final stats = categorySums.entries.map((entry) {
      return _CategoryStat(
        category: entry.key,
        amount: entry.value,
        percentage: (entry.value / total * 100).round(),
        color: CategoryConstants.getColor(entry.key),
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));

    return stats;
  }

  double get _totalExpense {
    return _periodExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _categoryStats;
    final total = _totalExpense;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Thống kê',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildPeriodChip('Tháng này', 'this_month')),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPeriodChip('Tháng trước', 'last_month'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _buildPeriodChip('Năm nay', 'this_year')),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 230,
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(230, 230),
                      painter: _DonutChartPainter(stats: stats, total: total),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          CategoryConstants.formatCurrency(total),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tổng chi tiêu',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (stats.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Không có chi tiêu nào trong kỳ này',
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final stat = stats[index];
                    return Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: stat.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            stat.category,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Text(
                          CategoryConstants.formatCurrency(stat.amount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 14),
                        SizedBox(
                          width: 44,
                          child: Text(
                            '${stat.percentage}%',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1769E0) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _CategoryStat {
  final String category;
  final double amount;
  final int percentage;
  final Color color;

  _CategoryStat({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class _DonutChartPainter extends CustomPainter {
  final List<_CategoryStat> stats;
  final double total;

  _DonutChartPainter({required this.stats, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 32) / 2;
    const strokeWidth = 28.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    if (total <= 0 || stats.isEmpty) {
      paint.color = const Color(0xFFE2E8F0);
      canvas.drawCircle(center, radius, paint);
      return;
    }

    double startAngle = -pi / 2;

    for (final stat in stats) {
      final sweepAngle = (stat.amount / total) * 2 * pi;
      paint.color = stat.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.total != total || oldDelegate.stats != stats;
  }
}
