import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionHeader extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const TransactionHeader({super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Giao dịch gần đây',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1769E0),
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(Transaction transaction)? onTap;
  final void Function(Transaction transaction)? onLongPress;
  final void Function(Transaction transaction)? onDismiss;
  final String emptyMessage;

  const TransactionList({
    super.key,
    required this.transactions,
    this.onTap,
    this.onLongPress,
    this.onDismiss,
    this.emptyMessage =
        'Chưa có giao dịch nào.\nBấm nút + để thêm giao dịch đầu tiên.',
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: Color(0xFF667085)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 20, endIndent: 20),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final item = TransactionItem(
            transaction: transaction,
            onTap: onTap == null ? null : () => onTap!(transaction),
          );

          Widget withLongPress = GestureDetector(
            onLongPress: onLongPress == null
                ? null
                : () => onLongPress!(transaction),
            child: item,
          );

          if (onDismiss != null && transaction.id != null) {
            return Dismissible(
              key: ValueKey('transaction_${transaction.id}'),
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
              onDismissed: (_) => onDismiss!(transaction),
              child: withLongPress,
            );
          }

          return withLongPress;
        },
      ),
    );
  }
}
