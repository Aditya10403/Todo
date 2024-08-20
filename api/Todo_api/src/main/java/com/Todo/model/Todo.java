package com.Todo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Todo")
public class Todo {
    @Id
    private Integer id;

    private String todo;
    private Boolean completed;

    public Todo() {
    }

    public Todo(Integer id, String todo, boolean completed) {
        this.id = id;
        this.todo = todo;
        this.completed = completed;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTodo() {
        return todo;
    }

    public void setTodo(String todo) {
        this.todo = todo;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }
}
