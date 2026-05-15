CREATE DATABASE IF NOT EXISTS bt4;
USE bt4;
-- Bảng Appointments
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    appointment_time DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL
);
INSERT INTO Appointments (doctor_id, appointment_time, status)
VALUES 
(1, '2026-05-16 09:00:00', 'Pending'),  
(1, '2026-05-16 10:00:00', 'Cancelled'), 
(2, '2026-05-16 09:00:00', 'Pending'); 

-- Trigger chống trùng khi INSERT
DELIMITER //
CREATE TRIGGER PreventDoubleBooking_Insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Appointments
        WHERE doctor_id = NEW.doctor_id
          AND appointment_time = NEW.appointment_time
          AND status <> 'Cancelled'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
    END IF;
END //
DELIMITER ;

-- Trigger chống trùng khi UPDATE
DELIMITER //
CREATE TRIGGER PreventDoubleBooking_Update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Appointments
        WHERE doctor_id = NEW.doctor_id
          AND appointment_time = NEW.appointment_time
          AND status <> 'Cancelled'
          AND appointment_id <> OLD.appointment_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này';
    END IF;
END //
DELIMITER ;

-- KIỂM THỬ 4 TRƯỜNG HỢP


-- 1. Lịch mới đưa vào khung giờ trống → Thành công
INSERT INTO Appointments (doctor_id, appointment_time, status)
VALUES (1, '2026-05-16 09:00:00', 'Pending');

-- 2. Lịch mới đưa vào khung giờ đang có ca 'Pending' → Bị chặn
INSERT INTO Appointments (doctor_id, appointment_time, status)
VALUES (1, '2026-05-16 09:00:00', 'Pending');
-- Báo lỗi: "Lỗi: Bác sĩ đã có lịch hẹn vào khung giờ này"

-- 3. Lịch mới đưa vào khung giờ đang có ca 'Cancelled' → Thành công
INSERT INTO Appointments (doctor_id, appointment_time, status)
VALUES (1, '2026-05-16 10:00:00', 'Cancelled');

INSERT INTO Appointments (doctor_id, appointment_time, status)
VALUES (1, '2026-05-16 10:00:00', 'Pending');
-- Thành công vì ca cũ đã Cancelled

-- 4. Cập nhật trạng thái một ca khám từ 'Pending' sang 'Completed' → Thành công
UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 1;
-- Thành công, không bị nhận diện nhầm là trùng với chính nó


SELECT * FROM Appointments;
