-- Bank Account Management System - PL/SQL Implementation
-- Step 1: Create Sequences
-- Sequence for Customer ID
CREATE SEQUENCE seq_customer_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Sequence for Account ID
CREATE SEQUENCE seq_account_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Sequence for Transaction ID
CREATE SEQUENCE seq_transaction_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Step 2: Create Tables

-- Customers Table
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20),
    address VARCHAR2(200),
    date_created DATE DEFAULT SYSDATE
);

-- Accounts Table
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    account_number VARCHAR2(20) UNIQUE NOT NULL,
    account_type VARCHAR2(20) CHECK (account_type IN ('SAVINGS', 'CURRENT', 'FIXED')),
    balance NUMBER(15,2) DEFAULT 0.00 CHECK (balance >= 0),
    status VARCHAR2(10) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'CLOSED')),
    date_created DATE DEFAULT SYSDATE,
    CONSTRAINT fk_account_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transactions Table
CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    account_id NUMBER NOT NULL,
    transaction_type VARCHAR2(10) CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAW')),
    amount NUMBER(15,2) NOT NULL CHECK (amount > 0),
    balance_after NUMBER(15,2),
    transaction_date DATE DEFAULT SYSDATE,
    description VARCHAR2(200),
    CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Step 3: Insert Sample Data 

-- Insert Customers
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St, New York');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'Emily', 'Johnson', 'emily.j@email.com', '555-0102', '456 Oak Ave, Los Angeles');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'Michael', 'Williams', 'michael.w@email.com', '555-0103', '789 Pine Rd, Chicago');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'Sarah', 'Brown', 'sarah.brown@email.com', '555-0104', '321 Elm St, Houston');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'David', 'Jones', 'david.jones@email.com', '555-0105', '654 Maple Dr, Phoenix');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'Jessica', 'Garcia', 'jessica.g@email.com', '555-0106', '987 Cedar Ln, Philadelphia');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'Robert', 'Miller', 'robert.m@email.com', '555-0107', '147 Birch Way, San Antonio');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'Lisa', 'Davis', 'lisa.davis@email.com', '555-0108', '258 Spruce St, San Diego');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'James', 'Rodriguez', 'james.r@email.com', '555-0109', '369 Willow Ave, Dallas');
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address) VALUES
(seq_customer_id.NEXTVAL, 'Maria', 'Martinez', 'maria.m@email.com', '555-0110', '741 Ash Blvd, San Jose');

-- Insert Accounts
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 1, 'ACC001', 'SAVINGS', 5000.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 1, 'ACC002', 'CURRENT', 2500.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 2, 'ACC003', 'SAVINGS', 8000.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 3, 'ACC004', 'CURRENT', 3500.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 4, 'ACC005', 'SAVINGS', 12000.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 5, 'ACC006', 'FIXED', 15000.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 6, 'ACC007', 'SAVINGS', 6000.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 7, 'ACC008', 'CURRENT', 4200.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 8, 'ACC009', 'SAVINGS', 9500.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 9, 'ACC010', 'CURRENT', 1800.00, 'ACTIVE');
INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance, status) VALUES
(seq_account_id.NEXTVAL, 10, 'ACC011', 'SAVINGS', 11000.00, 'ACTIVE');

-- Insert Sample Transactions
INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description) VALUES
(seq_transaction_id.NEXTVAL, 1, 'DEPOSIT', 5000.00, 5000.00, 'Initial deposit');
INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description) VALUES
(seq_transaction_id.NEXTVAL, 2, 'DEPOSIT', 2500.00, 2500.00, 'Initial deposit');
INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description) VALUES
(seq_transaction_id.NEXTVAL, 3, 'DEPOSIT', 8000.00, 8000.00, 'Initial deposit');
INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description) VALUES
(seq_transaction_id.NEXTVAL, 1, 'WITHDRAW', 500.00, 4500.00, 'ATM withdrawal');
INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description) VALUES
(seq_transaction_id.NEXTVAL, 3, 'DEPOSIT', 1000.00, 9000.00, 'Salary credit');

COMMIT;

