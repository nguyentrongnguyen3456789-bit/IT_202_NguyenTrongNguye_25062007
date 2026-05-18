-- PHÂN TÍCH VÀ ĐỀ XUẤT
--  Xác định đầu vào - đầu ra
-- Theo em thì procedure sẽ cần:
-- mã bệnh nhân
-- số tiền thanh toán
-- nên em sẽ dùng tham số IN để truyền dữ liệu vào.

-- Ngoài ra hệ thống cần trả thông báo như sau:
-- thanh toán thành công, số dư không đủ, dữ liệu không hợp lệ
-- nên em sẽ dùng thêm tham số OUT để trả thông báo ra ngoài.

--  Đề xuất 2 giải pháp

-- Chiến lược 1
-- Theo cách này thì hệ thống sẽ chạy thẳng các câu lệnh update
-- rồi dùng cơ chế bắt lỗi của database để rollback nếu có lỗi xảy ra.

-- theo em Ưu điểm là:
-- code ngắn
-- dễ viết

-- Nhược điểm:
-- không kiểm tra dữ liệu trước
-- có thể xảy ra trường hợp ví bị âm tiền
-- phụ thuộc nhiều vào lỗi hệ thống mới rollback

-- Chiến lược 2
-- -- Theo em thì cách này sẽ ổn hơn
-- Hệ thống sẽ:
-- lấy số dư ví trước
-- kiểm tra số tiền thanh toán có hợp lệ không
-- nếu dữ liệu sai thì rollback luôn
-- chỉ xử lý khi dữ liệu hợp lệ

-- Ưu điểm:
-- kiểm soát dữ liệu tốt hơn
-- tránh ví âm tiền
-- tránh cập nhật sai

-- Nhược điểm:
-- code dài hơn
-- phải kiểm tra nhiều điều kiện

--  So sánh và lựa chọn

-- Theo em thì nên chọn chiến lược 2
-- vì bài toán liên quan tới tiền nên cần ưu tiên an toàn dữ liệu hơn.

--  THIẾT KẾ VÀ TRIỂN KHAI

--  Thiết kế luồng xử lý

-- Theo em luồng xử lý sẽ như sau:
-- nhận mã bệnh nhân và số tiền thanh toán
-- kiểm tra số tiền có âm hay không
-- lấy số dư ví hiện tại
-- kiểm tra ví có đủ tiền không
-- nếu không hợp lệ thì rollback và báo lỗi
-- nếu hợp lệ thì:
-- trừ tiền trong ví
-- giảm công nợ
-- cuối cùng commit dữ liệu

DROP DATABASE bt4;
CREATE DATABASE bt4;
USE bt4;

CREATE TABLE Wallets(
    patient_id INT PRIMARY KEY,
    balance DECIMAL(10,2)
);

CREATE TABLE Patient_Invoices(
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(10,2)
);

INSERT INTO Wallets
VALUES
(1,500000),
(2,30000);

INSERT INTO Patient_Invoices
VALUES
(1,1000000),
(2,200000);

DROP PROCEDURE IF EXISTS PayHospitalFee;
DELIMITER //
CREATE PROCEDURE PayHospitalFee(
    IN p_patient_id INT,
    IN p_amount DECIMAL(10,2),
    OUT p_message VARCHAR(100)
)
BEGIN

    DECLARE v_balance DECIMAL(10,2);

    START TRANSACTION;

    -- 1. kiểm tra số tiền hợp lệ
   IF p_amount <= 0 THEN
    ROLLBACK;
    SET p_message = 'Loi: So tien khong hop le';

ELSEIF NOT EXISTS (
    SELECT 1 FROM Wallets WHERE patient_id = p_patient_id
) THEN
    ROLLBACK;
    SET p_message = 'Loi: Khong tim thay vi';

ELSE

    -- lấy số dư ví 
    SELECT balance
    INTO v_balance
    FROM Wallets
    WHERE patient_id = p_patient_id;

    IF v_balance < p_amount THEN
        ROLLBACK;
        SET p_message = 'Loi: So du khong du';

    ELSE
        UPDATE Wallets  SET balance = balance - p_amount  WHERE patient_id = p_patient_id;
        UPDATE Patient_Invoices  SET total_due = total_due - p_amount  WHERE patient_id = p_patient_id;
        COMMIT;
        SET p_message = 'Thanh toan thanh cong';
    END IF;
END IF;
END //
DELIMITER ;

-- tiến hành kiểm thử
-- trường hợp 1: giao dịch hợp lệ
CALL PayHospitalFee(1,200000,@msg);

SELECT @msg;

SELECT * FROM Wallets;

SELECT * FROM Patient_Invoices;
-- trường hợp 2: số dư không đủ
CALL PayHospitalFee(2,100000,@msg);

SELECT @msg;

-- kết quả sẽ hiển thị ra là:
-- không update dữ liệu
-- báo lỗi số dư không đủ

-- trường hợp 3: truyền số âm
CALL PayHospitalFee(1,-50000,@msg);

SELECT @msg;

-- kết quả sẽ hiện ra là:
-- rollback dữ liệu
-- báo lỗi số tiền không hợp lệ
