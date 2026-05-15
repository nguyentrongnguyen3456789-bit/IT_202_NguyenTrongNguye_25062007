DELIMITER //

CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(15),
    OUT p_total_debt DECIMAL(15,2),
    OUT p_message NVARCHAR(100)
)
BEGIN

    -- Reset giá trị ban đầu
    SET p_total_debt = NULL;

    -- Trường hợp không nhập gì
    IF p_patient_id IS NULL AND p_phone IS NULL THEN

        SET p_message = 'Lỗi: Vui lòng nhập ID hoặc Số điện thoại';

    ELSE

        -- Ưu tiên tìm theo ID
        IF p_patient_id IS NOT NULL THEN

            SELECT total_debt
            INTO p_total_debt
            FROM Patients
            WHERE patient_id = p_patient_id
            LIMIT 1;

        -- Nếu không có ID thì tìm theo phone
        ELSEIF p_phone IS NOT NULL THEN

            SELECT total_debt
            INTO p_total_debt
            FROM Patients
            WHERE phone = p_phone
            LIMIT 1;

        END IF;

        -- Kiểm tra kết quả sau truy vấn
        IF p_total_debt IS NULL THEN

            SET p_total_debt = 0;
            SET p_message = 'Không tìm thấy bệnh nhân trong hệ thống';

        ELSE

            SET p_message = 'Tìm thấy thông tin nợ';

        END IF;

    END IF;

END //

DELIMITER ;
