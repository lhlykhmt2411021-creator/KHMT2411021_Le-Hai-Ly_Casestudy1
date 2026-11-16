import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:casestudy1/screens/statistics_screen.dart';

import 'test_data.dart';

void main() {
  testWidgets('Thống kê tháng này hiển thị đúng tổng và tỷ lệ danh mục', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatisticsScreen(transactions: buildSampleTransactions()),
      ),
    );

    expect(find.text('Thống kê'), findsOneWidget);
    expect(find.text('150.000 đ'), findsOneWidget);
    expect(find.text('Đi lại'), findsOneWidget);
    expect(find.text('67%'), findsOneWidget);
    expect(find.text('Ăn uống'), findsOneWidget);
    expect(find.text('33%'), findsOneWidget);
  });

  testWidgets('Chuyển sang tháng trước cập nhật lại biểu đồ', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatisticsScreen(transactions: buildSampleTransactions()),
      ),
    );

    await tester.tap(find.text('Tháng trước'));
    await tester.pumpAndSettle();

    // Chỉ còn giao dịch Mua sắm của tháng trước.
    expect(find.text('300.000 đ'), findsNWidgets(2));
    expect(find.text('Mua sắm'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Ăn uống'), findsNothing);
  });

  testWidgets('Kỳ không có dữ liệu hiển thị thông báo rỗng', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: StatisticsScreen(transactions: [])),
    );

    expect(find.text('Không có chi tiêu nào trong kỳ này'), findsOneWidget);
    expect(find.text('0 đ'), findsOneWidget);
  });
}
