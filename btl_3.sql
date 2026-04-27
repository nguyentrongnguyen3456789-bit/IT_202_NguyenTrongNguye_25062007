CREATE DATABASE btl_2;
USE btl_2;

CREATE DATABASE btl_1;
USE btl_1;

-- bài 1

CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_year INT,
    nationality VARCHAR(50)
);

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_name VARCHAR(150) NOT NULL,
    category VARCHAR(50),
    author_id INT,
    
    price DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (price >= 0),
    
    publish_year INT,

    FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    registration_date DATE DEFAULT (CURRENT_DATE)
);


-- bài 2 
INSERT INTO authors (full_name, birth_year, nationality)
VALUES 
('Nguyen Nhat Anh', 1955, 'Vietnam'),
('Agatha Christie', 1890, 'British'),
('Dale Carnegie', 1888, 'American');

INSERT INTO books (book_name, category, author_id, price, publish_year)
VALUES
('Cho Toi Xin Mot Ve Di Tuoi Tho', 'Van hoc', 1, 85000, 2008),
('Mat Biec', 'Van hoc', 1, 90000, 1990),

('Murder on the Orient Express', 'Trinh tham', 2, 120000, 1934),
('And Then There Were None', 'Trinh tham', 2, 115000, 1939),

('How to Win Friends and Influence People', 'Ky nang', 3, 150000, 1936),
('The Leader in You', 'Ky nang', 3, 135000, 1993),

('Toi thay hoa vang tren co xanh', 'Van hoc', 1, 95000, 2010),
('Death on the Nile', 'Trinh tham', 2, 118000, 1937);

INSERT INTO customers (full_name, email, phone)
VALUES
('Tran Van A', 'vana@gmail.com', '0901234567'),
('Le Thi B', 'thib@gmail.com', '0902345678'),
('Pham Van C', 'vanc@gmail.com', '0903456789'),
('Nguyen Thi D', 'thid@gmail.com', '0904567890'),
('Hoang Van E', 'vane@gmail.com', '0905678901');

SELECT book_name, category, price
FROM books
WHERE category = 'Trinh tham'
AND price < 100000;

SELECT full_name, email
FROM customers
WHERE email LIKE '%@gmail.com';

SELECT book_name, price
FROM books
ORDER BY price DESC
LIMIT 3;
