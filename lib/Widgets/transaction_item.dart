import 'package:flutter/material.dart';
import '../Models/transaction.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Giao dịch gần đây',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
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
  const TransactionList({super.key});

  static const List<TransactionData> transactions = [
    TransactionData(
      title: 'Ăn trưa',
      category: 'Ăn uống',
      date: '03/09/2024',
      amount: '-50.000 đ',
      icon: Icons.restaurant,
      color: Color(0xFFFF6D00),
    ),
    TransactionData(
      title: 'Xăng xe',
      category: 'Di chuyển',
      date: '03/09/2024',
      amount: '-100.000 đ',
      icon: Icons.directions_car,
      color: Color(0xFF2196F3),
    ),
    TransactionData(
      title: 'Lương tháng 9',
      category: 'Thu nhập',
      date: '01/09/2024',
      amount: '+8.000.000 đ',
      icon: Icons.attach_money,
      color: Color(0xFF2EAD4B),
    ),
    TransactionData(
      title: 'Mua sắm',
      category: 'Mua sắm',
      date: '31/08/2024',
      amount: '-300.000 đ',
      icon: Icons.shopping_cart,
      color: Color(0xFF9C27B0),
    ),
    TransactionData(
      title: 'Học phí',
      category: 'Giáo dục',
      date: '30/08/2024',
      amount: '-500.000 đ',
      icon: Icons.school,
      color: Color(0xFF009688),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          );
        },
        itemBuilder: (context, index) {
          return TransactionItem(
            transaction: transactions[index],
          );
        },
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionData transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: transaction.color,
            child: Icon(
              transaction.icon,
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
                      transaction.date,
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
            transaction.amount,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: transaction.amount.startsWith('+')
                  ? const Color(0xFF2EAD4B)
                  : const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}