-- Step 4: Create Stored Procedures

-- Procedure to Create Customer and Account
CREATE OR REPLACE PROCEDURE create_customer_account (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_email IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_address IN VARCHAR2,
    p_account_type IN VARCHAR2,
    p_initial_deposit IN NUMBER,
    p_customer_id OUT NUMBER,
    p_account_id OUT NUMBER,
    p_account_number OUT VARCHAR2
)
IS
    v_customer_id NUMBER;
    v_account_id NUMBER;
    v_account_number VARCHAR2(20);
    v_account_seq NUMBER;
BEGIN
    -- Exception handling for invalid account type
    IF p_account_type NOT IN ('SAVINGS', 'CURRENT', 'FIXED') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid account type. Must be SAVINGS, CURRENT, or FIXED');
    END IF;
    
    -- Exception handling for negative initial deposit
    IF p_initial_deposit < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Initial deposit cannot be negative');
    END IF;
    
    -- Get next customer ID
    SELECT seq_customer_id.NEXTVAL INTO v_customer_id FROM DUAL;
    
    -- Insert customer
    INSERT INTO customers (customer_id, first_name, last_name, email, phone, address)
    VALUES (v_customer_id, p_first_name, p_last_name, p_email, p_phone, p_address);
    
    -- Generate account number
    SELECT seq_account_id.NEXTVAL INTO v_account_id FROM DUAL;
    SELECT 'ACC' || LPAD(v_account_id, 3, '0') INTO v_account_number FROM DUAL;
    
    -- Insert account
    INSERT INTO accounts (account_id, customer_id, account_number, account_type, balance)
    VALUES (v_account_id, v_customer_id, v_account_number, p_account_type, p_initial_deposit);
    
    -- Create initial deposit transaction if amount > 0
    IF p_initial_deposit > 0 THEN
        INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description)
        VALUES (seq_transaction_id.NEXTVAL, v_account_id, 'DEPOSIT', p_initial_deposit, p_initial_deposit, 'Initial deposit');
    END IF;
    
    COMMIT;
    
    p_customer_id := v_customer_id;
    p_account_id := v_account_id;
    p_account_number := v_account_number;
    
    DBMS_OUTPUT.PUT_LINE('Customer and account created successfully!');
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id);
    DBMS_OUTPUT.PUT_LINE('Account ID: ' || v_account_id);
    DBMS_OUTPUT.PUT_LINE('Account Number: ' || v_account_number);
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Email already exists. Please use a different email.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Procedure to Deposit Money
CREATE OR REPLACE PROCEDURE deposit_money (
    p_account_id IN NUMBER,
    p_amount IN NUMBER,
    p_description IN VARCHAR2 DEFAULT 'Deposit'
)
IS
    v_current_balance NUMBER(15,2);
    v_new_balance NUMBER(15,2);
    v_account_status VARCHAR2(10);
BEGIN
    -- Exception handling for invalid amount
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Deposit amount must be greater than zero');
    END IF;
    
    -- Check if account exists and get current balance
    SELECT balance, status INTO v_current_balance, v_account_status
    FROM accounts
    WHERE account_id = p_account_id;
    
    -- Exception handling for inactive/closed accounts
    IF v_account_status != 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20005, 'Cannot deposit to ' || v_account_status || ' account');
    END IF;
    
    -- Calculate new balance
    v_new_balance := v_current_balance + p_amount;
    
    -- Update account balance (trigger will handle transaction log)
    UPDATE accounts
    SET balance = v_new_balance
    WHERE account_id = p_account_id;
    
    -- Insert transaction record (trigger will also insert, but we do it explicitly for clarity)
    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description)
    VALUES (seq_transaction_id.NEXTVAL, p_account_id, 'DEPOSIT', p_amount, v_new_balance, p_description);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Deposit successful!');
    DBMS_OUTPUT.PUT_LINE('Amount deposited: $' || p_amount);
    DBMS_OUTPUT.PUT_LINE('Previous balance: $' || v_current_balance);
    DBMS_OUTPUT.PUT_LINE('New balance: $' || v_new_balance);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Account not found');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Procedure to Withdraw Money
