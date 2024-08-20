package com.Todo.response;

import com.Todo.model.Todo;

public class ApiResponse {
    private int statusCode;
    private String message;
    private Todo todo;

    public ApiResponse() {
    }

    public ApiResponse(int statusCode, String message, Todo todo) {
        this.statusCode = statusCode;
        this.message = message;
        this.todo = todo;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Todo getTodo() {
        return todo;
    }

    public void setTodo(Todo todo) {
        this.todo = todo;
    }
}

