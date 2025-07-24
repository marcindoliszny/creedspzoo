# In your creed-tests folder, replace the database config with a simpler version:
cat > config/database.js << 'EOF'
module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      connectionString: env('DATABASE_URL'),
      ssl: {
        rejectUnauthorized: false
      }
    },
    acquireConnectionTimeout: 60000,
    pool: {
      min: 2,
      max: 10
    }
  }
});
EOF