CREATE OR REPLACE PROCEDURE withdraw_money (
    p_account_id IN NUMBER,
    p_amount IN NUMBER,
    p_description IN VARCHAR2 DEFAULT 'Withdrawal'
)
IS
    v_current_balance NUMBER(15,2);
    v_new_balance NUMBER(15,2);
    v_account_status VARCHAR2(10);
    insufficient_balance EXCEPTION;
BEGIN
    -- Exception handling for invalid amount
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Withdrawal amount must be greater than zero');
    END IF;
    
    -- Check if account exists and get current balance
    SELECT balance, status INTO v_current_balance, v_account_status
    FROM accounts
    WHERE account_id = p_account_id;
    
    -- Exception handling for inactive/closed accounts
    IF v_account_status != 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20008, 'Cannot withdraw from ' || v_account_status || ' account');
    END IF;
    
    -- Exception handling for insufficient balance
    IF v_current_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20009, 'Insufficient balance! Current balance: $' || v_current_balance || ', Requested: $' || p_amount);
    END IF;
    
    -- Calculate new balance
    v_new_balance := v_current_balance - p_amount;
    
    -- Update account balance
    UPDATE accounts
    SET balance = v_new_balance
    WHERE account_id = p_account_id;
    
    -- Insert transaction record
    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, balance_after, description)
    VALUES (seq_transaction_id.NEXTVAL, p_account_id, 'WITHDRAW', p_amount, v_new_balance, p_description);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Withdrawal successful!');
    DBMS_OUTPUT.PUT_LINE('Amount withdrawn: $' || p_amount);
    DBMS_OUTPUT.PUT_LINE('Previous balance: $' || v_current_balance);
    DBMS_OUTPUT.PUT_LINE('New balance: $' || v_new_balance);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'Account not found');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Step 5: Create Functions

-- Function to Get Balance
CREATE OR REPLACE FUNCTION get_balance (
    p_account_id IN NUMBER
)
RETURN NUMBER
IS
    v_balance NUMBER(15,2);
BEGIN
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = p_account_id;
    
    RETURN v_balance;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, 'Account not found');
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Step 6: Create Triggers

-- Trigger to Auto-update Balance 

-- Trigger to Log Transactions 
CREATE OR REPLACE TRIGGER trg_balance_update
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
WHEN (OLD.balance != NEW.balance)
BEGIN
    NULL; 
END;
/

-- Trigger to prevent negative balance 
CREATE OR REPLACE TRIGGER trg_check_balance
BEFORE UPDATE OF balance ON accounts
FOR EACH ROW
BEGIN
    IF :NEW.balance < 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Balance cannot be negative');
    END IF;
END;
/

-- Step 7: Create Views

-- View for Transaction History with Customer and Account Details
CREATE OR REPLACE VIEW vw_transaction_history AS
SELECT 
    t.transaction_id,
    t.transaction_date,
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    a.account_id,
    a.account_number,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.balance_after,
    t.description
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
ORDER BY t.transaction_date DESC, t.transaction_id DESC;

-- View for Account Summary
CREATE OR REPLACE VIEW vw_account_summary AS
SELECT 
    a.account_id,
    a.account_number,
    a.account_type,
    a.balance,
    a.status,
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.phone,
    a.date_created
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
ORDER BY a.account_id;

-- Step 8: Create Procedure with Cursors

