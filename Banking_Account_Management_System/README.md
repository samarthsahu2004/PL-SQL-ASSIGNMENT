# Bank Account Management System - PL/SQL

A comprehensive Bank Account Management System implemented in PL/SQL with all essential banking features.

## Features

- ✅ Create customer and account
- ✅ Deposit & withdraw money
- ✅ Balance inquiry
- ✅ Transaction history
- ✅ Insufficient balance handling

## PL/SQL Concepts Used

- **Stored Procedures**: `create_customer_account`, `deposit_money`, `withdraw_money`
- **Functions**: `get_balance`
- **Triggers**: `trg_balance_update`, `trg_check_balance` (auto-update balance, prevent negative balance)
- **Cursors**: Used in `display_account_details` and `display_transaction_history` procedures
- **Views**: `vw_transaction_history`, `vw_account_summary`
- **Exception Handling**: Comprehensive error handling throughout all procedures
- **Sequences**: `seq_customer_id`, `seq_account_id`, `seq_transaction_id`
- **Tables**: `customers`, `accounts`, `transactions`

## Database Schema

### Tables

1. **customers**
   - customer_id (PK)
   - first_name, last_name
   - email (UNIQUE)
   - phone, address
   - date_created

2. **accounts**
   - account_id (PK)
   - customer_id (FK)
   - account_number (UNIQUE)
   - account_type (SAVINGS, CURRENT, FIXED)
   - balance
   - status (ACTIVE, INACTIVE, CLOSED)
   - date_created

3. **transactions**
   - transaction_id (PK)
   - account_id (FK)
   - transaction_type (DEPOSIT, WITHDRAW)
   - amount
   - balance_after
   - transaction_date
   - description

## Installation

1. Run the main script to create all database objects:
```sql
@bank_account_system.sql
```

2. The script includes sample data with ~15 entries:
   - 10 customers
   - 11 accounts
   - 5 initial transactions

## Usage Examples

### Create Customer and Account
```sql
DECLARE
    v_cust_id NUMBER;
    v_acc_id NUMBER;
    v_acc_num VARCHAR2(20);
BEGIN
    create_customer_account(
        'John', 'Doe', 'john.doe@email.com', '555-0123',
        '123 Main St', 'SAVINGS', 5000.00,
        v_cust_id, v_acc_id, v_acc_num
    );
END;
/
```

### Deposit Money
```sql
BEGIN
    deposit_money(1, 1000.00, 'Salary deposit');
END;
/
```

### Withdraw Money
```sql
BEGIN
    withdraw_money(1, 500.00, 'ATM withdrawal');
END;
/
```

### Check Balance
```sql
SELECT get_balance(1) AS current_balance FROM DUAL;
```

### Display Account Details (uses cursor)
```sql
BEGIN
    display_account_details(1);  -- For specific customer
    -- OR
    display_account_details(NULL);  -- For all customers
END;
/
```

### Display Transaction History (uses cursor)
```sql
BEGIN
    display_transaction_history(1, 10);  -- Last 10 transactions for account 1
END;
/
```

### Query Views
```sql
-- Transaction history view
SELECT * FROM vw_transaction_history 
WHERE account_id = 1;

-- Account summary view
SELECT * FROM vw_account_summary 
WHERE customer_id = 1;
```

## Running Tests

Execute the test script to see all features in action:
```sql
@test_bank_system.sql
```

## Exception Handling

The system includes comprehensive exception handling for:
- Invalid account types
- Negative amounts
- Insufficient balance
- Inactive/closed accounts
- Duplicate emails
- Account not found errors

## Sample Data

The system comes pre-loaded with:
- 10 customers with various details
- 11 accounts (SAVINGS, CURRENT, FIXED types)
- 5 sample transactions

## Notes

- All monetary values use NUMBER(15,2) for precision
- Account numbers are auto-generated (ACC001, ACC002, etc.)
- Transaction history is automatically maintained
- Balance constraints prevent negative balances
- All procedures include proper commit/rollback handling

