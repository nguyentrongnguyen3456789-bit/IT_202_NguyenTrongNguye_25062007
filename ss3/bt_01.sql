CREATE DATABASE ss3_bt01;
USE ss3_bt01;

--  PHÂN TÍCH LỖI
-- Lỗi trong đoạn code:
-- UPDATE PRODUCTS
-- SET OriginalPrice = OriginalPrice * 0.9;

-- Nguyên nhân:
-- Thiếu mệnh đề WHERE nên câu lệnh UPDATE cập nhật toàn bộ bảng PRODUCTS

-- Hậu quả:
-- Tất cả sản phẩm đều bị giảm giá, không đúng yêu cầu nghiệp vụ

-- Kết luận:
-- Cần sử dụng WHERE để đảm bảo cập nhật đúng đối tượng

-- CÂU LỆNH ĐÚNG 
UPDATE PRODUCTS
SET OriginalPrice = OriginalPrice * 0.9
WHERE Category = 'Electronics';


