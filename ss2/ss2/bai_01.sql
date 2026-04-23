USE dtb_ss02;

CREATE TABLE PRODUCT (
	id INT PRIMARY KEY,
    productname VARCHAR(255),
    price DECIMAL(10, 2),
    description VARCHAR (255)
);

-- Thay TEXT = VARCHAR do TEXT tốn nhiều dung lượng hơn gây lãng phí dung lượng

