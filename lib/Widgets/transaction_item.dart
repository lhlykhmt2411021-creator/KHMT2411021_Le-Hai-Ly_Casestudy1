import 'package:flutter/material.dart';
import '../Models/transaction_model.dart';
import '../utils/transaction_utils.dart';

class TransactionHeader extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const TransactionHeader({super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Giao dịch gần đây',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
          onPressed: onSeeAll,
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 17,
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
  final void Function(Transaction transaction) onTap;
  final void Function(Transaction transaction)? onLongPress;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: transactions.isEmpty
          ? const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Chưa có giao dịch nào.\nBấm nút + để thêm giao dịch đầu tiên.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF667085)),
          ),
        ),
      )
          : ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) =>
        const Divider(height: 1, indent: 20, endIndent: 20),
        itemBuilder: (context, index) {
          final t = transactions[index];
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onTap(t),
            onLongPress:
            onLongPress == null ? null : () => onLongPress!(t),
            child: TransactionItem(transaction: t),
          );
        },
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountText =
        '${isIncome ? '+' : '-'}${formatMoney(transaction.amount)} đ';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: categoryColor(transaction.category),
            child: Icon(
              categoryIcon(transaction.category),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        transaction.category,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formatDateIso(transaction.date),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amountText,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF2EAD4B)
                  : const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}