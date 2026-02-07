const express = require('express');
const app = express();
const port = 3000;

let todos = [
  { id: 1, title: 'Learn Docker', completed: false },
  { id: 2, title: 'Master Docker Compose', completed: false },
  { id: 3, title: 'Deploy with Kubernetes', completed: false }
];

app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'healthy', service: 'backend' });
});

app.get('/api/todos', (req, res) => {
  res.json(todos);
});

app.post('/api/todos', (req, res) => {
  const todo = {
    id: todos.length + 1,
    title: req.body.title,
    completed: false
  };
  todos.push(todo);
  res.status(201).json(todo);
});

app.get('/api/todos/:id', (req, res) => {
  const todo = todos.find(t => t.id === parseInt(req.params.id));
  if (todo) {
    res.json(todo);
  } else {
    res.status(404).json({ error: 'Todo not found' });
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Backend API listening on port ${port}`);
});
