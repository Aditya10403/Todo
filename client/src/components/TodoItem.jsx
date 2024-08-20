import axios from "axios";
import React, { useState } from "react";

const TodoItem = ({ todo, fetchTodos, setError }) => {
  const [completed, setCompleted] = useState(todo.completed);
  const [todoMsg, setTodoMsg] = useState(todo.todo);
  const [isTodoEditable, setIsTodoEditable] = useState(false);

  const handleCheckboxChange = async () => {
    const updatedCompleted = !completed;
    setCompleted(updatedCompleted);

    try {
      const updatedTodo = {
        ...todo,
        completed: updatedCompleted,
      };

      const response = await axios.put(
        `/api/todos/update/${todo.id}`,
        updatedTodo
      );

      if (response.status === 200) {
        fetchTodos();
      } else {
        setError(response?.data?.message || "An unexpected error occurred");
      }
    } catch (error) {
      setError(error.response?.data?.message || "An unexpected error occurred");
    }
  };

  const editTodo = async () => {
    try {
      const updatedTodo = {
        ...todo,
        todo: todoMsg,
      };

      const response = await axios.put(
        `/api/todos/update/${todo.id}`,
        updatedTodo
      );

      if (response.status === 200) {
        setIsTodoEditable(false);
        fetchTodos();
      } else {
        setError(response?.data?.message || "An unexpected error occurred");
      }
    } catch (error) {
      setError(error.response?.data?.message || "An unexpected error occurred");
    }
  };

  const deleteTodo = async () => {
    try {
      const response = await axios.delete(`/api/todos/delete/${todo.id}`);
      if (response.status == 200) {
        fetchTodos();
      } else {
        setError(response?.data?.message || "An unexpected error occurred");
      }
    } catch (error) {
      setError(error.response?.data?.message || "An unexpected error occurred");
    }
  };

  return (
    <div
      className={`flex border border-black/10 rounded-lg px-3 py-1.5 gap-x-3 shadow-sm shadow-white/50 duration-300 text-black ${
        completed ? "bg-[#c6e9a7]" : "bg-[#ccbed7]"
      }`}
    >
      <input
        type="checkbox"
        className="cursor-pointer"
        checked={completed}
        onChange={handleCheckboxChange}
      />
      <input
        type="text"
        className={`border outline-none w-full bg-transparent rounded-lg m-1 ${
          isTodoEditable ? "border-gray-200 px-2" : "border-transparent"
        } ${completed ? "line-through" : ""}`}
        value={todoMsg}
        onChange={(e) => setTodoMsg(e.target.value)}
        readOnly={!isTodoEditable}
      />
      <button
        className="inline-flex w-8 h-8 rounded-lg text-sm border border-black/10 justify-center items-center bg-gray-50 hover:bg-gray-100 shrink-0 disabled:opacity-50"
        onClick={() => {
          if (completed) return;

          if (isTodoEditable) {
            editTodo();
          } else {
            setIsTodoEditable((prev) => !prev);
          }
        }}
        disabled={completed}
      >
        {isTodoEditable ? "📁" : "✏️"}
      </button>
      <button
        className="inline-flex w-8 h-8 rounded-lg text-sm border border-black/10 justify-center items-center bg-gray-50 hover:bg-gray-100 shrink-0"
        onClick={() => deleteTodo()}
      >
        ❌
      </button>
    </div>
  );
};

export default TodoItem;
