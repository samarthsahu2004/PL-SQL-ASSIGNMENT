
SET SERVEROUTPUT ON;

-- Test 1: Create a new customer and account
DECLARE
    v_cust_id NUMBER;
    v_acc_id NUMBER;
    v_acc_num VARCHAR2(20);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 1: Creating Customer and Account ===');
    create_customer_account(
        'Alice', 'Wilson', 'alice.w@email.com', '555-0111', 
        '852 Cherry St, Austin', 'SAVINGS', 3000.00,
        v_cust_id, v_acc_id, v_acc_num
    );
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Test 2: Deposit money
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 2: Depositing Money ===');
    deposit_money(1, 1000.00, 'Salary deposit');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Test 3: Withdraw money
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 3: Withdrawing Money ===');
    withdraw_money(1, 500.00, 'ATM withdrawal');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Test 4: Check balance using function
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 4: Checking Balance ===');
    DBMS_OUTPUT.PUT_LINE('Current Balance for Account 1: $' || get_balance(1));
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Test 5: Display account details using cursor
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 5: Displaying Account Details (Cursor) ===');
    display_account_details(1);
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Test 6: Display transaction history using cursor
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 6: Displaying Transaction History (Cursor) ===');
    display_transaction_history(1, 5);
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Test 7: Test insufficient balance handling
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 7: Testing Insufficient Balance Handling ===');
    BEGIN
        withdraw_money(1, 100000.00, 'Large withdrawal attempt');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error caught: ' || SQLERRM);
    END;
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Test 8: Query views
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 8: Querying Views ===');
    DBMS_OUTPUT.PUT_LINE('Transaction History View (first 3 records):');
END;
/

SELECT * FROM (
    SELECT * FROM vw_transaction_history 
    WHERE account_id = 1 
    ORDER BY transaction_date DESC
) WHERE ROWNUM <= 3;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Account Summary View:');
END;
/

SELECT account_number, account_type, balance, customer_name 
FROM vw_account_summary 
WHERE customer_id = 1;

-- Test 9: Display all accounts
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== TEST 9: Displaying All Accounts ===');
    display_account_details(NULL);
END;
/

