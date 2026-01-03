package com.nvq.demo.controller;

import com.nvq.demo.model.Task;
import com.nvq.demo.service.TaskService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(TaskController.class)
class TaskControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private TaskService taskService;

    @Test
    void testGetAllTasks_ShouldReturnTaskList() throws Exception {
        Task task1 = new Task(1L, "Task 1", "Description 1", Task.TaskStatus.TODO, "User1");
        Task task2 = new Task(2L, "Task 2", "Description 2", Task.TaskStatus.DONE, "User2");

        when(taskService.getAllTasks()).thenReturn(Arrays.asList(task1, task2));

        mockMvc.perform(get("/api/tasks"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].title").value("Task 1"))
                .andExpect(jsonPath("$[1].title").value("Task 2"));
    }

    @Test
    void testGetTaskById_WhenTaskExists_ShouldReturnTask() throws Exception {
        Task task = new Task(1L, "Test Task", "Test Description", Task.TaskStatus.TODO, "User");

        when(taskService.getTaskById(1L)).thenReturn(Optional.of(task));

        mockMvc.perform(get("/api/tasks/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Test Task"))
                .andExpect(jsonPath("$.status").value("TODO"));
    }

    @Test
    void testGetTaskById_WhenTaskDoesNotExist_ShouldReturn404() throws Exception {
        when(taskService.getTaskById(999L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/tasks/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void testCreateTask_WithValidData_ShouldReturnCreatedTask() throws Exception {
        Task task = new Task(1L, "New Task", "New Description", Task.TaskStatus.TODO, "User");

        when(taskService.createTask(any(Task.class))).thenReturn(task);

        mockMvc.perform(post("/api/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"New Task\",\"description\":\"New Description\",\"status\":\"TODO\",\"assignee\":\"User\"}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.title").value("New Task"));
    }

    @Test
    void testCreateTask_WithInvalidData_ShouldReturn400() throws Exception {
        mockMvc.perform(post("/api/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"\",\"description\":\"Description\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void testUpdateTask_WhenTaskExists_ShouldReturnUpdatedTask() throws Exception {
        Task updatedTask = new Task(1L, "Updated Task", "Updated Description", Task.TaskStatus.DONE, "User");

        when(taskService.updateTask(eq(1L), any(Task.class))).thenReturn(Optional.of(updatedTask));

        mockMvc.perform(put("/api/tasks/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"Updated Task\",\"description\":\"Updated Description\",\"status\":\"DONE\",\"assignee\":\"User\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Updated Task"))
                .andExpect(jsonPath("$.status").value("DONE"));
    }

    @Test
    void testDeleteTask_WhenTaskExists_ShouldReturn204() throws Exception {
        when(taskService.deleteTask(1L)).thenReturn(true);

        mockMvc.perform(delete("/api/tasks/1"))
                .andExpect(status().isNoContent());
    }

    @Test
    void testDeleteTask_WhenTaskDoesNotExist_ShouldReturn404() throws Exception {
        when(taskService.deleteTask(999L)).thenReturn(false);

        mockMvc.perform(delete("/api/tasks/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void testGetStats_ShouldReturnTaskStatistics() throws Exception {
        when(taskService.getTaskCount()).thenReturn(10L);
        when(taskService.getTasksByStatus(Task.TaskStatus.TODO)).thenReturn(Arrays.asList(new Task(), new Task()));
        when(taskService.getTasksByStatus(Task.TaskStatus.IN_PROGRESS)).thenReturn(Arrays.asList(new Task()));
        when(taskService.getTasksByStatus(Task.TaskStatus.DONE)).thenReturn(Arrays.asList(new Task(), new Task(), new Task()));

        mockMvc.perform(get("/api/tasks/stats"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalTasks").value(10))
                .andExpect(jsonPath("$.todoTasks").value(2))
                .andExpect(jsonPath("$.inProgressTasks").value(1))
                .andExpect(jsonPath("$.doneTasks").value(3));
    }
}
