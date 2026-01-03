# Task Manager API - Usage Examples

## Base URL
```
http://localhost:8080
```

## API Examples

### 1. Health Check

Check if the application is running:

```bash
curl http://localhost:8080/actuator/health
```

**Response:**
```json
{
  "status": "UP"
}
```

---

### 2. Get All Tasks

Retrieve all tasks:

```bash
curl http://localhost:8080/api/tasks
```

**Response:**
```json
[
  {
    "id": 1,
    "title": "Setup CI/CD Pipeline",
    "description": "Configure Jenkins for automated builds",
    "status": "IN_PROGRESS",
    "assignee": "DevOps Team"
  },
  {
    "id": 2,
    "title": "Write Unit Tests",
    "description": "Add comprehensive test coverage",
    "status": "TODO",
    "assignee": "Developer"
  }
]
```

---

### 3. Get Tasks by Status

Filter tasks by status (TODO, IN_PROGRESS, DONE):

```bash
curl "http://localhost:8080/api/tasks?status=TODO"
```

**Response:**
```json
[
  {
    "id": 2,
    "title": "Write Unit Tests",
    "description": "Add comprehensive test coverage",
    "status": "TODO",
    "assignee": "Developer"
  }
]
```

---

### 4. Get Task by ID

Retrieve a specific task:

```bash
curl http://localhost:8080/api/tasks/1
```

**Response:**
```json
{
  "id": 1,
  "title": "Setup CI/CD Pipeline",
  "description": "Configure Jenkins for automated builds",
  "status": "IN_PROGRESS",
  "assignee": "DevOps Team"
}
```

**404 Response** (if not found):
```json
{
  "timestamp": "2024-01-15T10:30:00.000+00:00",
  "status": 404,
  "error": "Not Found",
  "path": "/api/tasks/999"
}
```

---

### 5. Create a New Task

Create a task:

```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Deploy to Production",
    "description": "Deploy the latest version to production environment",
    "status": "TODO",
    "assignee": "DevOps Engineer"
  }'
```

**Response:**
```json
{
  "id": 3,
  "title": "Deploy to Production",
  "description": "Deploy the latest version to production environment",
  "status": "TODO",
  "assignee": "DevOps Engineer"
}
```

**Validation Error** (if title is empty):
```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "",
    "description": "Invalid task"
  }'
```

**Response:**
```json
{
  "timestamp": "2024-01-15T10:30:00.000+00:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "errors": [
    {
      "field": "title",
      "message": "Title is required"
    }
  ]
}
```

---

### 6. Update a Task

Update an existing task:

```bash
curl -X PUT http://localhost:8080/api/tasks/3 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Deploy to Production",
    "description": "Deploy the latest version to production environment - Completed",
    "status": "DONE",
    "assignee": "DevOps Engineer"
  }'
```

**Response:**
```json
{
  "id": 3,
  "title": "Deploy to Production",
  "description": "Deploy the latest version to production environment - Completed",
  "status": "DONE",
  "assignee": "DevOps Engineer"
}
```

---

### 7. Delete a Task

Delete a task:

```bash
curl -X DELETE http://localhost:8080/api/tasks/3
```

**Response:** `204 No Content` (successful deletion)

