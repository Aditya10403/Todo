import React, { useEffect, useState } from "react";
import axios from "axios";
import TodoForm from "./components/TodoForm";
import TodoItem from "./components/TodoItem";
import NavBar from "./components/NavBar";

const App = () => {
  const [todos, setTodos] = useState([]);
  const [error, setError] = useState(null);

  const fetchTodos = () => {
    axios
      .get("/api/todos/all")
      .then((response) => {
        setTodos(response.data);
      })
      .catch((error) => {
        setError(
          error.response?.data?.message || "An unexpected error occurred"
        );
      });
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  return (
    <>
      <NavBar />
      <div className="min-h-screen py-8">
        <div
          className="w-full bg-[#3b66a6] max-w-2xl mx-auto shadow-md rounded-lg px-4
          py-3 text-white"
        >
          <h1 className="text-2xl font-bold text-center mb-8 mt-2">
            TODO List
          </h1>
          {error && (
            <div className="text-red-500 text-center mb-4">{error}</div>
          )}
          <div className="mb-4">
            <TodoForm fetchTodos={fetchTodos} setError={setError} />
          </div>
        </div>

        <div className="flex flex-wrap gap-y-3 my-6 mx-auto w-[600px]">
          {todos.map((todo) => (
            <div key={todo.id} className="w-full">
              <TodoItem
                todo={todo}
                fetchTodos={fetchTodos}
                setError={setError}
              />
            </div>
          ))}
        </div>
      </div>
    </>
  );
};

export default App;
