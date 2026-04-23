CREATE DATABASE IF NOT EXISTS ss3_bt05;
USE ss3_bt05;
SET SQL_SAFE_UPDATES = 0;
-- ======================================================
-- 1. TẠO BẢNG
-- ======================================================
CREATE TABLE IF NOT EXISTS CART_ITEMS (
    CartItemID INT PRIMARY KEY AUTO_INCREMENT,
    CartID INT,
    ProductID INT,
    Quantity INT,
    AddedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- 2. EDGE CASE (BẪY DỮ LIỆU)
-- ======================================================

-- ❗ Case 1: Quantity âm hoặc = 0
-- → Không hợp lệ → KHÔNG cho INSERT/UPDATE

-- ❗ Case 2: Sản phẩm đã tồn tại trong giỏ
-- → Không INSERT mới → UPDATE số lượng

-- ======================================================
-- 3. ADD TO CART
-- ======================================================

-- Bước 1: kiểm tra đã tồn tại chưa
SELECT *
FROM CART_ITEMS
WHERE CartID = 1 AND ProductID = 101;

-- Nếu chưa có → INSERT
INSERT INTO CART_ITEMS (CartID, ProductID, Quantity)
SELECT 1, 101, 1
WHERE NOT EXISTS (
    SELECT 1 FROM CART_ITEMS 
    WHERE CartID = 1 AND ProductID = 101
);

-- Nếu đã có → UPDATE tăng số lượng
UPDATE CART_ITEMS
SET Quantity = Quantity + 1
WHERE CartID = 1 AND ProductID = 101;

-- ======================================================
-- 4. VIEW CART
-- ======================================================

SELECT *
FROM CART_ITEMS
WHERE CartID = 1;

-- ======================================================
-- 5. UPDATE QUANTITY
-- ======================================================

-- Chỉ update khi Quantity > 0
UPDATE CART_ITEMS
SET Quantity = 5
WHERE CartID = 1 
  AND ProductID = 101
  AND 5 > 0;

-- ======================================================
-- 6. REMOVE ITEM
-- ======================================================

DELETE FROM CART_ITEMS
WHERE CartID = 1 AND ProductID = 101;

-- ======================================================
-- KẾT LUẬN
-- ======================================================

-- + Đã xử lý edge case (quantity âm, trùng sản phẩm)
-- + Đủ 4 lệnh DML: INSERT, SELECT, UPDATE, DELETE
-- + Có WHERE CartID → đảm bảo không ảnh hưởng giỏ người khác