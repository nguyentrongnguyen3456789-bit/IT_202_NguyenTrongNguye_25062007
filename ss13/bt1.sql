DROP DATABASE IF EXISTS RikkeiClinicDB;
CREATE DATABASE RikkeiClinicDB;
USE RikkeiClinicDB;

-- =====================================================
-- PHẦN 1: KHỞI TẠO CẤU TRÚC BẢNG
-- =====================================================

-- 1. Bảng Bệnh nhân
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

-- 2. Bảng Nhân sự / Bác sĩ
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
);

-- 3. Bảng Khoa
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- 4. Bảng Giường bệnh
CREATE TABLE Beds (
    bed_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    patient_id INT NULL,

    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (patient_id)    REFERENCES Patients(patient_id)
);

-- 5. Bảng Lịch khám
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);

-- 6. Bảng Kho Vật tư
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- 7. Bảng Thuốc
CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 8. Bảng Công nợ
CREATE TABLE Patient_Invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2) NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 9. Bảng Sản phẩm
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 10. Bảng Dịch vụ
CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

-- 11. Bảng Ví điện tử
CREATE TABLE Wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 12. Bảng Lịch sử sử dụng dịch vụ
CREATE TABLE Service_Usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

-- =====================================================
-- PHẦN 2: DỮ LIỆU MẪU
-- =====================================================

-- Patients
INSERT INTO Patients VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

-- Employees
INSERT INTO Employees VALUES
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00),
(102, 'Dr. Lan Anh', 'Doctor', 25000.00),
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

-- Departments
INSERT INTO Departments VALUES
(1, 'Khoa Ngoai'),
(2, 'Khoa Noi'),
(3, 'Khoa ICU');

-- Beds
INSERT INTO Beds VALUES
(101, 1, 1),
(201, 2, NULL),
(301, 3, 2);

-- Appointments
INSERT INTO Appointments VALUES
(104, 1, 101, '2026-06-10 08:30:00', 'Pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'Completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');

-- Inventory
INSERT INTO Inventory VALUES
(10, 'Khau trang y te N95', 1000),
(11, 'Gang tay vo trung', 500),
(12, 'Dung dich sat khuan', 200);

-- Medicines
INSERT INTO Medicines VALUES
(1, 'Amoxicillin 500mg', 15000, 100),
(2, 'Panadol Extra', 5000, 5);

-- Invoices
INSERT INTO Patient_Invoices(patient_id, total_due) VALUES
(1, 1500000.00),
(2, 0),
(3, 0);

-- Products
INSERT INTO Products(name, price, stock) VALUES
('May do huyet ap Omron', 850000.00, 20),
('May do duong huyet', 450000.00, 15);

-- Services
INSERT INTO Services VALUES
(1, 'Sieu am o bung', 200000.00),
(2, 'Xet nghiem mau', 150000.00),
(3, 'Chup X-Quang', 250000.00);

-- Wallets
INSERT INTO Wallets VALUES
(1, 500000.00, 'Active'),
(2, 50000.00, 'Active'),
(3, 1000000.00, 'Inactive');

-- PHẦN 3: TRIGGER LỖI BAN ĐẦU

DELIMITER //
CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    -- LOGIC SAI:
    -- Đang kiểm tra ngày cũ thay vì ngày mới
    IF OLD.appointment_date < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Khong the dat lich kham vao thoi diem trong qua khu';
    END IF;
END //

DELIMITER ;
-- PHẦN 4: TÁI HIỆN LỖI

-- Tiếp tân lỡ dời lịch về quá khứ
UPDATE Appointments
SET appointment_date = '2025-01-10 08:30:00'
WHERE appointment_id = 104;

-- Kiểm tra dữ liệu sau khi lỗi xảy ra
SELECT * FROM Appointments;

-- PHẦN 5: PHÂN TÍCH LỖI


/*
OLD.appointment_date:
- Là ngày khám cũ trước khi UPDATE.

NEW.appointment_date:
- Là ngày khám mới sau khi UPDATE.

Trigger cũ kiểm tra OLD.appointment_date < NOW()
nên không kiểm tra giá trị mới mà người dùng nhập.

Vì vậy hệ thống vẫn cho phép cập nhật lịch khám
về thời điểm trong quá khứ.
*/

-- PHẦN 6: VÁ LỖ HỔNG

DROP TRIGGER IF EXISTS PreventPastAppointments;

DELIMITER //

CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN

    -- Kiểm tra ngày khám mới
    IF NEW.appointment_date < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi: Khong duoc doi lich kham ve thoi diem trong qua khu';
    END IF;

END //

DELIMITER ;


-- PHẦN 7: TEST SAU KHI SỬA


-- Test lỗi: phải bị chặn
UPDATE Appointments
SET appointment_date = '2024-01-01 09:00:00'
WHERE appointment_id = 104;

-- Kết quả mong đợi:
-- ERROR 1644 (45000):
-- Loi: Khong duoc doi lich kham ve thoi diem trong qua khu


-- Test đúng: cập nhật lịch tương lai
UPDATE Appointments
SET appointment_date = '2027-01-15 14:00:00'
WHERE appointment_id = 104;


SELECT * FROM Appointments;