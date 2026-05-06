USE ss06;

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    hotel_id INT,
    status VARCHAR(20), -- SUCCESS / CANCELLED
    total_price INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO bookings (user_id, hotel_id, status, total_price) VALUES
-- User 1 (bình thường)
(1, 101, 'SUCCESS', 500),
(1, 101, 'SUCCESS', 600),
(1, 102, 'CANCELLED', 400),

(2, 101, 'CANCELLED', 500),
(2, 101, 'CANCELLED', 500),
(2, 101, 'CANCELLED', 500),
(2, 101, 'CANCELLED', 500),
(2, 101, 'CANCELLED', 500),
(2, 102, 'CANCELLED', 500),
(2, 102, 'SUCCESS', 700),
(2, 102, 'SUCCESS', 800),
(2, 103, 'SUCCESS', 900),
(2, 103, 'SUCCESS', 1000),

(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'SUCCESS', 400),
(3, 101, 'CANCELLED', 400);

SELECT user_id
FROM bookings
GROUP BY user_id
HAVING 
    COUNT(*) >= 10
    AND SUM(CASE 
                WHEN status = 'CANCELLED' THEN 1 
                ELSE 0 
            END) > 5;