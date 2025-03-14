--test queries
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