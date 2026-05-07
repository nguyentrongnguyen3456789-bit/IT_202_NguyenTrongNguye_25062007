USE ss07;

-- =========================================================
-- PHÂN TÍCH & SỬA LỖI DERIVED TABLE TRONG MYSQL
-- =========================================================

-- Yêu cầu:
-- Tính tổng số tiền hệ thống thu được
-- từ các học viên VIP
-- (những người có tổng chi tiêu > 10.000.000đ)


-- =========================================================
-- CÂU SQL BỊ LỖI
-- =========================================================

SELECT SUM(total_spent)
FROM (
    SELECT student_id,
           SUM(amount) AS total_spent
    FROM Payments
    GROUP BY student_id
    HAVING SUM(amount) > 10000000
);

-- =========================================================
-- GIẢI THÍCH LOGIC CÂU LỆNH
-- =========================================================

-- Subquery bên trong dùng để:
-- 1. Nhóm các khoản thanh toán theo student_id
-- 2. Tính tổng tiền mỗi học viên đã chi
-- 3. Lọc ra các học viên VIP
--    (tổng chi tiêu > 10 triệu)

-- Sau đó query bên ngoài:
-- SUM(total_spent)
-- sẽ cộng toàn bộ tiền của nhóm VIP
-- để tính doanh thu từ khách VIP.


-- =========================================================
-- NGUYÊN NHÂN MYSQL BÁO LỖI
-- =========================================================

-- MySQL báo lỗi:
-- "Every derived table must have its own alias"

-- Vì phần:

-- (
--    SELECT ...
-- )

-- trong FROM được gọi là:
-- Derived Table (bảng dẫn xuất).

-- Khi một subquery xuất hiện trong FROM
-- SQL sẽ xem nó như một bảng tạm thời.

-- Mà mọi bảng trong SQL đều phải có tên.

-- Nhưng Dev chưa đặt tên cho bảng tạm này
-- nên MySQL không biết gọi nó là gì
-- để xử lý dữ liệu tiếp theo.


-- =========================================================
-- CÁCH SỬA ĐÚNG
-- =========================================================

-- Chỉ cần đặt alias cho Derived Table.

-- Ví dụ:
-- AS vip_students


SELECT SUM(total_spent)
FROM (
    SELECT student_id,
           SUM(amount) AS total_spent
    FROM Payments
    GROUP BY student_id
    HAVING SUM(amount) > 10000000
) AS vip_students;


-- =========================================================
-- Ý NGHĨA SAU KHI SỬA
-- =========================================================

-- Bảng tạm "vip_students"
-- sẽ chứa danh sách học viên VIP
-- cùng tổng tiền họ đã chi tiêu.

-- Query ngoài sẽ cộng toàn bộ total_spent
-- để ra doanh thu từ nhóm VIP.


-- =========================================================
-- KẾT LUẬN
-- =========================================================

-- Subquery trong FROM được gọi là Derived Table.
-- Derived Table bắt buộc phải có alias.
-- Alias giúp MySQL nhận diện và xử lý bảng tạm.

-- Đây là lỗi cú pháp rất phổ biến
-- khi dùng subquery trong mệnh đề FROM.
