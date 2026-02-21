const express = require('express');
const { Pool } = require('pg');
const app = express();
const port = 3000;

const pool = new Pool({
  host: process.env.DB_HOST || 'database',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  database: process.env.DB_NAME || 'todos',
  user: process.env.DB_USER || 'admin',
  password: process.env.DB_PASSWORD || 'secure123'
});

app.use(express.json());

app.use((req, res, next) => {
  const allowedOrigins = ['http://localhost', 'http://127.0.0.1'];
  const origin = req.headers.origin;

  if (origin && allowedOrigins.includes(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
  }

  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.sendStatus(204);
  }

  next();
});

const initializeDatabase = async () => {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS todos (
      id SERIAL PRIMARY KEY,
      title TEXT NOT NULL,
      completed BOOLEAN NOT NULL DEFAULT FALSE,
      created_at TIMESTAMP NOT NULL DEFAULT NOW()
    )
  `);
};

app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'healthy', service: 'backend', database: 'connected' });
  } catch (error) {
    res.status(500).json({ status: 'unhealthy', service: 'backend', database: 'disconnected' });
  }
});

app.get('/api/todos', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, title, completed FROM todos ORDER BY id ASC'
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch todos' });
  }
});

app.post('/api/todos', async (req, res) => {
  const { title, completed } = req.body;

  if (!title || typeof title !== 'string' || !title.trim()) {
    return res.status(400).json({ error: 'Title is required' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO todos (title, completed) VALUES ($1, $2) RETURNING id, title, completed',
      [title.trim(), Boolean(completed)]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create todo' });
  }
});

app.get('/api/todos/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);

  if (Number.isNaN(id)) {
    return res.status(400).json({ error: 'Invalid todo id' });
  }

  try {
    const result = await pool.query(
      'SELECT id, title, completed FROM todos WHERE id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Todo not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch todo' });
  }
});

app.put('/api/todos/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  const { title, completed } = req.body;

  if (Number.isNaN(id)) {
    return res.status(400).json({ error: 'Invalid todo id' });
  }

  if (title === undefined && completed === undefined) {
    return res.status(400).json({ error: 'Provide at least one field to update' });
  }

  if (title !== undefined && (typeof title !== 'string' || !title.trim())) {
    return res.status(400).json({ error: 'Title must be a non-empty string' });
  }

  if (completed !== undefined && typeof completed !== 'boolean') {
    return res.status(400).json({ error: 'Completed must be a boolean' });
  }

  try {
    const result = await pool.query(
      `UPDATE todos
       SET title = COALESCE($1, title),
           completed = COALESCE($2, completed)
       WHERE id = $3
       RETURNING id, title, completed`,
      [title !== undefined ? title.trim() : null, completed !== undefined ? completed : null, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Todo not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to update todo' });
  }
});

app.delete('/api/todos/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);

  if (Number.isNaN(id)) {
    return res.status(400).json({ error: 'Invalid todo id' });
  }

  try {
    const result = await pool.query(
      'DELETE FROM todos WHERE id = $1 RETURNING id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Todo not found' });
    }

    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete todo' });
  }
});

const startServer = async () => {
  try {
    await initializeDatabase();
    app.listen(port, '0.0.0.0', () => {
      console.log(`Backend API listening on port ${port}`);
    });
  } catch (error) {
    console.error('Failed to start backend:', error.message);
    process.exit(1);
  }
};

startServer();
