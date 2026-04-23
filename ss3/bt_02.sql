CREATE DATABASE IF NOT EXISTS ss3_bt02;
USE ss3_bt02;

CREATE TABLE IF NOT EXISTS SHIPPERS (
    ShipperID INT PRIMARY KEY AUTO_INCREMENT,
    ShipperName VARCHAR(255),
    Phone VARCHAR(20)
);


-- 2. PHÂN TÍCH LỖI


-- Lỗi 1: Sai dấu nháy → Syntax Error
-- Lỗi 2: Không chỉ định cột → thiếu dữ liệu (Phone bị NULL)


-- 3. CÂU LỆNH ĐÚNG


INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Giao Hang Nhanh', '0901234567');

INSERT INTO SHIPPERS (ShipperName, Phone)
VALUES ('Viettel Post', '0987654321');

SELECT * FROM SHIPPERS;