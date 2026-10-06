import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:casestudy1/main.dart';

void main() {
  testWidgets('App khoi dong va hien thi dashboard quan ly thu chi',
          (WidgetTester tester) async {
        await tester.pumpWidget(const ExpenseManagerApp());

        expect(find.text('Quản lý thu chi'), findsOneWidget);
      });
}