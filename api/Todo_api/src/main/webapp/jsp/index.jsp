<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Todo List</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 p-8">

    <div class="max-w-2xl mx-auto bg-white p-6 rounded-lg shadow-lg">
        <h1 class="text-2xl font-bold text-center mb-4">Todo List</h1>

        <!-- Error Message -->
        <p id="errorMessage" class="text-red-500 mb-4 hidden"></p>

        <!-- Add Todo Form -->
        <form id="addTodoForm" class="mb-6">
            <div class="flex flex-col mb-4">
                <label for="todoId" class="mb-2 text-gray-700 font-semibold">Todo ID</label>
                <input type="number" id="todoId" name="id" class="p-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter todo ID" required>
            </div>
            <div class="flex flex-col mb-4">
                <label for="newTodo" class="mb-2 text-gray-700 font-semibold">New Todo</label>
                <input type="text" id="newTodo" name="todo" class="p-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Enter new todo item" required>
            </div>
            <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded-lg hover:bg-blue-600">Add Todo</button>
        </form>

        <!-- Edit Todo Popup -->
        <div id="editPopup" class="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50 hidden">
            <div class="bg-white p-6 rounded-lg shadow-lg">
                <h2 class="text-xl font-bold mb-4">Edit Todo</h2>
                <form id="editTodoForm">
                    <div class="flex flex-col mb-4">
                        <label for="editTodoId" class="mb-2 text-gray-700 font-semibold">Todo ID</label>
                        <input type="number" id="editTodoId" name="id" class="p-2 border border-gray-300 rounded-lg" readonly>
                    </div>
                    <div class="flex flex-col mb-4">
                        <label for="editTodoText" class="mb-2 text-gray-700 font-semibold">Todo</label>
                        <input type="text" id="editTodoText" name="todo" class="p-2 border border-gray-300 rounded-lg" required>
                    </div>
                    <div class="flex items-center mb-4">
                        <input type="checkbox" id="editTodoCompleted" name="completed" class="mr-2">
                        <label for="editTodoCompleted" class="text-gray-700 font-semibold">Completed</label>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button type="submit" class="bg-blue-500 text-white p-2 rounded-lg hover:bg-blue-600">Save</button>
                        <button type="button" id="cancelEdit" class="bg-gray-500 text-white p-2 rounded-lg hover:bg-gray-600">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Todo List -->
        <div id="todoList" class="space-y-4">
            <!-- Todo items will be dynamically added here -->
        </div>
    </div>

    <script>
        // Function to display error messages
        function showError(message) {
            const errorMessage = document.getElementById('errorMessage');
            errorMessage.textContent = message;
            errorMessage.classList.remove('hidden');
        }

        // Function to fetch todo items from the API
        function fetchTodos() {
            fetch('http://localhost:8085/api/todos/all') 
                .then(response => response.json())
                .then(data => {
                    const todoList = document.getElementById('todoList');
                    todoList.innerHTML = '';  // Clear any existing items

                    data.forEach(todo => {
                        addTodoToList(todo);
                    });
                })
                .catch(error => showError('Error fetching todos: ' + error.message));
        }

        // Function to add a todo item to the list
        function addTodoToList(todo) {
            const todoList = document.getElementById('todoList');

            const todoItem = document.createElement('div');
            todoItem.className = 'flex justify-between items-center bg-gray-50 p-4 rounded-lg shadow';

            const todoText = document.createElement('div');
            todoText.className = todo.completed ? 'line-through' : '';
            todoText.textContent = todo.todo;

            const status = document.createElement('span');
            status.className = todo.completed ? 'text-green-600 font-semibold' : 'text-red-600 font-semibold';
            status.textContent = todo.completed ? 'Completed' : 'Pending';

            // Edit Button
            const editButton = document.createElement('button');
            editButton.className = 'bg-yellow-500 text-white p-2 rounded-lg ml-4 hover:bg-yellow-600';
            editButton.textContent = 'Edit';
            editButton.addEventListener('click', () => openEditPopup(todo));

            // Delete Button
            const deleteButton = document.createElement('button');
            deleteButton.className = 'bg-red-500 text-white p-2 rounded-lg ml-4 hover:bg-red-600';
            deleteButton.textContent = 'Delete';
            deleteButton.addEventListener('click', () => deleteTodoItem(todo.id));

            todoItem.appendChild(todoText);
            todoItem.appendChild(status);
            todoItem.appendChild(editButton);
            todoItem.appendChild(deleteButton);
            todoList.appendChild(todoItem);
        }

        // Function to handle adding a new todo item
        document.getElementById('addTodoForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const todoId = document.getElementById('todoId').value.trim();
            const todoText = document.getElementById('newTodo').value.trim();

            if (todoId && todoText) {
                fetch('http://localhost:8085/api/todos/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ id: todoId, todo: todoText, completed: false })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.statusCode === 201) {
                        addTodoToList(data.todo);  // Add the new todo to the list
                        document.getElementById('todoId').value = '';  // Clear the ID input field
                        document.getElementById('newTodo').value = '';  // Clear the todo input field
                    } else {
                        showError(data.message);  // Display error message
                    }
                })
                .catch(error => showError('Error adding todo: ' + error.message));
            }
        });

        // Function to open the edit popup with the todo details
        function openEditPopup(todo) {
            document.getElementById('editTodoId').value = todo.id;
            document.getElementById('editTodoText').value = todo.todo;
            document.getElementById('editTodoCompleted').checked = todo.completed;
            document.getElementById('editPopup').classList.remove('hidden');
        }

        // Function to handle the edit form submission
        document.getElementById('editTodoForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const id = document.getElementById('editTodoId').value;
            const todoText = document.getElementById('editTodoText').value;
            const completed = document.getElementById('editTodoCompleted').checked;

            fetch("http://localhost:8085/api/todos/update/" + id, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ id: id, todo: todoText, completed: completed })
            })
            .then(response => response.json())
            .then(data => {
                if (data.statusCode === 200) {
                    fetchTodos();  // Refresh the list
                    document.getElementById('editPopup').classList.add('hidden');  // Hide the popup
                } else {
                    showError(data.message);  // Display error message
                }
            })
            .catch(error => showError('Error updating todo: ' + error.message));
        });

        // Handle cancel button in the edit popup
        document.getElementById('cancelEdit').addEventListener('click', function() {
            document.getElementById('editPopup').classList.add('hidden');
        });

        // Function to delete a todo item
        function deleteTodoItem(todoId) {
            fetch("http://localhost:8085/api/todos/delete/" + todoId, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.statusCode === 200) {
                    fetchTodos();  // Refresh the list
                } else {
                    showError(data.message);  // Display error message
                }
            })
            .catch(error => showError('Error deleting todo: ' + error.message));
        }

        // Initial fetch of todo items
        fetchTodos();
    </script>
</body>
</html>
