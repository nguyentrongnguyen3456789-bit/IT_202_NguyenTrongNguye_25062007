-- 1. Xóa Procedure cũ nếu đã tồn tại
DROP PROCEDURE IF EXISTS AddInventory;

-- 2. Thay đổi Delimiter để định nghĩa khối lệnh
DELIMITER //

CREATE PROCEDURE AddInventory(
    IN p_item_id INT, 
    IN p_quantity INT
)
BEGIN
    -- Kiểm tra quy tắc: Số lượng nhập kho bắt buộc phải lớn hơn 0
    IF p_quantity > 0 THEN
        -- Thực hiện cập nhật nếu dữ liệu hợp lệ
        UPDATE Inventory
        SET stock_quantity = stock_quantity + p_quantity
        WHERE item_id = p_item_id;
    ELSE
        -- Chặn hành động và thông báo lỗi nếu nhập số âm hoặc bằng 0
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi: Số lượng vật tư nhập kho phải lớn hơn 0!';
    END IF;
END //

-- 3. Trả lại Delimiter mặc định
DELIMITER ;