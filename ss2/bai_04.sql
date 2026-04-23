USE dtb_ss02;

-- PHÂN TÍCH HIỆN TRẠNG
-- Bảng USERS có khoảng 2 triệu bản ghi
-- Cột phone đang dùng kiểu INT → bị mất số 0 đầu (ví dụ 098 → 98)
-- Gây lỗi đăng nhập cho người dùng
-- Hệ thống đang chạy production → cần hạn chế lock bảng và downtime

-- Hướng xử lý 1: ALTER TRỰC TIẾP
-- Ưu điểm:
-- + Đơn giản, chỉ cần 1 câu lệnh
-- Nhược điểm:
-- - Có thể lock bảng lâu (vì dữ liệu lớn)
-- - Gây downtime hệ thống
-- - Khó rollback nếu xảy ra lỗi

-- Ví dụ:
-- ALTER TABLE USERS MODIFY phone VARCHAR(15);

-- Hướng xử lý 2: THÊM CỘT MỚI + MIGRATE (AN TOÀN)

-- Ưu điểm:
-- + Hạn chế lock bảng
-- + An toàn dữ liệu
-- + Có thể kiểm tra trước khi thay thế
-- + Dễ rollback
-- Nhược điểm:
-- - Phức tạp hơn
-- - Tốn thêm thời gian triển khai

-- Các bước thực hiện:
-- 1. Thêm cột mới
-- ALTER TABLE USERS ADD COLUMN phone_new VARCHAR(15);

-- 2. Sao chép dữ liệu
-- UPDATE USERS SET phone_new = CAST(phone AS CHAR);

-- 3. Kiểm tra dữ liệu (đảm bảo không lỗi)

-- 4. Sẵn sàng chuyển đổi chính thức

-- SO SÁNH và LỰA CHỌN
-- =========================================
-- Với hệ thống lớn (~2 triệu bản ghi), việc ALTER trực tiếp tiềm ẩn rủi ro cao
-- Giải pháp thêm cột mới giúp đảm bảo an toàn dữ liệu và giảm ảnh hưởng hệ thống
-- => LỰA CHỌN: Hướng xử lý 2 (MIGRATE AN TOÀN)

-- THỰC THI CUỐI CÙNG (DDL CHÍNH THỨC)
-- Lưu ý quan trọng: Câu lệnh dưới đây chỉ thực hiện sau khi đã migrate dữ liệu an toàn
-- bằng giải pháp 2 và kiểm tra dữ liệu thành công

ALTER TABLE USERS 
MODIFY phone VARCHAR(15);
