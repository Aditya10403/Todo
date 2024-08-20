package com.Todo.service;

import com.Todo.exception.TodoNotFoundException;
import com.Todo.model.Todo;
import com.Todo.repository.TodoRepository;
import com.Todo.response.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TodoServiceImp implements TodoService {

    @Autowired
    private TodoRepository todoRepository;

    @Override
    public ApiResponse addTodo(Todo t) {
        try {
            if (todoRepository.existsById(t.getId())) {
                throw new TodoNotFoundException("Todo already exists");
            }
            Todo savedTodo = todoRepository.save(t);
            return new ApiResponse(
                    HttpStatus.CREATED.value(),
                    "Todo created successfully",
                    savedTodo
            );
        } catch (Exception e) {
            throw new TodoNotFoundException(e.getMessage());
        }
    }

    @Override
    public ApiResponse updateTodo(Integer id, Todo t) {
        try {
            Todo todo = todoRepository.findById(id).orElseThrow(() ->
                    new TodoNotFoundException("Todo not found with ID :: " + id)
            );
            if (!id.equals(t.getId())) {
                throw new TodoNotFoundException("Todo ID must be the same");
            }
            todo.setId(t.getId());
            todo.setTodo(t.getTodo());
            todo.setCompleted(t.isCompleted());
            Todo updatedTodo = todoRepository.save(todo);
            return new ApiResponse(
                    HttpStatus.OK.value(),
                    "Todo updated successfully",
                    updatedTodo
            );
        } catch (Exception e) {
            throw new TodoNotFoundException(e.getMessage());
        }
    }

    @Override
    public ApiResponse deleteTodo(Integer id) {
        if (!todoRepository.existsById(id)) {
            throw new TodoNotFoundException("Todo not found with ID :: " + id); // normal way of giving exception
        }
        todoRepository.deleteById(id);
        return new ApiResponse(
                HttpStatus.OK.value(),
                "Todo deleted successfully",
                null
        );
    }

    @Override
    public List<Todo> getAllTodo() {
        return todoRepository.findAll();
    }

}
