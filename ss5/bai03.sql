SELECT driver_id, driver_name, status, trust_score, distance_km
FROM Drivers
-- ĐIỀU KIỆN 1: Tài xế phải đang ở trạng thái sẵn sàng
WHERE status = 'AVAILABLE' AND trust_score >= 80 
-- ĐIỀU KIỆN 2: Điểm tín nhiệm phải từ 80 trở lên (Hoặc theo biến min_trust_score)
ORDER BY distance_km ASC,
-- ƯU TIÊN 1: Tài xế ở gần quán nhất (Tăng dần
-- ƯU TIÊN 2: Nếu cùng khoảng cách, ai có điểm tín nhiệm cao hơn sẽ xếp trên (Giảm dần)
    trust_score DESC;