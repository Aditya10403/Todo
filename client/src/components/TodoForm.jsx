import axios from "axios";
import React, { useState } from "react";

const TodoForm = ({ fetchTodos, setError }) => {
  const [todo, setTodo] = useState("");
  const [id, setId] = useState("");

  const addTodo = async (e) => {
    try {
      e.preventDefault();

      const response = await axios({
        method: "post",
        url: "/api/todos/add",
        data: {
          id,
          todo,
          completed: false,
        },
      });

      if (response.status === 201) {
        setId("");
        setTodo("");
        fetchTodos();
      } else {
        setError(response?.data?.message || "An unexpected error occurred");
      }
    } catch (error) {
      setError(error.response?.data?.message || "An unexpected error occurred");
    }
  };

  return (
    <form onSubmit={addTodo} className="w-full max-w-sm mx-auto px-4 py-2">
      <div className="flex items-center space-x-4 border-b-2 border-teal-500 py-2">
        <input
          type="number"
          placeholder="ID"
          className="appearance-none bg-transparent border-none w-1/4 text-white py-1 px-2 leading-tight focus:outline-none"
          value={id}
          onChange={(e) => setId(e.target.value)}
          min={0}
        />
        <input
          type="text"
          placeholder="Write Todo..."
          className="appearance-none bg-transparent border-none w-full text-white py-1 px-2 leading-tight focus:outline-none"
          value={todo}
          onChange={(e) => setTodo(e.target.value)}
        />
        <button
          className="flex-shrink-0 bg-teal-500 hover:bg-teal-700 border-teal-500 hover:border-teal-700 text-sm border-4 text-white py-1 px-2 rounded"
          type="submit"
        >
          Add
        </button>
      </div>
    </form>
  );
};

export default TodoForm;
