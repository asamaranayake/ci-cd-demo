package com.nvq.demo.service;

import com.nvq.demo.model.Task;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

@Service
public class TaskService {

    private final Map<Long, Task> taskRepository = new ConcurrentHashMap<>();
    private final AtomicLong idGenerator = new AtomicLong(1);

    public TaskService() {
        // Add sample data
        createTask(new Task(null, "Setup CI/CD Pipeline", "Configure Jenkins for automated builds", Task.TaskStatus.IN_PROGRESS, "DevOps Team"));
        createTask(new Task(null, "Write Unit Tests", "Add comprehensive test coverage", Task.TaskStatus.TODO, "Developer"));
    }

    public List<Task> getAllTasks() {
        return new ArrayList<>(taskRepository.values());
    }

    public Optional<Task> getTaskById(Long id) {
        return Optional.ofNullable(taskRepository.get(id));
    }

    public List<Task> getTasksByStatus(Task.TaskStatus status) {
        return taskRepository.values().stream()
                .filter(task -> task.getStatus() == status)
                .collect(Collectors.toList());
    }

    public Task createTask(Task task) {
        task.setId(idGenerator.getAndIncrement());
        if (task.getStatus() == null) {
            task.setStatus(Task.TaskStatus.TODO);
        }
        taskRepository.put(task.getId(), task);
        return task;
    }

    public Optional<Task> updateTask(Long id, Task updatedTask) {
        if (!taskRepository.containsKey(id)) {
            return Optional.empty();
        }
        updatedTask.setId(id);
        taskRepository.put(id, updatedTask);
        return Optional.of(updatedTask);
    }

    public boolean deleteTask(Long id) {
        return taskRepository.remove(id) != null;
    }

    public long getTaskCount() {
        return taskRepository.size();
    }
}
