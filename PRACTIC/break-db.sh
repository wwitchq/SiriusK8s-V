#!/bin/bash
# This script intentionally breaks the database to test troubleshooting

# Wait for DB to be ready
sleep 5

# Drop the users table to cause application errors
PGPASSWORD=postgres psql -h localhost -U postgres -d demo -c "DROP TABLE IF EXISTS users CASCADE;" 2>/dev/null

echo "✅ Database intentionally broken - users table removed"
echo "   Application will now fail when trying to access users"
