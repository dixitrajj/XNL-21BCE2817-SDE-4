--backup
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
