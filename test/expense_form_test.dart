import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:casestudy1/models/transaction.dart';
import 'package:casestudy1/pages/expense_form_screen.dart';

void main() {
  Future<void> openForm(
    WidgetTester tester, {
    Transaction? initial,
    required Future<void> Function(Transaction) onSave,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ExpenseFormScreen(initial: initial, onSave: onSave),
                    ),
                  );
                },
                child: const Text('Mở form'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mở form'));
    await tester.pumpAndSettle();
  }

  testWidgets('Form thêm giao dịch hiển thị đủ trường và bắt lỗi số tiền', (
    tester,
  ) async {
    await openForm(tester, onSave: (_) async {});

    expect(find.text('Thêm giao dịch'), findsOneWidget);
    expect(find.text('Chi tiêu'), findsOneWidget);
    expect(find.text('Thu nhập'), findsOneWidget);
    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Số tiền'), findsOneWidget);
    expect(find.text('Ngày giao dịch'), findsOneWidget);
    expect(find.text('Ghi chú'), findsOneWidget);
    expect(find.text('Lưu'), findsOneWidget);

    await tester.ensureVisible(find.text('Lưu'));
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('Vui lòng nhập số tiền'), findsOneWidget);
  });

  testWidgets('Lưu giao dịch chi tiêu trả về đúng dữ liệu', (tester) async {
    Transaction? saved;
    await openForm(tester, onSave: (transaction) async => saved = transaction);

    await tester.enterText(find.byType(TextFormField).at(0), '250000');
    await tester.enterText(find.byType(TextFormField).at(2), 'Ăn sáng');

    await tester.ensureVisible(find.text('Lưu'));
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(saved!.amount, 250000);
    expect(saved!.title, 'Ăn sáng');
    expect(saved!.type, 'expense');
    expect(saved!.category, 'Ăn uống');
    expect(find.text('Thêm giao dịch'), findsNothing);
  });

  testWidgets('Chuyển sang Thu nhập đổi danh mục mặc định thành Lương', (
    tester,
  ) async {
    Transaction? saved;
    await openForm(tester, onSave: (transaction) async => saved = transaction);

    await tester.tap(find.text('Thu nhập'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '1000000');
    await tester.ensureVisible(find.text('Lưu'));
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(saved!.type, 'income');
    expect(saved!.category, 'Lương');
    expect(saved!.title, 'Lương');
  });

  testWidgets('Form sửa giao dịch điền sẵn dữ liệu cũ', (tester) async {
    final transaction = Transaction(
      id: 10,
      title: 'Ăn trưa',
      amount: 100000,
      type: 'expense',
      date: '2025-04-12',
      category: 'Ăn uống',
    );

    await openForm(tester, initial: transaction, onSave: (_) async {});

    expect(find.text('Sửa giao dịch'), findsOneWidget);
    expect(find.text('100000'), findsOneWidget);
    expect(find.text('Ăn trưa'), findsOneWidget);
    expect(find.text('12/04/2025'), findsOneWidget);
  });
}
