package com.backend.taskmanagement.dtos.task;

import lombok.Data;

@Data
public class FilterTaskDTO {
    private String status;
    private String keyword;
}