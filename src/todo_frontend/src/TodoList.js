import React from 'react';
import './TodoList.css'; // Import the CSS file for styling

const TodoList = ({ todos, deleteTodo, setEditingTodo }) => {
  const getStateIcon = (state) => {
    switch (state) {
      case 'done':
        return '✔️'; // Checkmark icon for done
      case 'blocked':
        return '⛔'; // No entry icon for blocked
      case 'pending':
      default:
        return '⏳'; // Hourglass icon for pending
    }
  };

  return (
    <div className="todo-list-container">
      <table className="todo-table">
        <thead>
          <tr>
            <th>Label</th>
            <th>Description</th>
            <th>State</th>
            <th>Due Date</th>
            <th>AI Recommendation</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {todos.map(todo => (
            <tr key={todo.id}>
              <td>{todo.label}</td>
              <td>{todo.description}</td>
              <td>{getStateIcon(todo.state)}</td>
              <td>{new Date(todo.due_date).toLocaleString()}</td>
              <td className="ai-recommendation">{todo.ai_recommendation}</td>
              <td>
                <button className="edit-button" onClick={() => setEditingTodo(todo)}>Edit</button>
                <button className="delete-button" onClick={() => deleteTodo(todo.id)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default TodoList;