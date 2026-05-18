CREATE DATABASE IF NOT EXISTS bt2;
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
-- Theo em thì trường hợp này bị lỗi vì hệ thống có thể xóa giường cũ nhưng chưa kịp gán giường mới, làm dữ liệu bị thiếu
-- Vì việc chuyển giường gồm nhiều bước liên quan với nhau
-- nên cần đảm bảo cả 2 bước đều chạy xong thì dữ liệu mới đúng.
-- Nhưng ở đây hệ thống mới xóa bệnh nhân khỏi giường cũ
-- thì đã bị lỗi nên chưa cập nhật sang giường mới,
-- làm cho dữ liệu bị sai và bệnh nhân không có giường trong hệ thống.
DROP PROCEDURE IF EXISTS TransferBed;
DELIMITER //

CREATE PROCEDURE TransferBed(
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    DECLARE v_old_bed INT;
    DECLARE v_check INT DEFAULT 0;

    START TRANSACTION;

    -- tìm giường cũ
    SELECT bed_id
    INTO v_old_bed
    FROM Beds
    WHERE patient_id = p_patient_id
    LIMIT 1;
    
    IF v_old_bed IS NULL THEN
        ROLLBACK;
    ELSEIF v_old_bed = p_new_bed_id THEN
        ROLLBACK;
    ELSE
        -- kiểm tra giường mới có trống không
        SELECT COUNT(*)
        INTO v_check
        FROM Beds
        WHERE bed_id = p_new_bed_id
          AND patient_id IS NULL;

        IF v_check = 0 THEN
            ROLLBACK;
        ELSE
            -- giải phóng giường cũ
            UPDATE Beds  SET patient_id = NULL  WHERE bed_id = v_old_bed;
            -- xử lý gán giường mới
            UPDATE Beds SET patient_id = p_patient_id WHERE bed_id = p_new_bed_id;     
       COMMIT;
        END IF;
    END IF;

END //
DELIMITER ;
CALL TransferBed(1,201);
SELECT * FROM Beds;
