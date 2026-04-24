CREATE DATABASE elearning;
USE elearning;

CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(255) NOT NULL,
    dod DATE NOT NULL,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(255) NOT NULL,
    teacher_id INT,
    course_description TEXT,
    course_session INT CHECK (course_session >= 1),
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURDATE()),
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Score (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    mid_score DECIMAL(4,2) CHECK (mid_score >= 0 AND mid_score <= 10),
    final_score DECIMAL(4,2) CHECK (final_score >= 0 AND final_score <= 10),
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

INSERT INTO Student (student_name, dod, email)
VALUE
('Vu Anh Tuan', '2001-05-12', 'tuan.vu@student.com'),
('Le Quynh Nhu', '2002-08-20', 'nhu.le@student.com'),
('Tran Binh Minh', '2000-12-05', 'minh.tran@student.com'),
('Nguyen Hoang Hai', '2001-02-15', 'hai.nguyen@student.com'),
('Pham Tra My', '2002-11-30', 'my.pham@student.com');

INSERT INTO Teacher (teacher_name, email) 
VALUES
('Nguyen Van A', 'nguyenvana@elearning.com'),
('Tran Thi B', 'tranthib@elearning.com'),
('Le Van C', 'levanc@elearning.com'),
('Pham Dinh D', 'phamdinhd@elearning.com'),
('Hoang Ngoc E', 'hoangngoce@elearning.com');

INSERT INTO Course (course_name, teacher_id, course_description, course_session) 
VALUES
('Co So Du Lieu', 1, 'Hoc ve SQL va thiet ke CSDL', 45),
('Lap Trinh Web', 2, 'Kien thuc HTML, CSS, JS', 60),
('Tri Tue Nhan Tao', 3, 'Nhap mon AI va Machine Learning', 50),
('Mang May Tinh', 4, 'Hoc ve cac giao thuc mang', 40),
('Cau Truc Du Lieu', 5, 'Cac cau truc du lieu va thuat toan', 55);

INSERT INTO Enrollment (student_id, course_id, enrollment_date) 
VALUES
(1, 1, '2023-09-01'),
(1, 2, '2023-09-01'),
(2, 1, '2023-09-02'),
(3, 3, '2023-09-03'),
(4, 4, '2023-09-04'),
(5, 5, '2023-09-05');

INSERT INTO Score (student_id, course_id, mid_score, final_score) 
VALUES
(1, 1, 8.5, 9.0),
(1, 2, 7.0, 8.0),
(2, 1, 9.0, 9.5),
(3, 3, 6.5, 7.0),
(4, 4, 8.0, 8.5),
(5, 5, 7.5, 8.0);

UPDATE Student 
SET email = 'tuan.vuanh.new@student.com' 
WHERE student_id = 1;

UPDATE Course 
SET course_description = 'Kien thuc HTML, CSS, JS va ReactJS' 
WHERE course_id = 2;

UPDATE Score 
SET final_score = 9.5 
WHERE student_id = 1 AND course_id = 1;


DELETE FROM Score 
WHERE student_id = 5 AND course_id = 5;

DELETE FROM Enrollment 
WHERE student_id = 5 AND course_id = 5;

SELECT * 
FROM Student;

SELECT * 
FROM Teacher;

SELECT * 
FROM Course;

SELECT * 
FROM Enrollment;

SELECT * 
FROM Score;