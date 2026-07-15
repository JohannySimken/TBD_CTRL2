package com.backend.taskmanagement.controllers;

import com.backend.taskmanagement.dtos.stats.SectorClusterDTO;
import com.backend.taskmanagement.dtos.stats.SectorCountDTO;
import com.backend.taskmanagement.dtos.stats.UserSectorCountDTO;
import com.backend.taskmanagement.entities.TaskEntity;
import com.backend.taskmanagement.services.StatsService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
@RestController
@RequestMapping("/api/stats")
public class StatsController {

    @Autowired
    private StatsService statsService;

    // 1) ¿Cuántas tareas ha hecho el usuario por sector?
    @GetMapping("/tasks-by-sector")
    public ResponseEntity<List<SectorCountDTO>> getTasksBySector(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(statsService.getTasksBySector(userId));
    }

    // 6) ¿Cuántas tareas ha realizado cada usuario por sector? (Ranking global )
    @GetMapping("/tasks-per-user-by-sector")
    public ResponseEntity<List<UserSectorCountDTO>> getTasksPerUserBySector() {
        return ResponseEntity.ok(statsService.countTasksPerUserBySector());
    }

    // Consultas espaciales utilizando radio

    // 3) ¿Cuál es el sector con más tareas completadas en un radio de 2 kilómetros del usuario?
    @GetMapping("/top-sector-2km")
    public ResponseEntity<SectorCountDTO> getTopSector2km(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        SectorCountDTO result = statsService.getTopSectorWithin2km(userId);
        if (result == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(result);
    }

    // 7) ¿Cuál es el sector con más tareas completadas dentro de un radio de 5 km
    //desde la ubicación del usuario? (Es la 3 pero usando radio de 5 km)
    @GetMapping("/top-sector-5km")
    public ResponseEntity<SectorCountDTO> getTopSector5km(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        SectorCountDTO result = statsService.getTopSectorWithin5km(userId);
        if (result == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(result);
    }

    // Distancias y proximidad
    // 2) ¿Cuál es la tarea más cercana al usuario (que esté pendiente)?
    @GetMapping("/closest-pending")
    public ResponseEntity<TaskEntity> getClosestPendingTask(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        TaskEntity task = statsService.getClosestPendingTask(userId);
        if (task == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(task);
    }

    // 4) ¿Cuál es el promedio de distancia de las tareas completadas respecto a la ubicación del usuario?
    @GetMapping("/avg-distance-completed")
    public ResponseEntity<Double> getAvgDistanceCompleted(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(statsService.getAvgDistanceCompleted(userId));
    }

    // 4b) Igual que la 4, pero contra un punto arbitrario elegido por el usuario (no el registrado en la BD)
    @GetMapping("/avg-distance-completed-custom")
    public ResponseEntity<Double> getAvgDistanceCompletedCustom(HttpServletRequest request,
                                                                  @RequestParam Double latitude,
                                                                  @RequestParam Double longitude) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(statsService.getAvgDistanceCompletedFromPoint(userId, latitude, longitude));
    }
    // Agrupación espacial
    // 5) Sectores donde se concentran las tareas pendientes (con centroide)
    @GetMapping("/pending-by-sector-cluster")
    public ResponseEntity<List<SectorClusterDTO>> getPendingBySectorCluster(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(statsService.getPendingTasksClusteredBySector(userId));
    }
}