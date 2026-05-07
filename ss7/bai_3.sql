USE ss07;

-- =========================================================
-- TÌM "HỌC VIÊN NGỦ ĐÔNG" BẰNG NOT EXISTS
-- =========================================================

-- Yêu cầu:
-- Lấy danh sách Email của các học viên:
-- 1. Có tài khoản trong hệ thống
-- 2. Nhưng CHƯA TỪNG thanh toán khóa học nào trong năm 2024

-- Hệ thống có khoảng 5 triệu users
-- nên hiệu năng (Performance) là yếu tố cực kỳ quan trọng.


-- =========================================================
-- CUỘC TRANH LUẬN:
-- =========================================================

-- Dev A:
-- Dùng NOT IN

-- Dev B:
-- Dùng NOT EXISTS


-- =========================================================
-- TECH LEAD PHÂN TÍCH
-- =========================================================

-- Trong hệ thống lớn hàng triệu users
-- NOT EXISTS thường tối ưu hơn NOT IN.

-- Lý do nằm ở cơ chế:
-- "Short-circuit" (Dừng sớm)


-- =========================================================
-- SHORT-CIRCUIT CỦA EXISTS LÀ GÌ?
-- =========================================================

-- EXISTS chỉ cần kiểm tra:
-- "Có tồn tại ít nhất 1 dòng phù hợp hay không?"

-- Ngay khi tìm thấy dòng đầu tiên thỏa điều kiện
-- Database sẽ DỪNG kiểm tra ngay lập tức.

-- Đây gọi là:
-- Short-circuit evaluation.


-- =========================================================
-- VÍ DỤ THỰC TẾ
-- =========================================================

-- Giả sử student_id = 1001
-- có 500 giao dịch trong bảng Payments.

-- Với EXISTS:
-- DB chỉ cần thấy 1 payment trong năm 2024
-- là kết luận:
-- "User này đã mua khóa học"

-- => Dừng ngay.
-- Không cần quét tiếp 499 dòng còn lại.


-- =========================================================
-- TẠI SAO NOT IN CHẬM HƠN?
-- =========================================================

-- NOT IN thường phải:
-- 1. Tạo toàn bộ tập dữ liệu con
-- 2. So sánh từng giá trị
-- 3. Có thể quét rất nhiều dòng

-- Ngoài ra:
-- NOT IN còn gặp vấn đề với NULL.

-- Nếu subquery chứa NULL
-- kết quả có thể sai logic hoặc khó tối ưu.


-- =========================================================
-- KẾT LUẬN PERFORMANCE
-- =========================================================

-- Với Database 5 triệu users:
-- NOT EXISTS là lựa chọn tốt hơn vì:

-- 1. Có cơ chế dừng sớm (Short-circuit)
-- 2. Tối ưu tốt với Index
-- 3. Ít tốn bộ nhớ hơn
-- 4. Ổn định hơn khi dữ liệu lớn
-- 5. Không gặp vấn đề NULL như NOT IN

-- => Dev B chiến thắng.


-- =========================================================
-- CÂU SQL HOÀN CHỈNH
-- =========================================================

SELECT s.email
FROM Students s
WHERE NOT EXISTS (

    SELECT 1
    FROM Payments p

    WHERE p.student_id = s.id
      AND YEAR(p.payment_date) = 2024

);


-- =========================================================
-- GIẢI THÍCH QUERY
-- =========================================================

-- Query ngoài:
-- Quét toàn bộ Students.

-- Query trong:
-- Kiểm tra xem học viên đó
-- có payment nào trong năm 2024 hay không.

-- Nếu KHÔNG tồn tại payment:
-- => NOT EXISTS = TRUE
-- => Học viên được chọn.

-- Đây là:
-- Correlated Subquery
-- vì subquery có tham chiếu:
-- p.student_id = s.id

-- Nghĩa là:
-- mỗi dòng Students
-- sẽ chạy subquery tương ứng.


-- =========================================================
-- KẾT LUẬN
-- =========================================================

-- EXISTS/NOT EXISTS cực kỳ mạnh
-- trong các bài toán kiểm tra tồn tại dữ liệu.

-- Trên hệ thống lớn:
-- NOT EXISTS thường hiệu quả hơn NOT IN
-- nhờ cơ chế Short-circuit.