const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.send(`
    <h1>Welcome to Dockerized Node.js App! 🐳</h1>
    <p>Environment: ${process.env.NODE_ENV}</p>
    <p><a href="/api/data">Get Data</a></p>
    <p><a href="/health">Health Check</a></p>
  `);
});

app.get('/api/data', (req, res) => {
  res.json({
    message: 'Hello from Docker!',
    environment: process.env.NODE_ENV,
    version: '1.0.0',
    framework: 'Express',
    language: 'Node.js'
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', service: 'nodejs-app' });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Node.js app listening on port ${port}`);
});
