import 'package:flutter/material.dart';

import '../constants/category_constants.dart';
import '../models/filter_criteria.dart';

class FilterScreen extends StatefulWidget {
  final FilterCriteria? initialCriteria;

  const FilterScreen({super.key, this.initialCriteria});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late bool _isAllTypes;
  late bool _isIncome;
  late bool _isExpense;

  late String _selectedCategory;
  String? _selectedTimeRange;
  DateTimeRange? _customDateRange;

  List<String> get _categories => [
    'Tất cả danh mục',
    ...CategoryConstants.allCategories.map((item) => item.name).toSet(),
  ];

  static const List<String> _timeRanges = [
    'Hôm nay',
    '7 ngày qua',
    'Tháng này',
    'Tùy chỉnh',
  ];

  @override
  void initState() {
    super.initState();
    final criteria = widget.initialCriteria ?? const FilterCriteria();
    _isAllTypes = criteria.isAllTypes;
    _isIncome = criteria.isIncome;
    _isExpense = criteria.isExpense;
    _selectedCategory = criteria.category;
    _selectedTimeRange = criteria.timeRange;
    _customDateRange = criteria.customDateRange;
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange:
          _customDateRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );

    if (picked != null) {
      setState(() {
        _customDateRange = picked;
        _selectedTimeRange = 'Tùy chỉnh';
      });
    }
  }

  void _onApply() {
    Navigator.pop(
      context,
      FilterCriteria(
        isAllTypes: _isAllTypes,
        isIncome: _isIncome,
        isExpense: _isExpense,
        category: _selectedCategory,
        timeRange: _selectedTimeRange,
        customDateRange: _customDateRange,
      ),
    );
  }

  void _reset() {
    setState(() {
      _isAllTypes = true;
      _isIncome = false;
      _isExpense = false;
      _selectedCategory = 'Tất cả danh mục';
      _selectedTimeRange = 'Hôm nay';
      _customDateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bộ lọc',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _reset,
            child: const Text(
              'Đặt lại',
              style: TextStyle(
                color: Color(0xFF1769E0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loại giao dịch',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCheckboxTile(
                      title: 'Tất cả',
                      value: _isAllTypes,
                      onTap: () {
                        setState(() {
                          _isAllTypes = true;
                          _isIncome = false;
                          _isExpense = false;
                        });
                      },
                    ),
                    _buildCheckboxTile(
                      title: 'Thu nhập',
                      value: _isIncome,
                      onTap: () => _toggleType(isIncome: true),
                    ),
                    _buildCheckboxTile(
                      title: 'Chi tiêu',
                      value: _isExpense,
                      onTap: () => _toggleType(isIncome: false),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Danh mục',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _categories.contains(_selectedCategory)
                          ? _selectedCategory
                          : 'Tất cả danh mục',
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCategory = value);
                        }
                      },
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Khoảng thời gian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._timeRanges.map((range) {
                      final isSelected = _selectedTimeRange == range;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTimeRange = null;
                            } else {
                              _selectedTimeRange = range;
                            }
                          });
                          if (range == 'Tùy chỉnh' && !isSelected) {
                            _pickCustomDateRange();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF1769E0)
                                        : const Color(0xFFCBD5E1),
                                    width: isSelected ? 6 : 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  range == 'Tùy chỉnh' &&
                                          _customDateRange != null
                                      ? 'Tùy chỉnh '
                                            '(${_customDateRange!.start.day}/'
                                            '${_customDateRange!.start.month} - '
                                            '${_customDateRange!.end.day}/'
                                            '${_customDateRange!.end.month})'
                                      : range,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1769E0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Áp dụng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleType({required bool isIncome}) {
    setState(() {
      if (isIncome) {
        _isIncome = !_isIncome;
      } else {
        _isExpense = !_isExpense;
      }

      if (_isIncome && _isExpense) {
        // Chọn cả hai = tất cả
        _isAllTypes = true;
        _isIncome = false;
        _isExpense = false;
      } else if (!_isIncome && !_isExpense) {
        _isAllTypes = true;
      } else {
        _isAllTypes = false;
      }
    });
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF1769E0) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? const Color(0xFF1769E0)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A)),
            ),
          ],
        ),
      ),
    );
  }
}