-- Procedure to Display Account Details using Cursor
CREATE OR REPLACE PROCEDURE display_account_details (
    p_customer_id IN NUMBER DEFAULT NULL
)
IS
    CURSOR c_accounts IS
        SELECT 
            a.account_id,
            a.account_number,
            a.account_type,
            a.balance,
            a.status,
            c.first_name || ' ' || c.last_name AS customer_name,
            c.email
        FROM accounts a
        JOIN customers c ON a.customer_id = c.customer_id
        WHERE (p_customer_id IS NULL OR c.customer_id = p_customer_id)
        ORDER BY a.account_id;
    
    v_account_rec c_accounts%ROWTYPE;
    v_total_balance NUMBER(15,2) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('ACCOUNT DETAILS');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    OPEN c_accounts;
    LOOP
        FETCH c_accounts INTO v_account_rec;
        EXIT WHEN c_accounts%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || v_account_rec.account_id);
        DBMS_OUTPUT.PUT_LINE('Account Number: ' || v_account_rec.account_number);
        DBMS_OUTPUT.PUT_LINE('Account Type: ' || v_account_rec.account_type);
        DBMS_OUTPUT.PUT_LINE('Balance: $' || v_account_rec.balance);
        DBMS_OUTPUT.PUT_LINE('Status: ' || v_account_rec.status);
        DBMS_OUTPUT.PUT_LINE('Customer: ' || v_account_rec.customer_name);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_account_rec.email);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        
        v_total_balance := v_total_balance + v_account_rec.balance;
    END LOOP;
    CLOSE c_accounts;
    
    IF v_total_balance > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Total Balance: $' || v_total_balance);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No accounts found.');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        IF c_accounts%ISOPEN THEN
            CLOSE c_accounts;
        END IF;
        RAISE;
END;
/

-- Procedure to Display Transaction History using Cursor
CREATE OR REPLACE PROCEDURE display_transaction_history (
    p_account_id IN NUMBER DEFAULT NULL,
    p_limit IN NUMBER DEFAULT 10
)
IS
    CURSOR c_transactions IS
        SELECT 
            transaction_id,
            transaction_date,
            transaction_type,
            amount,
            balance_after,
            description,
            account_number,
            customer_name
        FROM vw_transaction_history
        WHERE (p_account_id IS NULL OR account_id = p_account_id)
        ORDER BY transaction_date DESC, transaction_id DESC
        FETCH FIRST p_limit ROWS ONLY;
    
    v_trans_rec c_transactions%ROWTYPE;
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('TRANSACTION HISTORY');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    OPEN c_transactions;
    LOOP
        FETCH c_transactions INTO v_trans_rec;
        EXIT WHEN c_transactions%NOTFOUND;
        
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('Transaction #' || v_count);
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_trans_rec.transaction_id);
        DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(v_trans_rec.transaction_date, 'DD-MON-YYYY HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('Type: ' || v_trans_rec.transaction_type);
        DBMS_OUTPUT.PUT_LINE('Amount: $' || v_trans_rec.amount);
        DBMS_OUTPUT.PUT_LINE('Balance After: $' || v_trans_rec.balance_after);
        DBMS_OUTPUT.PUT_LINE('Description: ' || NVL(v_trans_rec.description, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Account: ' || v_trans_rec.account_number);
        DBMS_OUTPUT.PUT_LINE('Customer: ' || v_trans_rec.customer_name);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
    CLOSE c_transactions;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No transactions found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total transactions displayed: ' || v_count);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        IF c_transactions%ISOPEN THEN
            CLOSE c_transactions;
        END IF;
        RAISE;
END;
/

-- Test/Demo Scripts
SET SERVEROUTPUT ON;

DECLARE
    v_cust_id NUMBER;
    v_acc_id NUMBER;
    v_acc_num VARCHAR2(20);
BEGIN
    create_customer_account(
        'Alice', 'Wilson', 'alice.w@email.com', '555-0111', 
        '852 Cherry St, Austin', 'SAVINGS', 3000.00,
        v_cust_id, v_acc_id, v_acc_num
    );
END;
/

-- 2. Deposit money
BEGIN
    deposit_money(1, 1000.00, 'Salary deposit');
END;
/

-- 3. Withdraw money
BEGIN
    withdraw_money(1, 500.00, 'ATM withdrawal');
END;
/

-- 4. Check balance using function
SELECT get_balance(1) AS current_balance FROM DUAL;

-- 5. Display account details
BEGIN
    display_account_details(1);
END;
/

-- 6. Display transaction history
BEGIN
    display_transaction_history(1, 5);
END;
/

-- 7. Query views
SELECT * FROM vw_transaction_history WHERE account_id = 1;
SELECT * FROM vw_account_summary WHERE customer_id = 1;
*/


