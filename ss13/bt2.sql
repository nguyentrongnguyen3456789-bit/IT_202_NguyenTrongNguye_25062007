CREATE DATABASE IF NOT EXISTS bt2;
USE bt2;

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(20)
);

-- Thêm dữ liệu mẫu
INSERT INTO Appointments (status) VALUES ('Pending'), ('Completed');

-- Thử cập nhật 
UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 1;

-- Xóa Trigger cũ nếu có
DROP TRIGGER IF EXISTS PreventStatusRevert;

-- Tạo Trigger mới
DELIMITER //
CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' AND NEW.status <> 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không được phép cập nhật lịch khám đã hoàn thành!';
    END IF;
END //
DELIMITER ;
