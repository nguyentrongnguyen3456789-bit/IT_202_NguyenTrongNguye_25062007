CREATE DATABASE ss06_bai01;
USE ss06_bai01;

CREATE TABLE bookings (
	city VARCHAR(100) NOT NULL,
    total_price DECIMAL (18, 2) DEFAULT 0,
    b_status BIT (1) DEFAULT 0
);
    
INSERT INTO bookings VALUES
('Đà Nẵng', 5000000000, 1),
('Nha Trang', 3000000000, 1),
('Tiền Giang', 6000000000, 1);

SELECT city ,SUM(total_price) AS revenue
FROM bookings
WHERE b_status = 1 
GROUP BY city
HAVING SUM(total_price) > 0;

-- Bạn không thể dùng SUM() trong WHERE, vì:
-- WHERE lọc dữ liệu trước khi GROUP BY
-- SUM() là hàm tổng hợp → chỉ dùng sau khi GROUP BY