CREATE DATABASE dtb_ss02;
USE dtb_ss02;

CREATE TABLE books (
	book_id CHAR(5) PRIMARY KEY,
    book_name VARCHAR(200) NOT NULL,
    quantity INT NOT NULL  CHECK (quantity >= 0),
    rental_price DECIMAL(10, 2) DEFAULT 5000
);

ALTER TABLE books 
ADD COLUMN date_input DATETIME;

CREATE TABLE borow_books (
	borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id CHAR(5),
	borrow_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT FOREIGN KEY (book_id) REFERENCES books(book_id)	
);

ALTER TABLE books
DROP COLUMN date_input;

ALTER TABLE books
MODIFY COLUMN quantity double;

ALTER TABLE borow_books
MODIFY COLUMN borrow_date DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE books
RENAME COLUMN book_name TO title;

ALTER TABLE books
ALTER COLUMN rental_price SET DEFAULT 10000;