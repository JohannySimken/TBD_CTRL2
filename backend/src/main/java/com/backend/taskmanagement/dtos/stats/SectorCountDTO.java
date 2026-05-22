package com.backend.taskmanagement.dtos.stats;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SectorCountDTO {
    //pregunta 1,3 y 7
    private String sectorName;
    private Long count;
}