-- Truy vấn lấy đúng 5 nhà hàng được thêm vào hệ thống gần đây nhất
SELECT restaurant_name, created_at
FROM Restaurants
-- Sắp xếp theo thời gian tạo giảm dần (Mới nhất nằm ở dòng số 1)
ORDER BY created_at DESC 
-- Sau khi đã có thứ tự từ mới đến cũ, lấy ra 5 bản ghi đầu tiên
LIMIT 5;