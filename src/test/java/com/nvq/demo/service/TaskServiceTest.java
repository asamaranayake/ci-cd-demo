package com.nvq.demo.service;

import com.nvq.demo.model.Task;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class TaskServiceTest {

    private TaskService taskService;

    @BeforeEach
    void setUp() {
        taskService = new TaskService();
    }

    @Test
    void testGetAllTasks_ShouldReturnAllTasks() {
        List<Task> tasks = taskService.getAllTasks();
        assertNotNull(tasks);
        assertEquals(2, tasks.size()); // Two sample tasks in constructor
    }

    @Test
    void testCreateTask_ShouldCreateNewTask() {
        Task newTask = new Task(null, "New Task", "Description", Task.TaskStatus.TODO, "John");
        Task createdTask = taskService.createTask(newTask);

        assertNotNull(createdTask.getId());
        assertEquals("New Task", createdTask.getTitle());
        assertEquals(Task.TaskStatus.TODO, createdTask.getStatus());
    }

    @Test
    void testGetTaskById_WhenTaskExists_ShouldReturnTask() {
        Task newTask = new Task(null, "Test Task", "Test Description", Task.TaskStatus.TODO, "Jane");
        Task createdTask = taskService.createTask(newTask);

        Optional<Task> foundTask = taskService.getTaskById(createdTask.getId());

        assertTrue(foundTask.isPresent());
        assertEquals("Test Task", foundTask.get().getTitle());
    }

    @Test
    void testGetTaskById_WhenTaskDoesNotExist_ShouldReturnEmpty() {
        Optional<Task> foundTask = taskService.getTaskById(999L);
        assertTrue(foundTask.isEmpty());
    }

    @Test
    void testUpdateTask_WhenTaskExists_ShouldUpdateTask() {
        Task newTask = new Task(null, "Original Title", "Original Description", Task.TaskStatus.TODO, "User1");
        Task createdTask = taskService.createTask(newTask);

        Task updatedTask = new Task(null, "Updated Title", "Updated Description", Task.TaskStatus.DONE, "User2");
        Optional<Task> result = taskService.updateTask(createdTask.getId(), updatedTask);

        assertTrue(result.isPresent());
        assertEquals("Updated Title", result.get().getTitle());
        assertEquals(Task.TaskStatus.DONE, result.get().getStatus());
    }

    @Test
    void testUpdateTask_WhenTaskDoesNotExist_ShouldReturnEmpty() {
        Task updatedTask = new Task(null, "Updated Title", "Updated Description", Task.TaskStatus.DONE, "User");
        Optional<Task> result = taskService.updateTask(999L, updatedTask);

        assertTrue(result.isEmpty());
    }

    @Test
    void testDeleteTask_WhenTaskExists_ShouldReturnTrue() {
        Task newTask = new Task(null, "Task to Delete", "Description", Task.TaskStatus.TODO, "User");
        Task createdTask = taskService.createTask(newTask);

        boolean deleted = taskService.deleteTask(createdTask.getId());

        assertTrue(deleted);
        assertTrue(taskService.getTaskById(createdTask.getId()).isEmpty());
    }

    @Test
    void testDeleteTask_WhenTaskDoesNotExist_ShouldReturnFalse() {
        boolean deleted = taskService.deleteTask(999L);
        assertFalse(deleted);
    }

    @Test
    void testGetTasksByStatus_ShouldReturnFilteredTasks() {
        taskService.createTask(new Task(null, "Task 1", "Desc", Task.TaskStatus.TODO, "User1"));
        taskService.createTask(new Task(null, "Task 2", "Desc", Task.TaskStatus.DONE, "User2"));
        taskService.createTask(new Task(null, "Task 3", "Desc", Task.TaskStatus.TODO, "User3"));

        List<Task> todoTasks = taskService.getTasksByStatus(Task.TaskStatus.TODO);

        assertEquals(3, todoTasks.size()); // Including one from constructor
    }

    @Test
    void testGetTaskCount_ShouldReturnCorrectCount() {
        long initialCount = taskService.getTaskCount();
        taskService.createTask(new Task(null, "Task 1", "Desc", Task.TaskStatus.TODO, "User"));

        assertEquals(initialCount + 1, taskService.getTaskCount());
    }
}
