-- XÁC ĐỊNH ĐẦU VÀO - ĐẦU RA
-- Theo em thì procedure sẽ nhận:
-- mã bệnh nhân
-- mã thuốc
-- số lượng thuốc cần cấp
-- nên em sẽ dùng tham số 'IN' để truyền dữ liệu vào.
-- Còn phần thông báo kết quả như:
-- cấp phát thành công
-- hoặc báo lỗi hết thuốc
-- thì em sẽ dùng tham số 'OUT' để trả thông báo ra ngoài sau khi xử lý xong.

-- HƯỚNG GIẢI QUYẾT
-- Theo em bài này nên dùng transaction để tránh trường hợp dữ liệu bị lệch.
--  trường hợp xảy ra như thuốc đã bị trừ trong kho nhưng công nợ chưa cộng 
-- thì dữ liệu sẽ bị sai.
-- Nên em sẽ làm theo các bước:
-- kiểm tra tồn kho trước
-- nếu không đủ thuốc thì rollback và báo lỗi
-- còn nếu đủ thì trừ số lượng thuốc rồi cộng tiền vào công nợ
-- cuối cùng e sẽ commit dữ liệu


-- CODE thì e sẽ viết như sau

CREATE DATABASE PharmacyDB;
USE PharmacyDB;

CREATE TABLE Medicines(
    medicine_id INT PRIMARY KEY,
    medicine_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE Patient_Invoices(
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(10,2)
);

INSERT INTO Medicines
VALUES
(1,'Panadol',5000,5),
(2,'Amoxicillin',10000,20);

INSERT INTO Patient_Invoices
VALUES
(1,0),
(2,0);
DROP PROCEDURE IF EXISTS CapPhatThuoc;
DELIMITER //

CREATE PROCEDURE CapPhatThuoc(
    IN p_patient_id INT,
    IN p_medicine_id INT,
    IN p_quantity INT,
    OUT p_message VARCHAR(100)
)
BEGIN
	DECLARE v_stock INT;
    DECLARE v_price DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    START TRANSACTION;
    SELECT stock, price
    INTO v_stock, v_price
    FROM Medicines
    WHERE medicine_id = p_medicine_id;

    -- đây sẽ là logic để kiểm tra tồn kho
    IF p_quantity > v_stock THEN
        ROLLBACK;
        SET p_message = 'Loi: So luong ton kho khong du';
    ELSE

        -- đây là bước để xử lý trừ thuốc trong kho
        UPDATE Medicines
        SET stock = stock - p_quantity
        WHERE medicine_id = p_medicine_id;

        -- cộng tiền vào công nợ
        UPDATE Patient_Invoices
        SET total_due = total_due + (p_quantity * v_price)
        WHERE patient_id = p_patient_id;
        COMMIT;
        SET p_message = 'Da cap phat thanh cong';
    END IF;
END //
DELIMITER ;

-- tiếp theo e sẽ  KIỂM THỬ
-- Trường hợp nếu chạy đúng
CALL CapPhatThuoc(1,1,2,@msg);

SELECT @msg;

SELECT * FROM Medicines;

SELECT * FROM Patient_Invoices;

-- thì thuốc sẽ bị trừ kho,công nợ tăng lên,và hệ thống trả thông báo thành công.


-- Trường hợp nhập quá số lượng tồn kho sẽ báo lỗi
CALL CapPhatThuoc(1,1,10,@msg);

SELECT @msg;