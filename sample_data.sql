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
