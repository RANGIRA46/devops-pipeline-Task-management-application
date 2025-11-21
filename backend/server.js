const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory task storage
let tasks = [
  { id: uuidv4(), title: 'Welcome to Task Manager', completed: false, createdAt: new Date().toISOString() },
  { id: uuidv4(), title: 'Create your first task', completed: false, createdAt: new Date().toISOString() }
];

// Routes
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Task Backend is running' });
});

app.get('/api/tasks', (req, res) => {
  res.json(tasks);
});

app.post('/api/tasks', (req, res) => {
  const { title } = req.body;
  if (!title) {
    return res.status(400).json({ error: 'Title is required' });
  }
  const newTask = {
    id: uuidv4(),
    title,
    completed: false,
    createdAt: new Date().toISOString()
  };
  tasks.push(newTask);
  res.status(201).json(newTask);
});

app.put('/api/tasks/:id', (req, res) => {
  const { id } = req.params;
  const { title, completed } = req.body;
  const task = tasks.find(t => t.id === id);
  
  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }
  
  if (title !== undefined) task.title = title;
  if (completed !== undefined) task.completed = completed;
  
  res.json(task);
});

app.delete('/api/tasks/:id', (req, res) => {
  const { id } = req.params;
  const index = tasks.findIndex(t => t.id === id);
  
  if (index === -1) {
    return res.status(404).json({ error: 'Task not found' });
  }
  
  const deletedTask = tasks.splice(index, 1);
  res.json(deletedTask[0]);
});

app.listen(PORT, () => {
  console.log(`Task Backend running on http://localhost:${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/api/health`);
});
