USE ss07;
-- =========================================================
-- PHÂN TÍCH & SỬA LỖI SUBQUERY RETURNS MORE THAN 1 ROW
-- =========================================================

-- Yêu cầu:
-- Tìm tất cả khóa học có mức giá bằng với giá các khóa học
-- do giảng viên có instructor_id = 5 giảng dạy.


-- =========================================================
-- CÂU SQL BỊ LỖI
-- =========================================================

SELECT title, price
FROM Courses
WHERE price = (
    SELECT price
    FROM Courses
    WHERE instructor_id = 5
);

-- =========================================================
-- GIẢI THÍCH LỖI
-- =========================================================

-- Toán tử "=" chỉ dùng để so sánh với 1 giá trị duy nhất.

-- Hôm trước instructor_id = 5 chỉ có 1 khóa học
-- nên subquery trả về đúng 1 dòng.

-- Ví dụ:
-- 1000000

-- Khi đó câu lệnh sẽ tương đương:
-- WHERE price = 1000000

-- => Chạy bình thường.


-- =========================================================
-- NGUYÊN NHÂN HỆ THỐNG BỊ SẬP
-- =========================================================

-- Hôm nay giảng viên A mở thêm nhiều khóa học
-- với các mức giá khác nhau.

-- Subquery bây giờ trả về nhiều dòng:

-- 1000000
-- 1500000
-- 2000000

-- Trong khi "=" không thể so sánh với nhiều giá trị cùng lúc.

-- SQL không biết phải lấy giá nào để so sánh
-- nên báo lỗi:

-- "Subquery returns more than 1 row"


-- =========================================================
-- CÁCH SỬA ĐÚNG
-- =========================================================

-- Dùng IN thay cho "="
-- vì IN cho phép so sánh với nhiều giá trị.


SELECT title, price
FROM Courses
WHERE price IN (
    SELECT price
    FROM Courses
    WHERE instructor_id = 5
);


-- =========================================================
-- Ý NGHĨA CÂU SQL SAU KHI SỬA
-- =========================================================

-- Lấy tất cả khóa học
-- có price nằm trong danh sách giá
-- của giảng viên instructor_id = 5.

-- Dù giảng viên có 1 hay 100 khóa học
-- hệ thống vẫn hoạt động bình thường.


-- =========================================================
-- KẾT LUẬN
-- =========================================================

-- "="  -> chỉ dùng khi subquery trả về 1 dòng.
-- "IN" -> dùng khi subquery trả về nhiều dòng.

-- Đây là lỗi rất phổ biến khi dùng Subquery trong SQL.