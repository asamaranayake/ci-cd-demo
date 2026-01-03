package com.nvq.demo.model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Task {

    private Long id;

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    private TaskStatus status;

    private String assignee;

    public enum TaskStatus {
        TODO, IN_PROGRESS, DONE
    }
}
