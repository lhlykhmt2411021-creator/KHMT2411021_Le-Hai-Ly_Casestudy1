import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:casestudy1/screens/transaction_list_screen.dart';

import 'test_data.dart';

void main() {
  Widget buildScreen() {
    return MaterialApp(
      home: TransactionListScreen(transactions: buildSampleTransactions()),
    );
  }

  testWidgets('Hiển thị toàn bộ giao dịch ban đầu', (tester) async {
    await tester.pumpWidget(buildScreen());

    expect(find.text('Giao dịch'), findsOneWidget);
    expect(find.text('Tìm kiếm giao dịch...'), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Thu nhập'), findsOneWidget);
    expect(find.text('Chi tiêu'), findsOneWidget);

    expect(find.text('Ăn trưa'), findsOneWidget);
    expect(find.text('Lương tháng này'), findsOneWidget);
    expect(find.text('Mua sắm tháng trước'), findsOneWidget);
  });

  testWidgets('Tìm kiếm theo tên giao dịch', (tester) async {
    await tester.pumpWidget(buildScreen());

    await tester.enterText(find.byType(TextField), 'lương');
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Lương tháng này'), findsOneWidget);
    expect(find.text('Ăn trưa'), findsNothing);
    expect(find.text('Xăng xe'), findsNothing);
  });

  testWidgets('Lọc theo chip Thu nhập / Chi tiêu', (tester) async {
    await tester.pumpWidget(buildScreen());

    await tester.tap(find.text('Thu nhập'));
    await tester.pumpAndSettle();

    expect(find.text('Lương tháng này'), findsOneWidget);
    expect(find.text('Ăn trưa'), findsNothing);

    await tester.tap(find.text('Chi tiêu'));
    await tester.pumpAndSettle();

    expect(find.text('Ăn trưa'), findsOneWidget);
    expect(find.text('Lương tháng này'), findsNothing);
  });

  testWidgets('Mở màn hình bộ lọc và áp dụng', (tester) async {
    await tester.pumpWidget(buildScreen());

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    expect(find.text('Bộ lọc'), findsOneWidget);
    expect(find.text('Loại giao dịch'), findsOneWidget);
    expect(find.text('Khoảng thời gian'), findsOneWidget);

    await tester.tap(find.text('Chi tiêu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Áp dụng'));
    await tester.pumpAndSettle();

    expect(find.text('Bộ lọc'), findsNothing);
    expect(find.text('Ăn trưa'), findsOneWidget);
    expect(find.text('Lương tháng này'), findsNothing);
  });
}
