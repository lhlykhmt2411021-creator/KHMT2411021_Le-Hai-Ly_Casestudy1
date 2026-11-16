import 'package:flutter_test/flutter_test.dart';

import 'package:casestudy1/main.dart';

void main() {
  testWidgets('Ứng dụng khởi động ở màn hình chào mừng', (tester) async {
    await tester.pumpWidget(const ExpenseManagerApp());

    expect(find.text('Expense Manager'), findsOneWidget);
    expect(find.text('Bắt đầu'), findsOneWidget);
    expect(
      find.text('Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả'),
      findsOneWidget,
    );
  });
}
