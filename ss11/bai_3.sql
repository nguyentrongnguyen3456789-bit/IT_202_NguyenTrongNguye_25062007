DELIMITER //

CREATE PROCEDURE CalculateHospitalFee(
    IN p_total_cost DECIMAL(15,2),
    IN p_patient_type VARCHAR(20),
    OUT p_final_amount DECIMAL(15,2),
    OUT p_message NVARCHAR(100)
)
BEGIN
    -- Kiểm tra chi phí âm
    IF p_total_cost < 0 THEN
        SET p_final_amount = 0;
        SET p_message = 'Lỗi: Chi phí không hợp lệ';
    ELSE
        -- Tính toán theo diện bệnh nhân
        CASE p_patient_type
            WHEN 'BHYT' THEN 
                SET p_final_amount = p_total_cost * 0.2; -- Đóng 20%
            WHEN 'VIP' THEN 
                SET p_final_amount = p_total_cost * 0.9; -- Giảm 10%
            WHEN 'THUONG' THEN 
                SET p_final_amount = p_total_cost;       -- Đóng 100%
            ELSE 
                SET p_final_amount = p_total_cost;
        END CASE;
        
        SET p_message = 'Đã tính toán xong';
    END IF;
END //

DELIMITER ;