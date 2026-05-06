USE ss06;
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT,
    user_id INT,
    status VARCHAR(20), -- COMPLETED / CANCELLED / FAILED
    total_price INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO bookings (hotel_id, user_id, status, total_price) VALUES
-- Hotel 1 (đạt chuẩn)
(1, 1, 'COMPLETED', 4000000),
(1, 2, 'COMPLETED', 3500000),
(1, 3, 'COMPLETED', 4500000),
(1, 4, 'COMPLETED', 3200000),
(1, 5, 'COMPLETED', 5000000),

-- thêm nhiều dòng để đủ >=50 đơn
(1, 6, 'COMPLETED', 4000000),
(1, 7, 'COMPLETED', 4200000),

-- Hotel 2 (không đạt vì doanh thu thấp)
(2, 1, 'COMPLETED', 1000000),
(2, 2, 'COMPLETED', 1500000),
(2, 3, 'COMPLETED', 2000000),

-- Hotel 3 (nhiều đơn nhưng nhiều CANCELLED)
(3, 1, 'CANCELLED', 4000000),
(3, 2, 'FAILED', 5000000),
(3, 3, 'COMPLETED', 3500000);

SELECT hotel_id
FROM bookings
WHERE status = 'COMPLETED'
GROUP BY hotel_id
HAVING 
    COUNT(*) >= 50
    AND AVG(total_price) > 3000000;
    
-- WHERE → lọc sớm → tối ưu hiệu năng
-- GROUP BY → gom nhóm
-- HAVING → lọc sau khi tính toán
-- Luôn ưu tiên: lọc càng sớm càng tốt
