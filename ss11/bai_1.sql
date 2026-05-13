-- =========================================================
-- HỆ THỐNG PHÒNG KHÁM ĐA KHOA
-- XỬ LÝ LỖI STORED PROCEDURE HỦY LỊCH HẸN
-- =========================================================


-- =========================================================
-- PHẦN A: PHÂN TÍCH LỖI HỆ THỐNG
-- =========================================================

-- ---------------------------------------------------------
-- 1. Kiểm tra dữ liệu hiện tại
-- ---------------------------------------------------------

SELECT * 
FROM Appointments;


-- ---------------------------------------------------------
-- 2. Tái hiện lỗi hệ thống
-- ---------------------------------------------------------
-- Giả sử lịch hẹn có appointment_id = 5
-- đang ở trạng thái 'Completed'
--
-- Theo nghiệp vụ:
-- Lịch đã khám xong KHÔNG được phép hủy
--
-- Tuy nhiên procedure hiện tại vẫn cho phép hủy
-- nên khi gọi lệnh dưới đây sẽ xảy ra lỗi logic
-- ---------------------------------------------------------

CALL CancelAppointment(5);


-- ---------------------------------------------------------
-- 3. Kiểm tra lại dữ liệu sau khi gọi procedure
-- ---------------------------------------------------------
-- Kết quả sai:
-- status của lịch khám bị đổi thành 'Cancelled'
-- dù trước đó là 'Completed'
-- ---------------------------------------------------------

SELECT * 
FROM Appointments
WHERE appointment_id = 5;


-- ---------------------------------------------------------
-- 4. Giải thích nguyên nhân lỗi
-- ---------------------------------------------------------
-- Procedure cũ chỉ kiểm tra appointment_id
-- mà không kiểm tra trạng thái lịch khám.
--
-- Vì vậy mọi lịch hẹn đều có thể bị cập nhật
-- sang trạng thái 'Cancelled'
--
-- Điều này gây sai lệch dữ liệu:
-- - Lịch đã khám vẫn bị hủy
-- - Ảnh hưởng thống kê doanh thu
-- - Sai dữ liệu chốt sổ kế toán
-- ---------------------------------------------------------



-- =========================================================
-- PHẦN B: SỬA LỖI STORED PROCEDURE
-- =========================================================

-- ---------------------------------------------------------
-- 1. Xóa procedure cũ bị lỗi
-- ---------------------------------------------------------

DROP PROCEDURE IF EXISTS CancelAppointment;



-- ---------------------------------------------------------
-- 2. Tạo lại procedure đúng logic nghiệp vụ
-- ---------------------------------------------------------
-- Quy tắc mới:
-- Chỉ cho phép hủy lịch khám có trạng thái:
-- 'Pending'
--
-- Các trạng thái khác như:
-- 'Completed'
-- 'Cancelled'
-- 'In Progress'
-- sẽ không được phép hủy
-- ---------------------------------------------------------

DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)

BEGIN

    -- Cập nhật trạng thái thành 'Cancelled'
    -- CHỈ KHI lịch khám đang ở trạng thái 'Pending'

    UPDATE Appointments
    SET status = 'Cancelled'
    WHERE appointment_id = p_appointment_id
    AND status = 'Pending';

END //

DELIMITER ;



-- =========================================================
-- PHẦN C: KIỂM THỬ SAU KHI SỬA
-- =========================================================

-- ---------------------------------------------------------
-- 1. Thử hủy lịch đã hoàn tất
-- ---------------------------------------------------------
-- Kết quả mong muốn:
-- KHÔNG có dòng nào bị cập nhật
-- ---------------------------------------------------------

CALL CancelAppointment(5);



-- ---------------------------------------------------------
-- 2. Kiểm tra lại dữ liệu
-- ---------------------------------------------------------
-- Status vẫn giữ nguyên là 'Completed'
-- => Logic đã hoạt động đúng
-- ---------------------------------------------------------

SELECT *
FROM Appointments
WHERE appointment_id = 5;



-- ---------------------------------------------------------
-- 3. Thử với lịch đang 'Pending'
-- ---------------------------------------------------------
-- Ví dụ appointment_id = 2
-- ---------------------------------------------------------

CALL CancelAppointment(2);



-- ---------------------------------------------------------
-- 4. Kiểm tra kết quả
-- ---------------------------------------------------------
-- Status sẽ đổi từ:
-- 'Pending' -> 'Cancelled'
-- ---------------------------------------------------------

SELECT *
FROM Appointments
WHERE appointment_id = 2;



-- =========================================================
-- KẾT LUẬN
-- =========================================================
-- Đã sửa thành công lỗi logic của Stored Procedure.
--
-- Hệ thống hiện chỉ cho phép hủy:
-- -> các lịch khám đang chờ ('Pending')
--
-- Giúp:
-- - Đảm bảo tính chính xác dữ liệu
-- - Tránh sai lệch doanh thu
-- - Đúng quy trình nghiệp vụ phòng khám
-- =========================================================