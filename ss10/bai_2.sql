CREATE DATABASE Hospital_Index_Test;
USE Hospital_Index_Test;

CREATE TABLE Patients (
    Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Phone VARCHAR(20),
    Age INT,
    Address VARCHAR(255)
);

DELIMITER //

CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 500000 DO

        INSERT INTO Patients(Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('Patient ', i),
            CONCAT('090', LPAD(i,7,'0')),
            FLOOR(RAND() * 100),
            'Ho Chi Minh City'
        );

        SET i = i + 1;

    END WHILE;

END //

DELIMITER ;

CALL SeedPatients();

SELECT COUNT(*) FROM Patients;

EXPLAIN
SELECT *
FROM Patients
WHERE Phone = '0900001000';

SELECT *
FROM Patients
WHERE Phone = '0900001000';

CREATE INDEX idx_phone
ON Patients(Phone);

EXPLAIN
SELECT *
FROM Patients
WHERE Phone = '0900001000';

SELECT *
FROM Patients
WHERE Phone = '0900001000';

DROP PROCEDURE IF EXISTS InsertTestWithoutIndex;

DELIMITER //

CREATE PROCEDURE InsertTestWithoutIndex()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 1000 DO

        INSERT INTO Patients(Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('New Patient ', i),
            CONCAT('099', LPAD(i,7,'0')),
            FLOOR(RAND() * 100),
            'Ha Noi'
        );

        SET i = i + 1;

    END WHILE;

END //

DELIMITER ;

DROP INDEX idx_phone ON Patients;

CALL InsertTestWithoutIndex();

CREATE INDEX idx_phone
ON Patients(Phone);

DROP PROCEDURE IF EXISTS InsertTestWithIndex;

DELIMITER //

CREATE PROCEDURE InsertTestWithIndex()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 1000 DO

        INSERT INTO Patients(Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('Indexed Patient ', i),
            CONCAT('088', LPAD(i,7,'0')),
            FLOOR(RAND() * 100),
            'Da Nang'
        );

        SET i = i + 1;

    END WHILE;

END //

DELIMITER ;

CALL InsertTestWithIndex();