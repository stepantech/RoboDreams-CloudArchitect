import React, { useState, useEffect } from 'react';
import axios from 'axios';
import TodoForm from './TodoForm';
import TodoList from './TodoList';
import './App.css';

const App = () => {
  const apiUrl = window._env_.apiUrl;
  const [todos, setTodos] = useState([]);
  const [editingTodo, setEditingTodo] = useState(null);
  const [version, setVersion] = useState('');

  useEffect(() => {
    const fetchTodos = async () => {
      const response = await axios.get(`${apiUrl}/api/todos/`);
      setTodos(response.data);
    };
    fetchTodos();
  }, [apiUrl]);

  useEffect(() => {
    const fetchVersion = async () => {
      const response = await axios.get('/version.json');
      setVersion(response.data.version);
    };
    fetchVersion();
  }, []);

  const addTodo = async (todo) => {
    const response = await axios.post(`${apiUrl}/api/todos/`, todo);
    setTodos([...todos, response.data]);
  };

  const updateTodo = async (id, updatedTodo) => {
    const response = await axios.put(`${apiUrl}/api/todos/${id}`, updatedTodo);
    setTodos(todos.map(todo => (todo.id === id ? response.data : todo)));
  };

  const deleteTodo = async (id) => {
    await axios.delete(`${apiUrl}/api/todos/${id}`);
    setTodos(todos.filter(todo => todo.id !== id));
  };

  return (
    <div className="app-container">
      <header className="app-header">
        <h1 className="app-title">Awesome ToDo App</h1>
      </header>
      <main>
        <TodoForm addTodo={addTodo} updateTodo={updateTodo} editingTodo={editingTodo} setEditingTodo={setEditingTodo} />
        <TodoList todos={todos} deleteTodo={deleteTodo} setEditingTodo={setEditingTodo} />
      </main>
      <footer className="app-footer">
        <p>Version: {version}</p>
      </footer>
    </div>
  );
};

export default App;