DELIMITER //

CREATE PROCEDURE GetPatientDebt(
    IN p_patient_id INT,
    IN p_phone VARCHAR(15),
    OUT p_total_debt DECIMAL(15,2),
    OUT p_message NVARCHAR(100)
)
BEGIN
    -- Mặc định gán nợ bằng 0
    SET p_total_debt = 0;

    -- Kịch bản 1: Chặn trường hợp để trống cả hai
    IF p_patient_id IS NULL AND p_phone IS NULL THEN
        SET p_message = 'Lỗi: Vui lòng nhập ID hoặc Số điện thoại để tra cứu';
    
    ELSE
        -- Truy vấn lấy dữ liệu nợ
        SELECT total_debt INTO p_total_debt
        FROM Patients
        WHERE (p_patient_id IS NOT NULL AND patient_id = p_patient_id)
           OR (p_patient_id IS NULL AND p_phone IS NOT NULL AND phone = p_phone)
        LIMIT 1;

        -- Kịch bản 2: Kiểm tra kết quả sau truy vấn
        IF p_total_debt IS NOT NULL THEN
            SET p_message = 'Tìm thấy thông tin nợ';
        ELSE
            SET p_total_debt = 0;
            SET p_message = 'Không tìm thấy bệnh nhân trong hệ thống';
        END IF;
    END IF;
END //

DELIMITER ;