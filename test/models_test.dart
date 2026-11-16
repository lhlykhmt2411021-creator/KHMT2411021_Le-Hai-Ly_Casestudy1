import 'package:flutter_test/flutter_test.dart';

import 'package:casestudy1/models/transaction.dart';
import 'package:casestudy1/utils/transaction_utils.dart';

void main() {
  group('Transaction model', () {
    final transaction = Transaction(
      id: 1,
      title: 'Ăn trưa',
      amount: 50000,
      type: 'expense',
      date: '2026-09-26',
      category: 'Ăn uống',
    );

    test('isIncome / isExpense đúng theo type', () {
      expect(transaction.isExpense, isTrue);
      expect(transaction.isIncome, isFalse);
      expect(transaction.copyWith(type: 'income').isIncome, isTrue);
    });

    test('toMap / fromMap giữ nguyên dữ liệu', () {
      final map = transaction.toMap();
      final restored = Transaction.fromMap(map);

      expect(restored.id, 1);
      expect(restored.title, 'Ăn trưa');
      expect(restored.amount, 50000);
      expect(restored.type, 'expense');
      expect(restored.date, '2026-09-26');
      expect(restored.category, 'Ăn uống');
    });

    test('copyWith chỉ thay đổi trường được truyền', () {
      final updated = transaction.copyWith(title: 'Ăn tối', amount: 70000);

      expect(updated.id, transaction.id);
      expect(updated.title, 'Ăn tối');
      expect(updated.amount, 70000);
      expect(updated.category, transaction.category);
    });
  });

  group('Format tiền tệ và ngày tháng', () {
    test('formatMoney thêm dấu chấm phân cách nghìn', () {
      expect(formatMoney(1500000), '1.500.000');
      expect(formatMoney(0), '0');
      expect(formatMoney(1234), '1.234');
    });

    test('formatBalance hiển thị số âm', () {
      expect(formatBalance(200000), '200.000 đ');
      expect(formatBalance(-200000), '-200.000 đ');
    });

    test('formatDate / toIsoDate chuyển đổi đúng', () {
      expect(formatDate(DateTime(2026, 9, 26)), '26/09/2026');
      expect(formatDateIso('2026-09-26'), '26/09/2026');
      expect(toIsoDate(DateTime(2026, 9, 6)), '2026-09-06');
    });
  });
}
