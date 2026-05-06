USE ss06;
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT,
    room_name VARCHAR(50),
    price_per_night INT
);
INSERT INTO rooms (hotel_id, room_name, price_per_night) VALUES
(1, 'Standard', 500),
(1, 'Deluxe', 800),
(1, 'Suite', 1200),

(2, 'Single', 300),
(2, 'Double', 500),
(2, 'VIP', 1000),

(3, 'Basic', 200),
(3, 'Family', 700);

SELECT r.hotel_id, r.room_name, r.price_per_night
FROM rooms r
WHERE r.price_per_night = (
    SELECT MIN(price_per_night)
    FROM rooms
    WHERE hotel_id = r.hotel_id
);

-- GROUP BY hotel_id nhưng lại lấy thêm room_name (không nằm trong GROUP BY, cũng không dùng hàm tổng hợp)
-- Điều này gây ra:
-- MySQL có thể vẫn chạy (nếu không bật ONLY_FULL_GROUP_BY) nhưng room_name trả về sẽ ngẫu nhiên, không đảm bảo đúng phòng có giá thấp nhất