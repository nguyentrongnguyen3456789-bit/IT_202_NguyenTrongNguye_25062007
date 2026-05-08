CREATE DATABASE sales_management;
USE sales_management;

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    gender TINYINT NOT NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    customer_type VARCHAR(20) DEFAULT 'NORMAL'
);

CREATE TABLE category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(12,2) NOT NULL CHECK(price > 0),
    stock INT DEFAULT 0,
    category_id INT,

    FOREIGN KEY (category_id)
    REFERENCES category(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'PENDING',

    FOREIGN KEY (customer_id)
    REFERENCES customer(customer_id)
);

CREATE TABLE order_detail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK(quantity > 0),
    price_at_time DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES product(product_id)
);

INSERT INTO customer(full_name, gender, birth_date, email, phone, customer_type)
VALUES
('Nguyen Van A', 1, '2000-05-10', 'vana@gmail.com', '0901111111', 'VIP'),
('Tran Thi B', 0, '2002-08-15', 'thib@gmail.com', '0902222222', 'NORMAL'),
('Le Van C', 1, '1998-03-20', 'vanc@gmail.com', '0903333333', 'VIP'),
('Pham Thi D', 0, '2005-01-01', 'thid@gmail.com', '0904444444', 'NORMAL'),
('Hoang Van E', 1, '2001-11-11', 'vane@gmail.com', '0905555555', 'NORMAL');

INSERT INTO category(category_name)
VALUES
('Điện tử'),
('Thời trang'),
('Gia dụng'),
('Sách'),
('Thể thao');

INSERT INTO product(product_name, price, stock, category_id)
VALUES
('Laptop Dell', 25000000, 10, 1),
('iPhone 15', 30000000, 5, 1),
('Ao Hoodie', 500000, 20, 2),
('May Giat', 12000000, 3, 3),
('Sach SQL', 150000, 50, 4),
('Giay The Thao', 2000000, 15, 5),
('Tai Nghe Bluetooth', 1500000, 12, 1);

INSERT INTO orders(customer_id, order_date, status)
VALUES
(1, '2025-01-01', 'COMPLETED'),
(2, '2025-01-05', 'COMPLETED'),
(1, '2025-02-01', 'PENDING'),
(3, '2025-02-10', 'COMPLETED'),
(4, '2025-03-01', 'CANCELLED');

INSERT INTO order_detail(order_id, product_id, quantity, price_at_time)
VALUES
(1, 1, 1, 25000000),
(1, 7, 2, 1500000),
(2, 3, 1, 500000),
(3, 2, 1, 30000000),
(4, 4, 1, 12000000);

UPDATE product
SET price = 27000000
WHERE product_name = 'Laptop Dell';

UPDATE customer
SET email = 'newemail@gmail.com'
WHERE customer_id = 2;

DELETE FROM order_detail
WHERE order_id = 5;

DELETE FROM orders
WHERE status = 'CANCELLED';

SELECT
    full_name AS 'Ho Ten',
    email AS 'Email',

    CASE
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
    END AS 'Gioi Tinh'

FROM customer;

SELECT
    full_name,
    YEAR(NOW()) - YEAR(birth_date) AS age
FROM customer
ORDER BY age ASC
LIMIT 3;

SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
FROM orders o
INNER JOIN customer c
ON o.customer_id = c.customer_id;

SELECT
    c.category_name,
    COUNT(p.product_id) AS total_product
FROM category c
INNER JOIN product p
ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) >= 2;

SELECT
    product_name,
    price
FROM product
WHERE price >
(
    SELECT AVG(price)
    FROM product
);

SELECT
    full_name,
    email
FROM customer
WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM orders
);

SELECT
    c.category_name,
    SUM(od.quantity * od.price_at_time) AS total_revenue
FROM category c
INNER JOIN product p
ON c.category_id = p.category_id

INNER JOIN order_detail od
ON p.product_id = od.product_id

GROUP BY c.category_name

HAVING SUM(od.quantity * od.price_at_time) >
(
    SELECT AVG(revenue) * 1.2
    FROM
    (
        SELECT SUM(quantity * price_at_time) AS revenue
        FROM order_detail
        GROUP BY order_id
    ) temp
);

SELECT
    p1.product_name,
    p1.price,
    c.category_name
FROM product p1
INNER JOIN category c
ON p1.category_id = c.category_id

WHERE p1.price =
(
    SELECT MAX(p2.price)
    FROM product p2
    WHERE p2.category_id = p1.category_id
);

SELECT full_name
FROM customer
WHERE customer_type = 'VIP'
AND customer_id IN
(
    SELECT customer_id
    FROM orders
    WHERE order_id IN
    (
        SELECT order_id
        FROM order_detail
        WHERE product_id IN
        (
            SELECT product_id
            FROM product
            WHERE category_id =
            (
                SELECT category_id
                FROM category
                WHERE category_name = 'Điện tử'
            )
        )
    )
);