# KHMT2411021 - Lê Hải Lý - Case Study 1

## Thông tin sinh viên

- **Họ và tên:** Lê Hải Lý
- **MSSV:** KHMT2411021
- **Email:** lhlykhmt2411021@student.ctuet.edu.vn
- **Học phần:** Case Study 1 - Lập trình di động (Flutter)

## Thông tin project

- **Tên project:** `casestudy1`
- **Framework:** Flutter 3.47 (Dart 3.13), Material 3
- **Cơ sở dữ liệu:** SQLite (`sqflite`)
- **Nhánh chính:** `main` (đã hợp nhất toàn bộ nội dung từ `buoi1` đến `buoi6`)

## Chức năng đã hoàn thành

### 1. Màn hình chào mừng (Buổi 2)
- Logo, tên ứng dụng, slogan.
- Nút **Bắt đầu** chuyển sang màn hình Dashboard.

### 2. Thêm / sửa giao dịch (Buổi 3)
- Chọn loại giao dịch **Chi tiêu / Thu nhập**.
- Chọn danh mục (icon và màu riêng cho từng danh mục).
- Nhập số tiền, chọn ngày giao dịch, nhập ghi chú.
- Kiểm tra dữ liệu: không để trống số tiền, số tiền phải lớn hơn 0.
- Nếu bỏ trống ghi chú, tên giao dịch sẽ lấy theo tên danh mục.
- Hiển thị trạng thái đang lưu, tránh bấm lưu hai lần.

### 3. Dashboard (Buổi 4)
- Thẻ số dư hiện tại (có ẩn/hiện số dư).
- Tổng thu nhập và tổng chi tiêu.
- Danh sách 5 giao dịch gần đây.
- Kéo xuống để tải lại dữ liệu.
- Nút **+** để thêm giao dịch nhanh.

### 4. Cơ sở dữ liệu SQLite (Buổi 5)
- `DatabaseHelper` theo mẫu Singleton, khởi tạo database lười (lazy).
- Bảng `transactions`: `id`, `title`, `amount`, `type`, `date`, `category`.
- Đầy đủ CRUD: thêm, đọc, cập nhật, xóa.
- Truy vấn thêm: tìm theo tiêu đề, lọc theo loại giao dịch.

### 5. Hoàn thiện ứng dụng (Buổi 6)
- `TransactionRepository` tách tầng dữ liệu khỏi giao diện.
- Tab **Giao dịch**: tìm kiếm (debounce 350ms), lọc nhanh theo loại, bộ lọc nâng cao (loại giao dịch, danh mục, khoảng thời gian).
- Sửa giao dịch khi bấm vào một dòng, xóa bằng cách vuốt kèm **Hoàn tác**.
- Tab **Thống kê**: biểu đồ tròn (donut) chi tiêu theo danh mục, xem theo tháng này / tháng trước / năm nay, hiển thị số tiền và tỷ lệ %.
- Tab **Cá nhân**: thông tin sinh viên và các mục cài đặt.
- Thanh điều hướng 4 tab: Trang chủ - Giao dịch - Thống kê - Cá nhân.

## Cấu trúc thư mục

```text
lib/
├── constants/
│   └── category_constants.dart   # Danh mục, icon, màu, format tiền/ngày
├── database/
│   └── database_helper.dart      # Singleton + CRUD SQLite
├── models/
│   ├── filter_criteria.dart      # Tiêu chí bộ lọc
│   └── transaction.dart          # Model Transaction
├── repositories/
│   └── transaction_repository.dart
├── pages/
│   ├── welcome_page.dart         # Màn hình chào mừng
│   ├── home_page.dart            # Dashboard + 4 tab điều hướng
│   └── expense_form_screen.dart  # Thêm / sửa giao dịch
├── screens/
│   ├── transaction_list_screen.dart
│   ├── filter_screen.dart
│   ├── statistics_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── header.dart
│   ├── balance_card.dart
│   ├── summary_card.dart
│   ├── transaction_item.dart
│   ├── transaction_list.dart
│   └── expense_form_section.dart
├── utils/
│   └── transaction_utils.dart    # Hàm format dùng chung
└── main.dart
```

## Cách chạy

```bash
flutter pub get
flutter run
```

Chạy kiểm tra chất lượng mã nguồn và test:

```bash
flutter analyze
flutter test
```

## Kiểm thử

Project có các nhóm test:

| File | Nội dung |
| --- | --- |
| `test/widget_test.dart` | Ứng dụng khởi động ở màn hình chào mừng |
| `test/home_page_test.dart` | Dashboard, số dư, tổng thu/chi, chuyển tab |
| `test/expense_form_test.dart` | Validate form, thêm/sửa giao dịch |
| `test/transaction_list_test.dart` | Tìm kiếm, lọc theo loại, màn hình bộ lọc |
| `test/statistics_test.dart` | Thống kê theo kỳ, tỷ lệ danh mục |
| `test/models_test.dart` | Model `Transaction` và các hàm format |

## Phân nhánh theo từng buổi

| Nhánh | Nội dung |
| --- | --- |
| `buoi1` | Cài đặt môi trường, tạo project Flutter |
| `buoi2` | Màn hình Welcome |
| `buoi3` | Màn hình thêm/sửa giao dịch, validate dữ liệu |
| `buoi4` | Dashboard, thẻ số dư, tổng thu/chi, danh sách giao dịch |
| `buoi5` | SQLite: `DatabaseHelper`, model `Transaction` |
| `buoi6` | Hoàn thiện CRUD, tìm kiếm, bộ lọc, thống kê, cá nhân |

## Link repository

https://github.com/lhlykhmt2411021-creator/KHMT2411021_Le-Hai-Ly_Casestudy1
