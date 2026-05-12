CREATE DATABASE Hospital_Report_DB;
USE Hospital_Report_DB;

CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100)
);

CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY,
    Full_Name VARCHAR(100)
);

CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Patient_ID INT,
    Dept_ID INT,
    Amount DECIMAL(10,2),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

INSERT INTO Departments VALUES
(1, 'Noi'),
(2, 'Ngoai'),
(3, 'Nhi');

INSERT INTO Patients VALUES
(1, 'Nguyen Van A'),
(2, 'Tran Thi B'),
(3, 'Le Van C');

INSERT INTO Invoices VALUES
(101, 1, 1, 500.00),
(102, 2, 1, 300.00),
(103, 3, 2, 1000.00);

CREATE VIEW Department_Revenue_View AS
SELECT
    d.Dept_Name,
    COUNT(DISTINCT i.Patient_ID) AS Total_Patients,
    SUM(i.Amount) AS Total_Revenue
FROM Departments d
JOIN Invoices i
ON d.Dept_ID = i.Dept_ID
GROUP BY d.Dept_Name;

SELECT *
FROM Department_Revenue_View;

UPDATE Department_Revenue_View
SET Total_Revenue = 999999
WHERE Dept_Name = 'Noi';