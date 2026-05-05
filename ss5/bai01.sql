SELECT restaurant_name, address, rating
FROM Restaurants

 -- SỬA LỖI: Dùng ngoặc đơn để ưu tiên nhóm điều kiện khu vực (Quận 1 HOẶC Quận 3)
WHERE (district = 'Quận 1' OR district = 'Quận 3') 
    -- Sau đó mới xét điều kiện rating lớn hơn 4.0 cho cả hai khu vực trên
    AND rating > 4.0; 

