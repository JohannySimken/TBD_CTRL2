package com.backend.taskmanagement.dtos.stats;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserSectorCountDTO {
    //pregunta 6, es un ranking de usuarios que necesita los sgtes parametros

    private String username;
    private String sectorName;
    private Long count;
}