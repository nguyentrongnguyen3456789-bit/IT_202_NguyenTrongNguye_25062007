
-- 1. KỊCH BẢN RỦI RO 

-- 1. Nạp/rút số tiền âm (amount < 0)
-- 2. Tạo ví với customer_id không tồn tại (vi phạm FK)
-- 3. Một khách hàng tạo nhiều ví (vi phạm rule 1 user = 1 ví)



--BẢNG CUSTOMERS

CREATE TABLE CUSTOMERS (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL
);



-- BẢNG WALLETS

CREATE TABLE WALLETS (
    wallet_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL UNIQUE,              
    balance DECIMAL(12,2) NOT NULL DEFAULT 0,     

    CONSTRAINT fk_wallet_customer
    FOREIGN KEY (customer_id)
    REFERENCES CUSTOMERS(customer_id)
    ON DELETE CASCADE,

    CONSTRAINT chk_balance_non_negative
    CHECK (balance >= 0)                          
);



--  BẢNG TRANSACTIONS

CREATE TABLE TRANSACTIONS (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    wallet_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,                

    transaction_type VARCHAR(20) NOT NULL,        
    status VARCHAR(20) NOT NULL DEFAULT 'SUCCESS',

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transaction_wallet
    FOREIGN KEY (wallet_id)
    REFERENCES WALLETS(wallet_id)
    ON DELETE CASCADE,

    CONSTRAINT chk_amount_positive
    CHECK (amount > 0),                           

    CONSTRAINT chk_transaction_type
    CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAW', 'PAYMENT')),

    CONSTRAINT chk_status
    CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED'))
);

 -- KỊCH BẢN SAI


-- 1. Số tiền âm
-- INSERT INTO TRANSACTIONS (wallet_id, amount, transaction_type)
-- VALUES (1, -100, 'DEPOSIT');

-- 2. customer không tồn tại
-- INSERT INTO WALLETS (customer_id)
-- VALUES (999);

-- 3. 1 user có 2 ví
-- INSERT INTO WALLETS (customer_id) VALUES (1);
-- INSERT INTO WALLETS (customer_id) VALUES (1);
