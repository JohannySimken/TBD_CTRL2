package com.backend.taskmanagement.dtos.stats;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SectorClusterDTO {
    //pregunta 5

    private String sectorName;
    private Long pendingCount;
    private String centroidWkt;
}