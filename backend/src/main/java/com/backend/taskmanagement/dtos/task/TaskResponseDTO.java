package com.backend.taskmanagement.dtos.task;

import lombok.Data;

@Data
public class TaskResponseDTO {
    private Long id;
    private String title;
    private String description;
    private String status;
    private String dueDate;
    private String completedAt;
    private String sectorName;
    private String username;
    private Double latitude;
    private Double longitude;
}