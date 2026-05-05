CREATE DATABASE btl;
USE btl;

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL,
    age_restriction INT DEFAULT 0 CHECK (age_restriction IN (0,13,16,18))
);

CREATE TABLE rooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    max_seats INT NOT NULL,
    status VARCHAR(20) DEFAULT 'active' 
        CHECK (status IN ('active', 'maintenance'))
);

CREATE TABLE showtimes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT NOT NULL,
    room_id INT NOT NULL,
    show_time DATETIME NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL CHECK (ticket_price >= 0),

    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);


CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    showtime_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (showtime_id) REFERENCES showtimes(id)
);
INSERT INTO movies (title, duration_minutes, age_restriction) VALUES
('Avengers: Secret Wars', 150, 13),
('Dune: Part Two', 166, 13),
('Conan Movie 27', 110, 0),
('The Nun 2', 120, 18);

INSERT INTO rooms (name, max_seats, status) VALUES
('Phòng 1', 100, 'active'),
('Phòng 2', 80, 'active'),
('Phòng 3', 120, 'maintenance');

INSERT INTO showtimes (movie_id, room_id, show_time, ticket_price) VALUES
(1, 1, '2026-05-01 09:00:00', 90000),
(2, 2, '2026-05-01 10:00:00', 100000),
(3, 1, '2026-05-01 13:00:00', 80000),
(4, 2, '2026-05-01 15:00:00', 95000),
(1, 1, '2026-05-01 18:00:00', 120000);

INSERT INTO bookings (showtime_id, customer_name, phone) VALUES
(1, 'Nguyễn Văn A', '0901111111'),
(1, 'Trần Thị B', '0902222222'),
(2, 'Lê Văn C', '0903333333'),
(2, 'Phạm Thị D', '0904444444'),
(3, 'Hoàng Văn E', '0905555555'),
(3, 'Đỗ Thị F', '0906666666'),
(4, 'Vũ Văn G', '0907777777'),
(4, 'Bùi Thị H', '0908888888'),
(5, 'Ngô Văn I', '0909999999'),
(5, 'Lý Thị K', '0900000000');

UPDATE rooms
SET status = 'maintenance'
WHERE id = 1;

UPDATE showtimes
SET room_id = 2
WHERE room_id = 1;

DELETE FROM bookings
WHERE phone = '0987654321';

DELETE FROM bookings
WHERE showtime_id IN (
    SELECT id FROM showtimes WHERE movie_id = 3
);

DELETE FROM showtimes
WHERE movie_id = 3;

DELETE FROM movies
WHERE id = 3;