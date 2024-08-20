package com.Todo.controller;

import com.Todo.model.Todo;
import com.Todo.response.ApiResponse;
import com.Todo.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:5173")
@RequestMapping("/api/todos")
public class TodoController {

    @Autowired
    private TodoService todoService;

    @PostMapping("/add")
    public ResponseEntity<ApiResponse> addTodo(@RequestBody Todo t) {
        ApiResponse response = todoService.addTodo(t);
        return ResponseEntity.status(response.getStatusCode()).body(response);
    }

    @GetMapping("/all")
    public ResponseEntity<List<Todo>> getAllTodo() {
        List<Todo> todos = todoService.getAllTodo();
        return ResponseEntity.ok(todos);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<ApiResponse> updateTodo(@PathVariable("id") Integer id,@RequestBody Todo t) {
        ApiResponse response = todoService.updateTodo(id, t);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<ApiResponse> deleteTodo(@PathVariable("id") Integer id) {
        ApiResponse response = todoService.deleteTodo(id);
        return ResponseEntity.ok(response);
    }

}