**404 Response** (if task doesn't exist):
```bash
curl -X DELETE http://localhost:8080/api/tasks/999
```

---

### 8. Get Task Statistics

Get overview of task distribution:

```bash
curl http://localhost:8080/api/tasks/stats
```

**Response:**
```json
{
  "totalTasks": 10,
  "todoTasks": 5,
  "inProgressTasks": 3,
  "doneTasks": 2
}
```

---

## Task Status Values

The API supports three status values:

- `TODO` - Task not started
- `IN_PROGRESS` - Task is being worked on
- `DONE` - Task completed

---

## Complete Workflow Example

### Scenario: Managing a Sprint Task

```bash
# 1. Create a new task for the sprint
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Implement User Authentication",
    "description": "Add JWT-based authentication to the API",
    "status": "TODO",
    "assignee": "Alice Johnson"
  }'

# Response: {"id": 4, "title": "Implement User Authentication", ...}

# 2. Check all TODO tasks
curl "http://localhost:8080/api/tasks?status=TODO"

# 3. Start working on the task
curl -X PUT http://localhost:8080/api/tasks/4 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Implement User Authentication",
    "description": "Add JWT-based authentication to the API - In Progress",
    "status": "IN_PROGRESS",
    "assignee": "Alice Johnson"
  }'

# 4. Complete the task
curl -X PUT http://localhost:8080/api/tasks/4 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Implement User Authentication",
    "description": "Add JWT-based authentication to the API - Completed",
    "status": "DONE",
    "assignee": "Alice Johnson"
  }'

# 5. Check sprint statistics
curl http://localhost:8080/api/tasks/stats
```

---

## Testing with HTTPie

If you prefer HTTPie (more readable):

```bash
# Install HTTPie
pip install httpie

# Get all tasks
http GET localhost:8080/api/tasks

# Create task
http POST localhost:8080/api/tasks \
  title="New Task" \
  description="Task description" \
  status="TODO" \
  assignee="User"

# Update task
http PUT localhost:8080/api/tasks/1 \
  title="Updated Task" \
  description="Updated description" \
  status="DONE" \
  assignee="User"
```

---

## Testing with Postman

### Import into Postman

Create a collection with these requests:

1. **GET** All Tasks: `http://localhost:8080/api/tasks`
2. **GET** Task by ID: `http://localhost:8080/api/tasks/1`
3. **POST** Create Task:
   - URL: `http://localhost:8080/api/tasks`
   - Headers: `Content-Type: application/json`
   - Body (raw JSON):
     ```json
     {
       "title": "New Task",
       "description": "Description",
       "status": "TODO",
       "assignee": "User"
     }
     ```
4. **PUT** Update Task:
   - URL: `http://localhost:8080/api/tasks/1`
   - Headers: `Content-Type: application/json`
   - Body (raw JSON):
     ```json
     {
       "title": "Updated Task",
       "description": "Updated Description",
       "status": "DONE",
       "assignee": "User"
     }
     ```
5. **DELETE** Task: `http://localhost:8080/api/tasks/1`

---

## Automated API Testing Script

Save as `test-api.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:8080"

echo "1. Health Check"
curl -s $BASE_URL/actuator/health | jq '.'

echo -e "\n2. Get All Tasks"
curl -s $BASE_URL/api/tasks | jq '.'

echo -e "\n3. Create New Task"
TASK_ID=$(curl -s -X POST $BASE_URL/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Automated Test Task",
    "description": "Created by test script",
    "status": "TODO",
    "assignee": "Test Script"
  }' | jq -r '.id')

echo "Created task with ID: $TASK_ID"

echo -e "\n4. Get Task by ID"
curl -s $BASE_URL/api/tasks/$TASK_ID | jq '.'

echo -e "\n5. Update Task"
curl -s -X PUT $BASE_URL/api/tasks/$TASK_ID \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Automated Test Task",
    "description": "Updated by test script",
    "status": "DONE",
    "assignee": "Test Script"
  }' | jq '.'

echo -e "\n6. Get Statistics"
curl -s $BASE_URL/api/tasks/stats | jq '.'

echo -e "\n7. Delete Task"
curl -s -X DELETE $BASE_URL/api/tasks/$TASK_ID

echo -e "\nAPI Testing Complete!"
```

Run with:
```bash
chmod +x test-api.sh
./test-api.sh
```

---

## Error Handling Examples

### Invalid JSON

```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d 'invalid json'
```

### Missing Required Field

```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "description": "No title provided"
  }'
```

### Invalid Task Status

```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Task",
    "status": "INVALID_STATUS"
  }'
```

All will return appropriate HTTP error codes (400, 404, 500) with detailed error messages.
