package com.backend.taskmanagement.dtos.sector;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class SectorResponseDTO {
    private Long id;
    private String name;
    private String category;
    private String description;
    private Double latitude;
    private Double longitude;
}
