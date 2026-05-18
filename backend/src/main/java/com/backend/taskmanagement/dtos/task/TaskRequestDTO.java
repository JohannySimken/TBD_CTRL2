package com.backend.taskmanagement.dtos.task;

import lombok.Data;

@Data
public class TaskRequestDTO {
    private String title;
    private String description;
    private String dueDate;
    private Long sectorId;
    private Double latitude;
    private Double longitude;
}