# XNL-21BCE2817-SDE-4
Goal: Design an enterprise‑grade, highly scalable database schema for a multi‑vendor, high‑traffic fintech platform. Optimize advanced queries for real‑time financial analytics on massive datasets while ensuring ACID compliance and high performance.

Project File Structure

fintech_platform/
├── sql/
│   ├── create_database.sql
│   ├── sample_data.sql
│   └── test_queries.sql
├── scripts/
    ├── maintenance.bat (Windows) or maintenance.sh (macOS/Linux)
    └── backup.bat (Windows) or backup.sh (macOS/Linux)

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

2. **Market Data**[Uploading create_database.sql…]()

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

# Edit the files (you can use any text editor)
open -a TextEdit create_database.sql
# Paste the create_database.sql content and save

open -a TextEdit sample_data.sql
# Paste the sample_data.sql content and save

open -a TextEdit test_queries.sql
# Paste the test_queries.sql content and save
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

# Create and make executable the backup script
touch backup.sh
chmod +x backup.sh
open -a TextEdit backup.sh
# Paste the backup.sh content and save
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
