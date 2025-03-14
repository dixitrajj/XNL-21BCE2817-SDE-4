-- Create database
CREATE DATABASE fintech_platform;

-- Connect to database
\c fintech_platform

-- Create Users table
CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    kyc_status VARCHAR(20) NOT NULL DEFAULT 'not_verified'
);

-- Create Vendors table
CREATE TABLE vendors (
    vendor_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    legal_entity_type VARCHAR(50) NOT NULL,
    registration_number VARCHAR(50) NOT NULL UNIQUE,
    onboarding_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
);

-- Create Products table
CREATE TABLE products (
    product_id BIGSERIAL PRIMARY KEY,
    vendor_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    fee_structure JSONB NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

-- Create Accounts table
CREATE TABLE accounts (
    account_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    account_number VARCHAR(50) NOT NULL UNIQUE,
    balance DECIMAL(19, 4) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create Authentication table
CREATE TABLE authentication (
    auth_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    vendor_id BIGINT,
    auth_type VARCHAR(20) NOT NULL,
    credentials VARCHAR(255) NOT NULL, -- Hashed credentials
    last_access TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    CHECK ((user_id IS NOT NULL AND vendor_id IS NULL) OR (user_id IS NULL AND vendor_id IS NOT NULL))
);

-- Create Payment Methods table
CREATE TABLE payment_methods (
    payment_method_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    type VARCHAR(30) NOT NULL,
    details TEXT NOT NULL, -- Encrypted payment details
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    expiry_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create Transactions table
CREATE TABLE transactions (
    transaction_id BIGSERIAL PRIMARY KEY,
    account_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    payment_method_id BIGINT,
    amount DECIMAL(19, 4) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id)
);

-- Create Notifications table
CREATE TABLE notifications (
    notification_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    notification_type VARCHAR(30) NOT NULL,
    content TEXT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create Market Data table
CREATE TABLE market_data (
    market_data_id BIGSERIAL PRIMARY KEY,
    instrument_id VARCHAR(20) NOT NULL,
    price DECIMAL(19, 8) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    source VARCHAR(50) NOT NULL,
    market_status VARCHAR(20) NOT NULL
);

-- Create Audit Logs table
CREATE TABLE audit_logs (
    audit_id BIGSERIAL PRIMARY KEY,
    entity_type VARCHAR(30) NOT NULL,
    entity_id BIGINT NOT NULL,
    action VARCHAR(30) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
-- Indexes for Users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_kyc_status ON users(kyc_status);

-- Indexes for Accounts table
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_product_id ON accounts(product_id);
CREATE INDEX idx_accounts_status ON accounts(status);

-- Indexes for Transactions table
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_timestamp ON transactions(timestamp);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);

-- Indexes for Payment Methods table
CREATE INDEX idx_payment_methods_user_id ON payment_methods(user_id);
CREATE INDEX idx_payment_methods_status ON payment_methods(status);

-- Indexes for Market Data table
CREATE INDEX idx_market_data_instrument_id ON market_data(instrument_id);
CREATE INDEX idx_market_data_timestamp ON market_data(timestamp);

-- Indexes for Audit Logs table
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp);

-- Create partitioned tables
-- Partition Transactions table by date range
CREATE TABLE transactions_partitioned (
    transaction_id BIGINT NOT NULL,
    account_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    payment_method_id BIGINT,
    amount DECIMAL(19, 4) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY(transaction_id, timestamp)
) PARTITION BY RANGE (timestamp);

-- Create monthly partitions
CREATE TABLE transactions_202503 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2025-03-01') TO ('2025-04-01');
CREATE TABLE transactions_202504 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2025-04-01') TO ('2025-05-01');
CREATE TABLE transactions_202505 PARTITION OF transactions_partitioned
    FOR VALUES FROM ('2025-05-01') TO ('2025-06-01');

-- Partition Market Data table by date range
CREATE TABLE market_data_partitioned (
    market_data_id BIGINT NOT NULL,
    instrument_id VARCHAR(20) NOT NULL,
    price DECIMAL(19, 8) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    source VARCHAR(50) NOT NULL,
    market_status VARCHAR(20) NOT NULL,
    PRIMARY KEY(market_data_id, timestamp)
) PARTITION BY RANGE (timestamp);

-- Create daily partitions for recent market data
CREATE TABLE market_data_20250314 PARTITION OF market_data_partitioned
    FOR VALUES FROM ('2025-03-14') TO ('2025-03-15');
CREATE TABLE market_data_20250315 PARTITION OF market_data_partitioned
    FOR VALUES FROM ('2025-03-15') TO ('2025-03-16');

-- Create stored procedures
-- Create a new user account with initial authentication
CREATE OR REPLACE PROCEDURE create_user(
    p_email VARCHAR(100),
    p_full_name VARCHAR(100),
    p_password VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id BIGINT;
BEGIN
    -- Insert user
    INSERT INTO users (email, full_name, registration_date, status, kyc_status)
    VALUES (p_email, p_full_name, CURRENT_TIMESTAMP, 'active', 'pending')
    RETURNING user_id INTO v_user_id;
    
    -- Insert authentication
    INSERT INTO authentication (user_id, auth_type, credentials, last_access)
    VALUES (v_user_id, 'password', p_password, CURRENT_TIMESTAMP);
    
    COMMIT;
END;
$$;

-- Process a financial transaction with ACID properties
CREATE OR REPLACE PROCEDURE process_transaction(
    p_from_account_id BIGINT,
    p_to_account_id BIGINT,
    p_amount DECIMAL(19,4),
    p_payment_method_id BIGINT,
    p_product_id BIGINT,
    OUT p_transaction_id BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_from_balance DECIMAL(19,4);
    v_transaction_id BIGINT;
BEGIN
    -- Start transaction
    BEGIN
        -- Check if source account has sufficient funds
        SELECT balance INTO v_from_balance
        FROM accounts
        WHERE account_id = p_from_account_id
        FOR UPDATE;
        
        IF v_from_balance < p_amount THEN
            RAISE EXCEPTION 'Insufficient funds in account %', p_from_account_id;
        END IF;
        
        -- Debit from source account
        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_from_account_id;
        
        -- Credit to destination account
        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_to_account_id;
        
        -- Record transaction
        INSERT INTO transactions (
            account_id, product_id, payment_method_id, 
            amount, transaction_type, timestamp, status
        )
        VALUES (
            p_from_account_id, p_product_id, p_payment_method_id,
            p_amount, 'TRANSFER_OUT', CURRENT_TIMESTAMP, 'completed'
        )
        RETURNING transaction_id INTO v_transaction_id;
        
        -- Record the incoming transaction
        INSERT INTO transactions (
            account_id, product_id, payment_method_id,
            amount, transaction_type, timestamp, status
        )
        VALUES (
            p_to_account_id, p_product_id, NULL,
            p_amount, 'TRANSFER_IN', CURRENT_TIMESTAMP, 'completed'
        );
        
        -- Create audit log
        INSERT INTO audit_logs (entity_type, entity_id, action, timestamp)
        VALUES ('TRANSACTION', v_transaction_id, 'TRANSFER', CURRENT_TIMESTAMP);
        
        -- Create notification for sender
        INSERT INTO notifications (user_id, notification_type, content, timestamp)
        SELECT u.user_id, 'TRANSACTION', 
               'Transfer of ' || p_amount || ' completed successfully',
               CURRENT_TIMESTAMP
        FROM accounts a
        JOIN users u ON a.user_id = u.user_id
        WHERE a.account_id = p_from_account_id;
        
        -- Set output parameter
        p_transaction_id := v_transaction_id;
        
        -- Commit transaction
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;
END;
$$;

-- Create materialized views for analytics
-- Daily transaction summary
CREATE MATERIALIZED VIEW daily_transaction_summary AS
SELECT 
    DATE(timestamp) AS transaction_date,
    transaction_type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY DATE(timestamp), transaction_type;

-- Create index on the materialized view
CREATE INDEX idx_daily_txn_summary_date ON daily_transaction_summary(transaction_date);

-- User account summary
CREATE MATERIALIZED VIEW user_account_summary AS
SELECT 
    u.user_id,
    u.email,
    u.full_name,
    COUNT(a.account_id) AS account_count,
    SUM(a.balance) AS total_balance
FROM users u
JOIN accounts a ON u.user_id = a.user_id
GROUP BY u.user_id, u.email, u.full_name;

-- Create index on the materialized view
CREATE INDEX idx_user_account_summary_id ON user_account_summary(user_id);