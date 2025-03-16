# XNL-21BCE2817-SDE-4
Goal: Design an enterprise‑grade, highly scalable database schema for a multi‑vendor, high‑traffic fintech platform. Optimize advanced queries for real‑time financial analytics on massive datasets while ensuring ACID compliance and high performance.

Project File Structure
```file structure
fintech_platform/
  |-> sql/
  |    |->  create_database.sql
  |    |-> sample_data.sql
  |    |->  test_queries.sql
  |-> scripts/
       | -> maintenance.bat (Windows) or maintenance.sh (macOS/Linux)
       |-> backup.bat (Windows) or backup.sh (macOS/Linux)
```

Step 1: Database Schema Creation
Refer create_database.sql

# Enterprise-Grade Fintech Platform Database Documentation

## Database Schema Overview

The Enterprise-Grade Fintech Platform database is designed to support a multi-vendor financial technology system with robust transaction processing capabilities, user management, and market data integration. The schema follows a relational database model with carefully designed entity relationships.

# Core Entities

1. **Users**
   - Stores customer information including email, full name
   - Tracks registration date, account status, and KYC verification status
   - Primary entity for customer identity management

2. **Vendors**
   - Represents financial service providers on the platform
   - Contains company details, legal entity type, and registration information
   - Tracks vendor onboarding date and operational status

3. **Products**
   - Financial products offered by vendors
   - Categorized by type (Banking, Investments, etc.)
   - Contains fee structure information in JSON format
   - Links to the vendor providing the product

4. **Accounts**
   - Links users to specific financial products
   - Maintains account numbers and balances
   - Tracks account status for operational management

# Transaction Processing

1. **Transactions**
   - Records all financial movements on the platform
   - Links to accounts, products, and payment methods
   - Stores transaction amount, type, timestamp, and status
   - Generates audit logs for compliance

2. **Payment Methods**
   - Stores user payment instruments with encrypted details
   - Supports multiple payment types per user
   - Tracks status and expiration dates for payment instruments

# Security & Compliance

1. **Authentication**
   - Manages credentials for both users and vendors
   - Stores hashed authentication data
   - Tracks last access timestamps for security monitoring

2. **Audit Logs**
   - Records system activities for compliance and security
   - Tracks entity type, entity ID, action performed, and timestamp
   - Provides complete audit trail for regulatory requirements

# Notifications & Market Data

1. **Notifications**
   - System-generated alerts for users
   - Contains notification type, content, and timestamp
   - Linked to users for personalized communication

2. **Market Data**

   - Financial instrument pricing information
   - Tracks data source, timestamp, and market status
   - Influences product offerings and pricing decisions

Key Relationships

The ER diagram shows several important relationships:
- One-to-many relationship between Users and Accounts
- One-to-many relationship between Products and Accounts
- One-to-many relationship between Vendors and Products
- Many-to-many relationship between Accounts and Transactions
- Logical relationship showing how Market Data influences Products
- Transactional relationship showing how operations generate Audit Logs

