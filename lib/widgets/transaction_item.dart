import 'package:flutter/material.dart';

import '../constants/category_constants.dart';
import '../models/transaction.dart';

/// Một dòng giao dịch trong danh sách.
class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountText =
        '${isIncome ? '+' : '-'}'
        '${CategoryConstants.formatCurrency(transaction.amount)}';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: CategoryConstants.getColor(transaction.category),
              child: Icon(
                CategoryConstants.getIcon(transaction.category),
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          CategoryConstants.normalizeCategory(
                            transaction.category,
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        CategoryConstants.formatDate(transaction.date),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              amountText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome
                    ? const Color(0xFF2EAD4B)
                    : const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
