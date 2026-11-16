import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:casestudy1/pages/home_page.dart';

import 'test_data.dart';

void main() {
  group('HomePage - Dashboard', () {
    testWidgets('Hiển thị đủ số dư, tổng thu, tổng chi và 4 tab', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(initialTransactions: buildSampleTransactions()),
        ),
      );

      expect(find.text('Quản lý thu chi'), findsOneWidget);

      // Số dư = 8.000.000 - 450.000
      expect(find.text('SỐ DƯ HIỆN TẠI'), findsOneWidget);
      expect(find.text('7.550.000 đ'), findsOneWidget);

      expect(find.text('TỔNG THU NHẬP'), findsOneWidget);
      expect(find.text('8.000.000 đ'), findsOneWidget);
      expect(find.text('TỔNG CHI TIÊU'), findsOneWidget);
      expect(find.text('450.000 đ'), findsOneWidget);

      expect(find.text('Giao dịch gần đây'), findsOneWidget);
      expect(find.text('Xem tất cả'), findsOneWidget);
      expect(find.text('Ăn trưa'), findsOneWidget);

      expect(find.text('Trang chủ'), findsOneWidget);
      expect(find.text('Giao dịch'), findsOneWidget);
      expect(find.text('Thống kê'), findsOneWidget);
      expect(find.text('Cá nhân'), findsOneWidget);

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Chuyển tab Thống kê hiển thị biểu đồ chi tiêu', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(initialTransactions: buildSampleTransactions()),
        ),
      );

      await tester.tap(find.text('Thống kê'));
      await tester.pumpAndSettle();

      expect(find.text('Tổng chi tiêu'), findsOneWidget);
      expect(find.text('Tháng này'), findsOneWidget);
      expect(find.text('Tháng trước'), findsOneWidget);
      expect(find.text('Năm nay'), findsOneWidget);

      // Chi tiêu tháng này: 50.000 + 100.000
      expect(find.text('150.000 đ'), findsOneWidget);
      expect(find.text('Đi lại'), findsWidgets);
      expect(find.text('Ăn uống'), findsWidgets);
    });

    testWidgets('Chuyển tab Cá nhân hiển thị thông tin sinh viên', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(initialTransactions: buildSampleTransactions()),
        ),
      );

      await tester.tap(find.text('Cá nhân'));
      await tester.pumpAndSettle();

      expect(find.text('Thông tin sinh viên'), findsOneWidget);
      expect(find.text('KHMT2411021'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);
    });
  });
}
