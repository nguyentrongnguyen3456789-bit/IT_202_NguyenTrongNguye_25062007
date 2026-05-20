CREATE DATABASE final_review;
USE final_review;

CREATE TABLE teams (
	team_id INT AUTO_INCREMENT PRIMARY KEY,
	team_name VARCHAR(100) NOT NULL,
	hq_country VARCHAR(50) NOT NULL,
	budget_cap DECIMAL(15,2) NOT NULL,
	current_rank INT DEFAULT 0
);

CREATE TABLE drivers (
	driver_id INT AUTO_INCREMENT PRIMARY KEY,
	full_name VARCHAR(100) NOT NULL,
	driver_number INT NOT NULL UNIQUE,
	nationality VARCHAR(50) NOT NULL,
	annual_salary DECIMAL(12,2) NOT NULL,
	team_id INT,
	FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE constructors_championship (
	championship_id INT AUTO_INCREMENT PRIMARY KEY,
	season_year YEAR NOT NULL,
	team_id INT,
	total_points DECIMAL(5,1) DEFAULT 0.0,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE races (
	race_id INT AUTO_INCREMENT PRIMARY KEY,
	race_name VARCHAR(100) NOT NULL,
	circuit_name VARCHAR(100) NOT NULL,
	race_date DATETIME NOT NULL,
	race_status VARCHAR(30) DEFAULT 'Scheduled'
);

CREATE TABLE race_results (
	result_id INT AUTO_INCREMENT PRIMARY KEY,
	driver_id INT,
	FOREIGN KEY (driver_id) REFERENCES drivers (driver_id),
	race_id INT,
	FOREIGN KEY (race_id) REFERENCES races (race_id),
	grid_position INT NOT NULL,
	finish_position INT,
	points_earned DECIMAL(4,1) DEFAULT 0.0,
	fastest_lap_speed DECIMAL(5,2) DEFAULT 0.00
);

INSERT INTO teams(team_name, hq_country, budget_cap, current_rank) VALUES
	('Red Bull Racing', 'Áo', '200000000', '1'),
	('Mercedes', 'Đức', '400000000', '2'),
	('Ferrari', 'Ý', '1000000', '3'),
	('McLaren', 'Anh', '30000000', '4'), 
	('Aston Martin', 'Anh', '25000000', '5');

INSERT INTO drivers(full_name, driver_number, nationality, annual_salary, team_id) VALUES
	('Max Verstappen', 'số 1', 'Hà Lan', '200000000', '1'),
	('Lewis Hamilton', 'số 44', 'Anh', '350000000', '2'),
	('Charles Leclerc', 'số 16' 'Monaco', '100000000', '3'),
	('Lando Norris', 'số 4', 'Anh', '60000000', '4'),
	('Fernando Alonso', 'số 14', 'Tây Ban Nha', '200000000', '5');

INSERT INTO constructors_championship (season_year, team_id, total_points) VALUES 
	(2026, 1, 280.0),
	(2026, 2, 210.0),
	(2026, 3, 195.0),
	(2026, 4, 180.0),
	(2026, 5, 120.0);
    
INSERT INTO races (race_name, circuit_name, race_date, race_status) VALUES 
	('Bahrain GP', 'Bahrain International Circuit', '2026-03-02 15:00:00', 'Finished'),
	('Monaco GP', 'Circuit de Monaco', '2026-05-25 14:00:00', 'Finished'),
	('Silverstone GP', 'Silverstone Circuit', '2026-07-06 14:00:00', 'Finished'),
	('Suzuka GP', 'Suzuka International Racing Course', '2026-09-21 13:00:00', 'Scheduled'),
	('Monza GP', 'Autodromo Nazionale Monza', '2026-09-07 13:00:00', 'Finished');

INSERT INTO race_results (driver_id, race_id, grid_position, finish_position, points_earned, fastest_lap_speed) VALUES
	(1, 1, 1, 1, 25.0, 242.5),
	(2, 1, 2, 2, 18.0, 239.8),
	(3, 1, 3, 3, 15.0, 238.1),
	(4, 1, 4, 4, 12.0, 237.5),
	(5, 1, 5, NULL, 0.0, 0.00),
-- Alonso bo cuoc chặng Bahrain
	(1, 2, 1, 1, 25.0, 241.0),
	(2, 2, 3, 2, 18.0, 238.5),
	(4, 2, 2, 3, 15.0, 237.9),
	(3, 2, 4, 25, 0.0, 235.0),
-- Leclerc vi tri 25 => ban ghi khong hop le, xoa o phan DELETE
	(5, 2, 5, 5, 10.0, 236.2);

SET SQL_SAFE_UPDATES = 0;

-- CÂU 2
-- tang 10% luong cho tay dua British co diem trung binh > 15
UPDATE drivers
SET annual_salary = annual_salary + (annual_salary * 0.1)
WHERE nationality = 'British'
  AND driver_id IN (
    SELECT driver_id
    FROM (
        SELECT driver_id
        FROM race_results
        GROUP BY driver_id
        HAVING AVG(points_earned) > 15
    ) AS du_lieu
);
-- Xóa các bản ghi kết quả đua có vị trí hoàn thành không hợp lệ (> 20)
DELETE FROM race_results
WHERE finish_position > 20;

-- PHẦN 3
-- Câu 1: Tìm tay đua có lương > 20,000,000 hoặc quốc tịch ('Dutch')
SELECT full_name, driver_number, nationality
FROM drivers
WHERE annual_salary > 20000000
OR nationality = 'Dutch';

-- Câu 2: Tìm đội đua hạng 1-3 có tên quốc gia bắt đầu bằng 'M' hoặc 'G'
SELECT team_name, hq_country
FROM teams
WHERE current_rank BETWEEN 1 AND 3
AND (hq_country LIKE 'M%' OR hq_country LIKE 'G%');

-- Câu 3: Lấy 2 chặng đua ở trang thứ 2 (Kích thước trang bằng 2 -> bỏ qua 2 dòng đầu)
SELECT race_id, race_name, race_date
FROM races
ORDER BY race_date DESC
LIMIT 2 OFFSET 2;

-- PHẦN 4
-- Câu 1: Thống kê thành tích tổng hợp của từng tay đua
SELECT d.full_name as 'Ho ten tay dua',
       t.team_name as 'Ten doi dua',
       SUM(rr.points_earned) as 'Tong diem',
       MAX(rr.fastest_lap_speed) as 'Toc do vong nhanh nhat'
FROM drivers as d, teams as t, race_results as rr
WHERE d.team_id = t.team_id
AND rr.driver_id = d.driver_id
GROUP BY d.driver_id, d.full_name, t.team_name;

-- Câu 2: Liệt kê các đội đua có tổng điểm của các tay đua gom lại lớn hơn 50
SELECT t.team_name as 'Ten doi dua',
       SUM(rr.points_earned) as 'Tong diem'
FROM teams as t, drivers as d, race_results as rr
WHERE t.team_id = d.team_id
AND rr.driver_id = d.driver_id
GROUP BY t.team_id, t.team_name
HAVING SUM(rr.points_earned) > 50;

-- Câu 3: Tìm tay đua có mức lương cao nhất hệ thống sử dụng Subquery
SELECT driver_id, full_name, annual_salary
FROM drivers
WHERE annual_salary = (SELECT MAX(annual_salary) FROM drivers);

-- PHẦN 5
-- Câu 1: Tạo Composite Index tối ưu tìm kiếm thứ hạng và điểm số cao
CREATE INDEX idx_driver_perf
ON race_results(finish_position, points_earned DESC);

-- Câu 2: Tạo View thống kê tài chính đội đua (bỏ qua tay đua thử nghiệm có lương = 0)
CREATE OR REPLACE VIEW view_team_financials AS
SELECT t.team_name as 'Ten doi dua',
       COUNT(d.driver_id) as 'Tong tay dua',
       SUM(d.annual_salary) as 'Tong quy luong'
FROM teams as t
LEFT JOIN drivers as d ON t.team_id = d.team_id
AND d.annual_salary > 0 -- khong tinh tay dua thu nghiem luong = 0
GROUP BY t.team_id, t.team_name;

SELECT * FROM view_team_financials;
-- PHẦN 6
-- CÂU 1: Thưởng 50,000 vào lương nếu tay đua đạt trên 25 điểm trong 1 trận đơn lẻ
DELIMITER //
CREATE TRIGGER trg_bonus_salary
AFTER INSERT ON race_results
FOR EACH ROW
BEGIN
    IF NEW.points_earned > 25 THEN
        UPDATE drivers
        SET annual_salary = annual_salary + 50000
        WHERE driver_id = NEW.driver_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_update_championship
AFTER UPDATE ON races
FOR EACH ROW
BEGIN
    IF NEW.race_status = 'Finished' AND OLD.race_status != 'Finished' THEN
        UPDATE constructors_championship
        SET total_points = total_points + 10
        WHERE team_id = (
            SELECT d.team_id
            FROM race_results as rr, drivers as d
            WHERE rr.driver_id = d.driver_id
              AND rr.race_id = NEW.race_id
              AND rr.finish_position = 1
        )
          AND season_year = YEAR(NEW.race_date);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE proc_evaluate_driver(IN p_driver_id INT)
BEGIN
    DECLARE tong_diem DECIMAL(10,1);

    SELECT SUM(points_earned) INTO tong_diem
    FROM race_results
    WHERE driver_id = p_driver_id;

    SELECT
        CASE
            WHEN tong_diem > 100 THEN 'World Champion Class'
            WHEN tong_diem BETWEEN 50 AND 100 THEN 'Podium Contender'
            ELSE 'Midfield Driver'
        END as 'Danh gia';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE proc_transfer_driver(IN p_driver_id INT, IN p_new_team_id INT)
BEGIN
    DECLARE old_team_id INT;
    DECLARE tong_luong DECIMAL(15,2);
    DECLARE ngan_sach DECIMAL(15,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    -- lay team cu cua tay dua
    SELECT team_id INTO old_team_id
    FROM drivers
    WHERE driver_id = p_driver_id;

    -- cap nhat sang doi moi
    UPDATE drivers
    SET team_id = p_new_team_id
    WHERE driver_id = p_driver_id;

    -- tao bang lich su chuyen nhuong neu chua co
    CREATE TABLE IF NOT EXISTS driver_transfer_history(
        transfer_id INT AUTO_INCREMENT PRIMARY KEY,
        driver_id INT,
        old_team_id INT,
        new_team_id INT,
        transfer_date DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    INSERT INTO driver_transfer_history (driver_id, old_team_id, new_team_id, transfer_date)
    VALUES (p_driver_id, old_team_id, p_new_team_id, NOW());

    -- kiem tra tong luong doi moi co vuot budget_cap khong
    SELECT SUM(d.annual_salary), t.budget_cap
    INTO tong_luong, ngan_sach
    FROM drivers as d, teams as t
    WHERE d.team_id = p_new_team_id
	AND t.team_id = p_new_team_id
    GROUP BY t.budget_cap;

    IF tong_luong > ngan_sach THEN
        ROLLBACK; 
    ELSE
        COMMIT;
    END IF;
END //
DELIMITER ;
    