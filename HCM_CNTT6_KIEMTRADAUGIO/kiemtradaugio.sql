CREATE DATABASE StudentDB;
USE StudentDB;

-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2), 
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course (CourseID, CourseName, Credits) VALUES
('CS101', 'C Programming', 3),
('CS102', 'Database Management', 4),
('BA201', 'Principles of Marketing', 3), 
('ACC301', 'Financial Accounting', 3),
('CS103', 'Java Programming', 4),
('C00001', 'Database Systems', 4);

INSERT INTO Enrollment (StudentID, CourseID, Score) VALUES
-- Sinh viên IT học lập trình và cơ sở dữ liệu
('S00001', 'CS101', 8.5),
('S00001', 'CS102', 7.0),
('S00002', 'CS101', 9.0),
('S00002', 'CS103', 8.0),
('S00005', 'CS102', 6.5),
('S00008', 'CS101', 7.5),
('S00001', 'C00001', 8.5),
('S00002', 'C00001', 9.5),
('S00005', 'C00001', 7.0),
('S00008', 'C00001', 8.0),

-- Sinh viên BA học Marketing
('S00003', 'BA201', 8.0),
('S00006', 'BA201', 7.5),

-- Sinh viên ACC học Kế toán
('S00004', 'ACC301', 9.5),
('S00007', 'ACC301', 8.0);

-- 1:Tạo View ViewStudentBasic hiển thị: StudentID, FullName, và DeptName.
-- Sau đó viết lệnh truy vấn toàn bộ dữ liệu từ View này.
CREATE VIEW ViewStudentBasic AS 
SELECT 
    s.StudentID,s.FullName,d.DeptName
FROM Student s    
JOIN Department d ON s.DeptID = d.DeptID;
SELECT * 
FROM ViewStudentBasic;

-- 2: Tạo một Regular Index tên là idxFullName cho cột FullName của bảng Student.

CREATE INDEX idxFullName
ON Student(FullName);

-- 3: viết Stored Procedure GetStudentsIT (không có tham số).
-- Chức năng: Hiển thị toàn bộ sinh viên thuộc khoa "Information Technology" trong bảng Student kết hợp với DeptName từ bảng Department.
-- Yêu cầu: Gọi procedure bằng lệnh CALL để kiểm tra.

DELIMITER //
CREATE PROCEDURE GetStudentsIT()
BEGIN
    SELECT 
        s.StudentID, s.FullName,  d.DeptName
    FROM Student s
    JOIN Department d  ON s.DeptID = d.DeptID
    WHERE d.DeptName = 'Information Technology';
END //
DELIMITER ;
CALL GetStudentsIT();

-- 4: Tạo View ViewStudentCountByDept hiển thị: DeptName, TotalStudents
--  (số lượng sinh viên của mỗi khoa).

CREATE VIEW ViewStudentCountByDept AS
SELECT 
    d.DeptName,
    COUNT(s.StudentID) AS TotalStudents
FROM Department d
LEFT JOIN Student s
ON d.DeptID = s.DeptID
GROUP BY d.DeptName;

-- Hiển thị khoa có nhiều sinh viên nhất
SELECT *
FROM ViewStudentCountByDept
WHERE TotalStudents = (
    SELECT MAX(TotalStudents)
    FROM ViewStudentCountByDept
);


-- 5: a) Viết Stored Procedure GetTopScoreStudent với tham số: IN varCourseID VARCHAR(6).
-- Chức năng: Hiển thị sinh viên có điểm cao nhất trong môn học được truyền vào.
-- b) Gọi thủ tục trên để tìm sinh viên có điểm cao nhất môn "Database Systems" (C00001).
DELIMITER //
CREATE PROCEDURE GetTopScoreStudent(
    IN varCourseID VARCHAR(6)
)
BEGIN
    SELECT 
        s.StudentID, s.FullName, e.CourseID,  e.Score
    FROM Student s
    JOIN Enrollment e
        ON s.StudentID = e.StudentID
    WHERE e.CourseID = varCourseID
      AND e.Score = (
            SELECT MAX(Score)
            FROM Enrollment
            WHERE CourseID = varCourseID
      );
END //
DELIMITER ;

CALL GetTopScoreStudent('C00001');




