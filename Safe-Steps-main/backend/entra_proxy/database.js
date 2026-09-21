const { Pool } = require('pg');

if (!process.env.DATABASE_URL) {
  throw new Error(
    'DATABASE_URL environment variable is missing.'
  );
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

pool.on('error', (error) => {
  console.error(
    'Unexpected PostgreSQL error:',
    error
  );
});

async function query(text, params = []) {
  return pool.query(text, params);
}

async function testConnection() {
  const result = await pool.query(
    'SELECT NOW() AS current_time'
  );

  console.log(
    'Connected to PostgreSQL:',
    result.rows[0].current_time
  );
}

module.exports = {
  pool,
  query,
  testConnection
};