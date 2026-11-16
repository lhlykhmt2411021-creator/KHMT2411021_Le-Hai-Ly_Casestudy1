import 'package:flutter/material.dart';

/// Một danh mục thu/chi kèm icon và màu sắc hiển thị.
class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;
  final String type; // 'expense' hoặc 'income'

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

/// Nguồn dữ liệu duy nhất cho danh mục, icon, màu sắc và format hiển thị.
class CategoryConstants {
  static const Color colorAnUong = Color(0xFFFF5252);
  static const Color colorMuaSam = Color(0xFF26C6DA);
  static const Color colorDiLai = Color(0xFFAB47BC);
  static const Color colorHocTap = Color(0xFF1E88E5);
  static const Color colorLuong = Color(0xFF2EAD4B);
  static const Color colorKhac = Color(0xFFFB8C00);

  static const List<CategoryItem> expenseCategories = [
    CategoryItem(
      name: 'Ăn uống',
      icon: Icons.restaurant,
      color: colorAnUong,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Mua sắm',
      icon: Icons.shopping_cart,
      color: colorMuaSam,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Đi lại',
      icon: Icons.directions_car,
      color: colorDiLai,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Học tập',
      icon: Icons.menu_book,
      color: colorHocTap,
      type: 'expense',
    ),
    CategoryItem(
      name: 'Khác',
      icon: Icons.more_horiz,
      color: colorKhac,
      type: 'expense',
    ),
  ];

  static const List<CategoryItem> incomeCategories = [
    CategoryItem(
      name: 'Lương',
      icon: Icons.work,
      color: colorLuong,
      type: 'income',
    ),
    CategoryItem(
      name: 'Khác',
      icon: Icons.more_horiz,
      color: colorKhac,
      type: 'income',
    ),
  ];

  static const List<CategoryItem> allCategories = [
    ...expenseCategories,
    CategoryItem(
      name: 'Lương',
      icon: Icons.work,
      color: colorLuong,
      type: 'income',
    ),
  ];

  /// Tên danh mục theo loại giao dịch, dùng cho dropdown.
  static List<String> namesFor(String type) {
    final list = type == 'income' ? incomeCategories : expenseCategories;
    return list.map((e) => e.name).toList();
  }

  static IconData getIcon(String categoryName) {
    final clean = normalizeCategory(categoryName);
    for (final item in allCategories) {
      if (item.name == clean) return item.icon;
    }
    return Icons.category;
  }

  static Color getColor(String categoryName) {
    final clean = normalizeCategory(categoryName);
    for (final item in allCategories) {
      if (item.name == clean) return item.color;
    }
    return const Color(0xFF757575);
  }

  /// Chuyển tên danh mục cũ (dữ liệu đã lưu) về tên chuẩn hiện tại.
  static String normalizeCategory(String categoryName) {
    final clean = categoryName.trim();
    if (clean == 'Di chuyển' || clean == 'Đi lại') return 'Đi lại';
    if (clean == 'Giáo dục') return 'Học tập';
    if (clean == 'Thu nhập') return 'Lương';
    return clean;
  }

  /// 5000000 -> "5.000.000 đ"
  static String formatCurrency(double amount) {
    final rounded = amount.abs().toStringAsFixed(0);
    final formatted = rounded.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    final sign = amount < 0 ? '-' : '';
    return '$sign$formatted đ';
  }

  /// '2024-09-03' -> '03/09/2024'
  static String formatDate(String isoDate) {
    final parts = isoDate.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return isoDate;
  }
}
