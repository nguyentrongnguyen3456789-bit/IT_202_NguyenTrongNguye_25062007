CREATE DATABASE IF NOT EXISTS ss3_bt03;
USE ss3_bt03;

-- ======================================================
-- 1. TẠO BẢNG CUSTOMERS
-- ======================================================

CREATE TABLE IF NOT EXISTS CUSTOMERS (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    LastPurchaseDate DATE,
    Status VARCHAR(20)
);

-- ======================================================
-- 2. DỮ LIỆU MẪU (TEST)
-- ======================================================

INSERT INTO CUSTOMERS (FullName, Email, City, LastPurchaseDate, Status) VALUES
('Nguyễn Văn A', 'a@gmail.com', 'Hà Nội', '2025-05-20', 'Active'),
('Trần Thị B', 'b@gmail.com', 'Hà Nội', '2026-02-10', 'Active'),
('Lê Văn C', NULL, 'Hà Nội', '2025-01-15', 'Active'),
('Phạm Minh D', 'd@gmail.com', 'Hà Nội', '2024-12-01', 'Locked'),
('Hoàng Anh E', 'e@gmail.com', 'TP HCM', '2025-03-01', 'Active');

-- ======================================================
-- 3. PHÂN TÍCH (I/O)
-- ======================================================

-- INPUT:
-- Bảng CUSTOMERS
-- Các cột: FullName, Email, City, LastPurchaseDate, Status

-- OUTPUT:
-- Chỉ lấy: FullName, Email

-- Vì sao không dùng SELECT *:
-- → Lấy dư dữ liệu (Address, Gender, Points,...)
-- → Tốn tài nguyên
-- → Gây chậm hệ thống

-- ======================================================
-- 4.  LỌC (WHERE)
-- ======================================================

-- 1. Khách ở Hà Nội
-- 2. Không mua > 6 tháng (trước 01/10/2025)
-- 3. Có Email (không NULL, không rỗng)
-- 4. Tài khoản ACTIVE

-- ======================================================
-- 5. CODE 


SELECT FullName, Email
FROM CUSTOMERS
WHERE City = 'Hà Nội'
  AND LastPurchaseDate < '2025-10-01'
  AND Email IS NOT NULL
  AND Email != ''
  AND Status = 'Active';

