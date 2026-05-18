const express = require('express');
  const mongoose = require('mongoose');
  const Todo = require('./models/todo');

  const app = express();
  app.use(express.json());

  mongoose.connect(process.env.MONGO_URI || 'mongodb://mongo:27017/todos');

  app.get('/todos', async (req, res) => {
    const todos = await Todo.find();
    res.json(todos);
  });

  app.post('/todos', async (req, res) => {
    const todo = await Todo.create(req.body);
    res.status(201).json(todo);
  });

  app.get('/todos/:id', async (req, res) => {
    const todo = await Todo.findById(req.params.id);
    todo ? res.json(todo) : res.status(404).json({ error: 'Not found' });
  });

  app.put('/todos/:id', async (req, res) => {
    const todo = await Todo.findByIdAndUpdate(req.params.id, req.body, { new: true });
    todo ? res.json(todo) : res.status(404).json({ error: 'Not found' });
  });

  app.delete('/todos/:id', async (req, res) => {
    await Todo.findByIdAndDelete(req.params.id);
    res.status(204).send();
  });

  app.listen(3000, () => console.log('API running on port 3000'));