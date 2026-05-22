package com.backend.taskmanagement.services;

import com.backend.taskmanagement.dtos.stats.SectorClusterDTO;
import com.backend.taskmanagement.dtos.stats.SectorCountDTO;
import com.backend.taskmanagement.dtos.stats.UserSectorCountDTO;
import com.backend.taskmanagement.entities.TaskEntity;
import com.backend.taskmanagement.repositories.StatsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class StatsService {

    @Autowired
    private StatsRepository statsRepository;

    // 1) ¿Cuántas tareas ha hecho el usuario por sector?
    public List<SectorCountDTO> getTasksBySector(Long userId) {
        List<Object[]> rows = statsRepository.countTasksByUserForSector(userId);
        return rows.stream()
                .map(row -> new SectorCountDTO(
                        (String) row[0],
                        ((Number) row[1]).longValue()
                ))
                .toList();
    }

    // 6) ¿Cuántas tareas ha realizado cada usuario por sector? (Ranking global )
    public List<UserSectorCountDTO> countTasksPerUserBySector() {
        List<Object[]> rows = statsRepository.countTasksPerUserBySector();
        List<UserSectorCountDTO> result = new ArrayList<>();

        for (Object[] row : rows) {
            String username = (String) row[0];
            String sectorName = (String) row[1];
            Long count = ((Number) row[2]).longValue();
            result.add(new UserSectorCountDTO(username, sectorName, count));
        }

        return result;
    }

    // Consultas espaciales utilizando radio

    // 3) ¿Cuál es el sector con más tareas completadas en un radio de 2 kilómetros del usuario?
    public SectorCountDTO getTopSectorWithin2km(Long userId) {
        Object[] row = statsRepository.findTopSectorCompletedWithin2km(userId);
        if (row == null || row.length == 0) {
            return null;
        }
        return new SectorCountDTO(
                (String) row[0],
                ((Number) row[1]).longValue()
        );
    }

    // 7) ¿Cuál es el sector con más tareas completadas dentro de un radio de 5 km
    //desde la ubicación del usuario? (Es la 3 pero usando radio de 5 km)
    public SectorCountDTO getTopSectorWithin5km(Long userId) {
        Object[] row = statsRepository.findTopSectorCompletedWithin5km(userId);
        if (row == null || row.length == 0) {
            return null;
        }
        return new SectorCountDTO(
                (String) row[0],
                ((Number) row[1]).longValue()
        );
    }

    // Distancias y proximidad

    // 2) ¿Cuál es la tarea más cercana al usuario (que esté pendiente)?
    public TaskEntity getClosestPendingTask(Long userId) {
        return statsRepository.findClosestPendingTask(userId);
    }

    // 4) ¿Cuál es el promedio de distancia de las tareas completadas respecto a la ubicación del usuario?
    public Double getAvgDistanceCompleted(Long userId) {
        return statsRepository.averageDistanceCompletedToUser(userId);
    }

    // Agrupación espacial

    // 5) Sectores donde se concentran las tareas pendientes (con centroide)
    public List<SectorClusterDTO> getPendingTasksClusteredBySector(Long userId) {
        List<Object[]> rows = statsRepository.findPendingTasksClusteredBySector(userId);
        List<SectorClusterDTO> result = new ArrayList<>();

        for (Object[] row : rows) {
            String sectorName = (String) row[0];
            Long pendingCount = ((Number) row[1]).longValue();
            String centroidWkt = (String) row[2];
            result.add(new SectorClusterDTO(sectorName, pendingCount, centroidWkt));
        }

        return result;
    }
}