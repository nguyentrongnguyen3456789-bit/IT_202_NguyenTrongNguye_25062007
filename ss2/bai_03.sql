USE dtb_ss02;

CREATE TABLE CUSTOMERS (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY AUTO_INCREMENT,         
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,    
    total_amount DECIMAL(10,2) NOT NULL,             
    customer_id INT NOT NULL,                         

    
    CONSTRAINT fk_customer
    FOREIGN KEY (customer_id)
    REFERENCES CUSTOMERS(customer_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
