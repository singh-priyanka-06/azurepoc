const express = require('express');
const { Pool } = require('pg');

// Create an instance of Express
const app = express();
const port = 3000;

// Configure PostgreSQL connection (Add your DB details)
const pool = new Pool({
  user: 'testuser',
  host: 'localhost',
  database: 'testdb',
  password: 'testPassword',
  port: 5432,
});

// Test database connection
pool.connect((err, client, release) => {
  if (err) {
    return console.error('Error acquiring client', err.stack);
  }
  client.query('SELECT NOW()', (err, result) => {
    release();
    if (err) {
      return console.error('Error executing query', err.stack);
    }
    console.log('Connected to PostgreSQL at:', result.rows[0].now);
  });
});

// Define a simple route
app.get('/', (req, res) => {
  pool.connect((err, client, release) => {
    if (err) {
      return res.send('Error acquiring client');
    }
    client.query('SELECT NOW()', (err, result) => {
      release();
      if (err) {
        return res.send('Error executing query');
      }
      res.send(`Hello World! Time from DB: ${result.rows[0].now}`);
    });
  });
});

// Start the server
app.listen(port, () => {
  console.log(`App running on http://localhost:${port}`);
});
