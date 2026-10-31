import 'package:flutter/material.dart';

/// 1500000 -> "1.500.000"
String formatMoney(double value) {
  final digits = value.round().abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Số dư có thể âm: -> "-200.000 đ"
String formatBalance(double value) {
  final sign = value < 0 ? '-' : '';
  return '$sign${formatMoney(value)} đ';
}

/// '2026-09-26' -> '26/09/2026'
String formatDateIso(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return formatDate(d);
}

String formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day/$month/${d.year}';
}

/// DateTime -> '2026-09-26' (để lưu vào SQLite, sắp xếp theo chuỗi vẫn đúng)
String toIsoDate(DateTime d) {
  final month = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$month-$day';
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Ăn uống':
      return Icons.restaurant;
    case 'Di chuyển':
      return Icons.directions_car;
    case 'Mua sắm':
      return Icons.shopping_cart;
    case 'Học tập':
      return Icons.school;
    case 'Lương':
      return Icons.attach_money;
    case 'Thưởng':
      return Icons.card_giftcard;
    default:
      return Icons.category;
  }
}

Color categoryColor(String category) {
  switch (category) {
    case 'Ăn uống':
      return const Color(0xFFFF6D00);
    case 'Di chuyển':
      return const Color(0xFF2196F3);
    case 'Mua sắm':
      return const Color(0xFF9C27B0);
    case 'Học tập':
      return const Color(0xFF009688);
    case 'Lương':
    case 'Thưởng':
      return const Color(0xFF2EAD4B);
    default:
      return const Color(0xFF78909C);
  }
}