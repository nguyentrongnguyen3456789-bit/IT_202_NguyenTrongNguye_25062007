
CREATE DATABASE IF NOT EXISTS ss3_bt01;
USE ss3_bt01;

CREATE TABLE IF NOT EXISTS PRODUCTS (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    OriginalPrice DECIMAL(18,2)
);

-- ======================================================
-- 1.DỮ LIỆU MẪU
-- ======================================================
INSERT INTO PRODUCTS (ProductID, ProductName, Category, OriginalPrice) VALUES
(1, 'iPhone 15', 'Electronics', 20000000),
(2, 'Samsung Refrigerator', 'Electronics', 15000000),
(3, 'Water Spinach', 'Food', 10000),
(4, 'Filtered Fresh Milk 4l', 'Food', 28000);

-- ======================================================
--  2.PHÂN TÍCH LOGIC
-- ======================================================

-- Lỗi trong đoạn code ban đầu:
-- UPDATE PRODUCTS
-- SET OriginalPrice = OriginalPrice * 0.9;

-- Nguyên nhân:
-- → Thiếu mệnh đề WHERE nên cập nhật toàn bộ bảng

-- Hậu quả:
-- → Tất cả sản phẩm đều bị giảm giá (sai nghiệp vụ)

-- Kết luận:
-- → Phải dùng WHERE để cập nhật đúng đối tượng (đúng người, đúng tội)

-- ======================================================
-- 3. CÂU LỆNH ĐÚNG (THEO YÊU CẦU MARKETING)
-- ======================================================

-- Đảm bảo chỉ cập nhật đúng sản phẩm thuộc ngành Electronics (đúng người, đúng tội)
UPDATE PRODUCTS
SET OriginalPrice = OriginalPrice * 0.9
WHERE Category = 'Electronics';

-- ======================================================
-- 4. KIỂM TRA KẾT QUẢ
-- ======================================================

SELECT * FROM PRODUCTS;