![image](https://github.com/user-attachments/assets/1cc32053-7fbe-4e30-9a8c-c795db178ff3)


## Folder Structure and Commands for mac terminal

# First, create the project directory structure:

```bash
# Create main project directory
mkdir -p ~/fintech_platform/{sql,scripts,backups,logs}
cd ~/fintech_platform
```

## Store the files in the following locations:

# 1. SQL files in the `sql` folder:

```bash
# Navigate to SQL directory
cd ~/fintech_platform/sql

# Create SQL files
touch create_database.sql
touch sample_data.sql
touch test_queries.sql
```

```bash
# Edit the files (you can use any text editor)
open -a TextEdit create_database.sql
# Paste the create_database.sql content and save
```

# sample_data.sql
```bash
open -a TextEdit sample_data.sql
# Paste the sample_data.sql content and save
```
```sql
-- Sample data for testing
INSERT INTO vendors (name, legal_entity_type, registration_number, status)
VALUES 
('FinPay Solutions', 'Corporation', 'FPS12345', 'active'),
('SecureTrade Inc', 'LLC', 'STI67890', 'active'),
('Global Payments', 'Corporation', 'GP54321', 'active');

INSERT INTO products (vendor_id, name, category, fee_structure, status)
VALUES 
(1, 'Basic Checking', 'Banking', '{"monthly_fee": 0, "transaction_fee": 0.25}', 'active'),
(1, 'Premium Savings', 'Banking', '{"monthly_fee": 5, "interest_rate": 0.025}', 'active'),
(2, 'Stock Trading', 'Investments', '{"commission": 0.001, "minimum_fee": 1.99}', 'active'),
(3, 'International Wire', 'Transfers', '{"flat_fee": 15, "fx_markup": 0.01}', 'active');

-- Add sample users
CALL create_user('john.doe@example.com', 'John Doe', 'hashed_password_1');
CALL create_user('jane.smith@example.com', 'Jane Smith', 'hashed_password_2');
CALL create_user('bob.johnson@example.com', 'Bob Johnson', 'hashed_password_3');

-- Add accounts for users
INSERT INTO accounts (user_id, product_id, account_number, balance)
VALUES 
(1, 1, 'CHK-10001', 5000.00),
(1, 2, 'SAV-20001', 10000.00),
(2, 1, 'CHK-10002', 3500.00),
(2, 3, 'INV-30001', 25000.00),
(3, 2, 'SAV-20002', 15000.00);

-- Add payment methods
INSERT INTO payment_methods (user_id, type, details, status, expiry_date)
VALUES 
(1, 'CREDIT_CARD', 'encrypted_details_1', 'active', '2027-05-31'),
(1, 'BANK_ACCOUNT', 'encrypted_details_2', 'active', NULL),
(2, 'CREDIT_CARD', 'encrypted_details_3', 'active', '2026-11-30'),
(3, 'BANK_ACCOUNT', 'encrypted_details_4', 'active', NULL);

-- Process some sample transactions
DO $$
DECLARE
    v_transaction_id BIGINT;
BEGIN
    CALL process_transaction(1, 3, 1000.00, 1, 1, v_transaction_id);
    CALL process_transaction(2, 5, 500.00, 3, 2, v_transaction_id);
    CALL process_transaction(4, 1, 250.00, 3, 3, v_transaction_id);
END $$;

-- Add market data
INSERT INTO market_data (instrument_id, price, timestamp, source, market_status)
VALUES 
('AAPL', 182.52, '2025-03-14 13:00:00', 'NASDAQ', 'open'),
('MSFT', 425.31, '2025-03-14 13:00:00', 'NASDAQ', 'open'),
('BTC-USD', 68245.75, '2025-03-14 13:00:00', 'COINBASE', 'open'),
('EUR-USD', 1.0742, '2025-03-14 13:00:00', 'FOREX', 'open');

-- Refresh materialized views
REFRESH MATERIALIZED VIEW daily_transaction_summary;
REFRESH MATERIALIZED VIEW user_account_summary;

```
# test.queries.sql
```bash
open -a TextEdit test_queries.sql
# Paste the test_queries.sql content and save
```
```sql
-- Get user account balances
SELECT u.user_id, u.full_name, a.account_number, a.balance
FROM users u
JOIN accounts a ON u.user_id = a.user_id
ORDER BY u.user_id, a.account_id;

-- View recent transactions
SELECT t.transaction_id, t.amount, t.transaction_type, t.timestamp, t.status
FROM transactions t
ORDER BY t.timestamp DESC
LIMIT 10;

-- Get user transaction summary
SELECT u.full_name, 
       COUNT(t.transaction_id) AS transaction_count,
       SUM(CASE WHEN t.transaction_type = 'TRANSFER_OUT' THEN t.amount ELSE 0 END) AS total_outgoing,
       SUM(CASE WHEN t.transaction_type = 'TRANSFER_IN' THEN t.amount ELSE 0 END) AS total_incoming
FROM users u
JOIN accounts a ON u.user_id = a.user_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY u.user_id, u.full_name
ORDER BY u.user_id;

-- Get product performance metrics
SELECT p.name AS product_name, 
       v.name AS vendor_name,
       COUNT(DISTINCT a.account_id) AS active_accounts,
       SUM(a.balance) AS total_balance
FROM products p
JOIN vendors v ON p.vendor_id = v.vendor_id
JOIN accounts a ON p.product_id = a.product_id
WHERE a.status = 'active'
GROUP BY p.product_id, p.name, v.name
ORDER BY total_balance DESC;

-- Get latest market data
SELECT instrument_id, price, timestamp, source
FROM market_data
WHERE timestamp > (CURRENT_TIMESTAMP - INTERVAL '24

```
# 2. Script files in the `scripts` folder:
```bash
# Navigate to scripts directory
cd ~/fintech_platform/scripts

# Create and make executable the maintenance script
touch maintenance.sh
chmod +x maintenance.sh
open -a TextEdit maintenance.sh
# Paste the maintenance.sh content and save
```
# maintenance.sh
```sh
#!/bin/bash

# Vacuum analyze to update statistics
psql -U fintech_admin -d fintech_platform -c "VACUUM ANALYZE;"

# Refresh materialized views
psql -U fintech_admin -d fintech_platform -c "REFRESH MATERIALIZED VIEW daily_transaction_summary;"
psql -U fintech_admin -d fintech_platform -c "REFRESH MATERIALIZED VIEW user_account_summary;"

# Create new partitions for next month
NEXT_MONTH=$(date -v+1m +%Y%m)
NEXT_MONTH_START=$(date -v+1m -v1d +%Y-%m-%d)
NEXT_MONTH_END=$(date -v+2m -v1d +%Y-%m-%d)
psql -U fintech_admin -d fintech_platform -c "CREATE TABLE IF NOT EXISTS transactions_$NEXT_MONTH PARTITION OF transactions_partitioned FOR VALUES FROM ('$NEXT_MONTH_START') TO ('$NEXT_MONTH_END');"

```
```bash
# Create and make executable the backup script
touch backup.sh
chmod +x backup.sh
open -a TextEdit backup.sh
# Paste the backup.sh content and save
```
# backup.sh
```sh
#!/bin/bash

BACKUP_DIR=~/fintech_platform/backups
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Create database backup
pg_dump -U fintech_admin fintech_platform > $BACKUP_DIR/fintech_platform_$TIMESTAMP.sql

# Compress backup
gzip $BACKUP_DIR/fintech_platform_$TIMESTAMP.sql

# Remove backups older than 7 days
find $BACKUP_DIR -name "fintech_platform_*.sql.gz" -mtime +7 -delete

```

# 3. Set up the database:
```bash
# Start PostgreSQL if not already running
brew services start postgresql@15

# Create user and database
psql postgres -c "CREATE USER fintech_admin WITH PASSWORD 'secure_password';"
psql postgres -c "ALTER ROLE fintech_admin WITH SUPERUSER;"
psql postgres -c "CREATE DATABASE fintech_platform;"

# Run the schema creation script
psql -U fintech_admin -d fintech_platform -f ~/fintech_platform/sql/create_database.sql

# Load sample data
psql -U fintech_admin -d fintech_platform -f ~/fintech_platform/sql/sample_data.sql
```
<img width="1470" alt="Screenshot 2025-03-15 at 1 00 54 AM" src="https://github.com/user-attachments/assets/6928277d-4d2b-4537-9555-2d248d17cb06" />


# 4. Set up automated tasks:
```bash
# Edit crontab to add scheduled tasks
crontab -e

# Add these lines to the crontab file:
# Daily vacuum and refresh at 2 AM
0 2 * * * ~/fintech_platform/scripts/maintenance.sh

# Create new partitions on the 25th of each month
0 0 25 * * ~/fintech_platform/scripts/maintenance.sh

# Daily backup at 3 AM
0 3 * * * ~/fintech_platform/scripts/backup.sh
```
use :wq to save and exit from crontab

# 5. Test the database:
```bash
# Run test queries
psql -U fintech_admin -d fintech_platform -f ~/fintech_platform/sql/test_queries.sql
```
<img width="1360" alt="Screenshot 2025-03-15 at 1 02 48 AM" src="https://github.com/user-attachments/assets/efade403-470d-4964-acbc-837dcadcb5f4" />


This organized structure keeps your SQL files, scripts, and backups in separate directories for better management of the fintech platform database implementation.
