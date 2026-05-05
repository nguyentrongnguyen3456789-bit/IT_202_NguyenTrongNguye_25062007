-- Giai phap 1: Su dung OR
SELECT *
FROM orders
WHERE or_status = 'KHACH_HUY'
   OR or_status = 'QUAN_DONG_CUA'
   OR or_status = 'KHONG_CO_TAI_XE'
   OR or_status = 'BOM_HANG';

-- Giai phap 2: Su dung IN

SELECT *
FROM orders
WHERE or_status IN ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG');

-- Bang so sanh:
-- +---------------------+---------------------------+---------------------------+
-- | Tieu chi            | OR                        | IN                        |
-- +---------------------+---------------------------+---------------------------+
-- | Code sach           | Phai lap lai ten cot nhieu| Chi viet ten cot 1 lan    |
-- |                     | lan, them gia tri la them | them gia tri vao trong () |
-- |                     | 1 dong OR                 | la xong                   |
-- +---------------------+---------------------------+---------------------------+
-- | Mo rong (20 ly do)  | Rat dai, kho doc          | Chi them vao IN() la du   |
-- +---------------------+---------------------------+---------------------------+
-- | Hieu nang           | Chay tung dieu kien 1      | Engine xu ly nhu 1 tap    |
-- |                     | mot tu tren xuong duoi    | hop nen nhanh hon         |
-- +---------------------+---------------------------+---------------------------+

-- Xu ly bay: neu mang rong duoc gui xuong thi IN() se bi loi Syntax
-- vi MySQL khong chap nhan IN() khong co gia tri ben trong
-- => Backend can kiem tra truoc, neu mang rong thi khong gui query xuong
-- ma tra ve ket qua rong luon

-- Chon giai phap 2 vi ngan gon, de mo rong va hieu nang tot hon khi
-- danh sach nguyen nhan tang len nhieu
SELECT *
FROM orders
WHERE or_status IN ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG');