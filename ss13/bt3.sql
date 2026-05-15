CREATE DATABASE IF NOT EXISTS bt3;
USE bt3;

-- Bảng log lưu biến động giá
CREATE TABLE Price_Changes_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    old_price DECIMAL(15,2) NOT NULL,
    new_price DECIMAL(15,2) NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    difference DECIMAL(15,2) NOT NULL,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Medicines
CREATE TABLE Medicines (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(15,2) NOT NULL,
    stock INT DEFAULT 0
);

-- Thêm dữ liệu mẫu với đúng ID để kiểm thử
INSERT INTO Medicines (medicine_id, name, price, stock)
VALUES (101, 'Thuốc A', 50000, 100),
       (102, 'Thuốc B', 30000, 50);

-- Tạo Trigger kiểm soát biến động giá
DELIMITER //
CREATE TRIGGER TrackPriceChanges
AFTER UPDATE ON Medicines
FOR EACH ROW
BEGIN
    -- Chặn giá mới <= 0
    IF NEW.price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá thuốc mới không hợp lệ';
    END IF;

    -- Nếu giá thay đổi thì mới ghi log
    IF NEW.price <> OLD.price THEN
        IF NEW.price > OLD.price THEN
            INSERT INTO Price_Changes_Log(medicine_id, old_price, new_price, change_type, difference)
            VALUES (OLD.medicine_id, OLD.price, NEW.price, 'TĂNG GIÁ', NEW.price - OLD.price);
        ELSE
            INSERT INTO Price_Changes_Log(medicine_id, old_price, new_price, change_type, difference)
            VALUES (OLD.medicine_id, OLD.price, NEW.price, 'GIẢM GIÁ', OLD.price - NEW.price);
        END IF;
    END IF;
END //
DELIMITER ;


-- KIỂM THỬ 4 TRƯỜNG HỢP


-- 1. Tăng giá hợp lệ
UPDATE Medicines
SET price = 60000
WHERE medicine_id = 101;

-- 2. Giảm giá hợp lệ
UPDATE Medicines
SET price = 45000
WHERE medicine_id = 101;

-- 3. Cập nhật tồn kho (giá không đổi)
UPDATE Medicines
SET stock = 120
WHERE medicine_id = 101;

-- 4. Giá mới âm (bị chặn)
UPDATE Medicines
SET price = -5000
WHERE medicine_id = 101;

-- Kiểm tra log
SELECT * FROM Price_Changes_Log;
