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


