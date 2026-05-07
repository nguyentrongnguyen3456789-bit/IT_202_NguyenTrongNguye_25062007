-- =========================================================
-- PHÂN TÍCH LỖI NOT IN + NULL TRONG MYSQL
-- =========================================================

-- Yêu cầu:
-- Lấy danh sách các khóa học (Courses)
-- CHƯA TỪNG có ai đăng ký
-- để Marketing chạy chương trình sale.


-- =========================================================
-- CÂU SQL BAN ĐẦU
-- =========================================================

SELECT *
FROM Courses
WHERE id NOT IN (
    SELECT course_id
    FROM Enrollments
);


-- =========================================================
-- SỰ CỐ THỰC TẾ
-- =========================================================

-- Hệ thống bị lỗi mạng
-- sinh ra dữ liệu rác trong bảng Enrollments.

-- Một số dòng có:
-- course_id = NULL

-- Kết quả:
-- Query trên trả về:
-- 0 dòng dữ liệu.


-- =========================================================
-- PHÂN TÍCH BOOLEAN LOGIC
-- =========================================================

-- Giả sử subquery trả về:

-- (1, 2, NULL)

-- Khi đó câu SQL sẽ tương đương:

-- WHERE id NOT IN (1, 2, NULL)

-- MySQL sẽ hiểu là:

-- id <> 1
-- AND id <> 2
-- AND id <> NULL


-- =========================================================
-- VẤN ĐỀ NẰM Ở:
-- =========================================================

-- So sánh với NULL:

-- id <> NULL

-- KHÔNG trả về TRUE/FALSE
-- mà trả về:
-- UNKNOWN

-- Trong SQL:
-- TRUE AND TRUE AND UNKNOWN
-- => UNKNOWN

-- WHERE chỉ lấy các dòng có TRUE.
-- UNKNOWN sẽ bị loại bỏ.

-- Kết quả:
-- toàn bộ query trả về rỗng.


-- =========================================================
-- TẠI SAO NOT IN NGUY HIỂM?
-- =========================================================

-- NOT IN rất nhạy cảm với NULL.

-- Chỉ cần subquery chứa 1 NULL
-- là toàn bộ phép so sánh có thể sập logic.


-- =========================================================
-- GIẢI PHÁP KIẾN TRÚC
-- =========================================================

-- Vá lỗi ngay trong subquery:
-- loại bỏ NULL trước khi so sánh.


SELECT *
FROM Courses
WHERE id NOT IN (

    SELECT course_id
    FROM Enrollments
    WHERE course_id IS NOT NULL

);


-- =========================================================
-- GIẢI PHÁP TỐT HƠN (KHUYẾN NGHỊ)
-- =========================================================

-- Dùng NOT EXISTS
-- vì NOT EXISTS an toàn với NULL.

-- Đồng thời tối ưu hơn
-- trong các hệ thống dữ liệu lớn.


SELECT *
FROM Courses c
WHERE NOT EXISTS (

    SELECT 1
    FROM Enrollments e
    WHERE e.course_id = c.id

);


-- =========================================================
-- GIẢI THÍCH NOT EXISTS
-- =========================================================

-- Query ngoài:
-- quét toàn bộ Courses.

-- Query trong:
-- kiểm tra xem course hiện tại
-- có tồn tại trong Enrollments hay không.

-- Nếu KHÔNG tồn tại:
-- => NOT EXISTS = TRUE
-- => khóa học được chọn.


-- =========================================================
-- TẠI SAO NOT EXISTS AN TOÀN HƠN?
-- =========================================================

-- EXISTS chỉ kiểm tra:
-- "Có tồn tại dòng phù hợp không?"

-- Nó không so sánh trực tiếp với NULL
-- như NOT IN.

-- Vì vậy:
-- NULL không phá hỏng logic query.


-- =========================================================
-- KẾT LUẬN
-- =========================================================

-- NOT IN + NULL
-- là lỗi cực kỳ phổ biến trong SQL.

-- Chỉ cần subquery chứa NULL
-- toàn bộ query có thể trả về rỗng.

-- Cách xử lý:
-- 1. Lọc NULL trong subquery
-- HOẶC
-- 2. Dùng NOT EXISTS để an toàn hơn.