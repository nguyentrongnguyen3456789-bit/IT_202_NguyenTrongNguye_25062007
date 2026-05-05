-- Giai phap kien truc: dung CASE WHEN
-- CASE WHEN hoat dong nhu if-else, kiem tra tung dieu kien
-- tu tren xuong, gap dieu kien dung thi tra ve ket qua do
-- va tao ra cot ao Xep_Hang ngay trong qua trinh SELECT

-- Xu ly ngoai le NULL:
-- Khach hang moi dang ky chua co don nao => total_orders = NULL
-- NULL khong thoa man bat ky dieu kien nao (>, BETWEEN)
-- => CASE chay het ma khong co dieu kien nao dung
-- => Tu dong re vao ELSE, gan 'Bac' => an toan, khong loi bao cao

-- Code hoan chinh:
SELECT
    cus_name AS 'Ten_Khach_Hang',
    CASE
        WHEN total_orders > 500               THEN 'Kim Cuong'
        WHEN total_orders BETWEEN 100 AND 500 THEN 'Vang'
        ELSE 'Bac' -- bao gom ca total_orders < 100 lan NULL
    END AS 'Xep_Hang'
FROM customers;