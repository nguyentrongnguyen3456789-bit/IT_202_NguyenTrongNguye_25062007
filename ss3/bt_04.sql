CREATE DATABASE IF NOT EXISTS ss3_bt04;
USE ss3_bt04;

-- ======================================================
-- 1. TẠO BẢNG
-- ======================================================
CREATE TABLE IF NOT EXISTS ORDERS (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(18,2),
    Status VARCHAR(20)
);

-- ======================================================
-- 2. THÊM CỘT SOFT DELETE
-- ======================================================
ALTER TABLE ORDERS
ADD IsDeleted TINYINT(1) DEFAULT 0;

-- ======================================================
-- 3. PHÂN TÍCH & ĐỀ XUẤT
-- ======================================================

-- Giải pháp 1: HARD DELETE
-- DELETE FROM ORDERS WHERE Status = 'Canceled';
-- → Ưu: Giảm dung lượng, tăng tốc
-- → Nhược: Mất dữ liệu, không phục vụ kiểm toán

-- Giải pháp 2: SOFT DELETE
-- UPDATE ORDERS SET IsDeleted = 1 WHERE Status = 'Canceled';
-- → Ưu: Giữ dữ liệu, phục vụ kiểm toán
-- → Nhược: Không giảm dung lượng

-- ======================================================
-- 4. SO SÁNH
-- ======================================================

-- Tiêu chí              | Hard Delete        | Soft Delete
-- ---------------------------------------------------------
-- Dung lượng           | Giảm mạnh          | Không giảm
-- Tốc độ truy vấn      | Nhanh              | Chậm hơn một chút
-- Lịch sử kiểm toán    | Không có           | Đầy đủ

-- => LỰA CHỌN: SOFT DELETE (phù hợp yêu cầu kiểm toán)

-- ======================================================
-- 5. TRIỂN KHAI
-- ======================================================

-- Đánh dấu đơn hàng bị hủy
UPDATE ORDERS
SET IsDeleted = 1
WHERE Status = 'Canceled';

-- ======================================================
-- 6. KẾT QUẢ MONG MUỐN
-- ======================================================

-- Hệ thống bán hàng (KHÔNG thấy đơn hủy)
SELECT *
FROM ORDERS
WHERE IsDeleted = 0;

-- Kế toán (VẪN thấy đơn hủy để kiểm toán)
SELECT *
FROM ORDERS
WHERE Status = 'Canceled';

-- ======================================================
-- KẾT LUẬN
-- ======================================================

-- Soft Delete giúp:
-- + Ẩn đơn hàng bị hủy khỏi hệ thống chính
-- + Vẫn giữ dữ liệu để kiểm toán
-- + Đáp ứng đầy đủ yêu cầu nghiệp vụ