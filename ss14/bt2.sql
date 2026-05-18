CREATE DATABASE bt2;
USE bt2;

CREATE TABLE Beds(
    bed_id INT PRIMARY KEY,
    patient_id INT
);

INSERT INTO Beds
VALUES
(101,1),
(201,NULL),
(301,2);
-- Theo em thì trường hợp này đang vi phạm tính Atomicity trong transaction
-- Vì việc chuyển giường gồm nhiều bước liên quan với nhau
-- nên phải thực hiện đầy đủ.
-- Nhưng ở đây hệ thống mới xóa bệnh nhân khỏi giường cũ
-- thì đã bị lỗi nên chưa cập nhật sang giường mới,
-- làm cho dữ liệu bị sai và bệnh nhân không có giường trong hệ thống.
DROP PROCEDURE IF EXISTS TransferBed;

DELIMITER //

CREATE PROCEDURE TransferBed(IN p_patient_id INT,IN p_new_bed_id INT)
BEGIN
    START TRANSACTION;
		UPDATE Beds SET patient_id = NULL   WHERE patient_id = p_patient_id;
		UPDATE Beds SET patient_id = p_patient_id    WHERE bed_id = p_new_bed_id;
    COMMIT;
END //
DELIMITER ;

CALL TransferBed(1,201);
SELECT * FROM Beds;
