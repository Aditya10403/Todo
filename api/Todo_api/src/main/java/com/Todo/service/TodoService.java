package com.Todo.service;

import com.Todo.model.Todo;
import com.Todo.response.ApiResponse;

import java.util.List;

public interface TodoService {
    ApiResponse addTodo(Todo todo);
    ApiResponse updateTodo(Integer id, Todo todo);
    ApiResponse deleteTodo(Integer id);
    List<Todo> getAllTodo();
}
