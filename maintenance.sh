--maintenance
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
