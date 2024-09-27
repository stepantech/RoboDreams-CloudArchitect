import React, { useState, useEffect } from 'react';
import './TodoForm.css'; // Import the CSS file for styling

const TodoForm = ({ addTodo, updateTodo, editingTodo, setEditingTodo }) => {
  const [todo, setTodo] = useState({ label: '', description: '', state: 'pending', due_date: '' });

  useEffect(() => {
    if (editingTodo) {
      setTodo(editingTodo);
    } else {
      setTodo({ label: '', description: '', state: 'pending', due_date: '' });
    }
  }, [editingTodo]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setTodo({ ...todo, [name]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingTodo) {
      updateTodo(editingTodo.id, todo);
    } else {
      addTodo(todo);
    }
    setTodo({ label: '', description: '', state: 'pending', due_date: '' });
    setEditingTodo(null);
  };

  const handleCancel = () => {
    setTodo({ label: '', description: '', state: 'pending', due_date: '' });
    setEditingTodo(null);
  };

  return (
    <form className="todo-form" onSubmit={handleSubmit}>
      <input type="text" name="label" value={todo.label} onChange={handleChange} placeholder="Label" required />
      <input type="text" name="description" value={todo.description} onChange={handleChange} placeholder="Description" required />
      <select name="state" value={todo.state} onChange={handleChange} required>
        <option value="pending">Pending</option>
        <option value="done">Done</option>
        <option value="blocked">Blocked</option>
      </select>
      <input type="datetime-local" name="due_date" value={todo.due_date} onChange={handleChange} required />
      <div className="button-group">
        <button type="submit">{editingTodo ? 'Update' : 'Add'} Todo</button>
        {editingTodo && <button type="button" onClick={handleCancel}>Cancel</button>}
      </div>
    </form>
  );
};

export default TodoForm;