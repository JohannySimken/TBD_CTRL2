package com.backend.taskmanagement.services;

import com.backend.taskmanagement.dtos.task.TaskRequestDTO;
import com.backend.taskmanagement.dtos.task.TaskResponseDTO;
import com.backend.taskmanagement.entities.SectorEntity;
import com.backend.taskmanagement.entities.TaskEntity;
import com.backend.taskmanagement.entities.UserEntity;
import com.backend.taskmanagement.repositories.SectorRepository;
import com.backend.taskmanagement.repositories.TaskRepository;
import com.backend.taskmanagement.repositories.UserRepository;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SectorRepository sectorRepository;

    public TaskResponseDTO createTask(Long userId, TaskRequestDTO dto) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        SectorEntity sector = sectorRepository.findById(dto.getSectorId())
                .orElseThrow(() -> new RuntimeException("Sector no encontrado"));

        TaskEntity task = new TaskEntity();
        task.setUser(user);
        task.setSector(sector);
        task.setTitle(dto.getTitle());
        task.setDescription(dto.getDescription());
        task.setDueDate(LocalDate.parse(dto.getDueDate()));

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(new Coordinate(dto.getLongitude(), dto.getLatitude()));
        task.setLocation(location);

        task.setStatus("PENDING");
        task.setNotificationSent(false);
        task.setCreatedAt(LocalDateTime.now());

        TaskEntity saved = taskRepository.save(task);
        return toResponseDTO(saved);
    }

    public TaskResponseDTO updateTask(Long userId, Long taskId, TaskRequestDTO dto) {
        TaskEntity task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Tarea no encontrada"));

        if (!task.getUser().getId().equals(userId)) {
            throw new RuntimeException("No tienes permisos para editar esta tarea");
        }

        task.setTitle(dto.getTitle());
        task.setDescription(dto.getDescription());
        task.setDueDate(LocalDate.parse(dto.getDueDate()));

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(new Coordinate(dto.getLongitude(), dto.getLatitude()));
        task.setLocation(location);

        if (!task.getSector().getId().equals(dto.getSectorId())) {
            SectorEntity newSector = sectorRepository.findById(dto.getSectorId())
                    .orElseThrow(() -> new RuntimeException("Sector no encontrado"));
            task.setSector(newSector);
        }

        TaskEntity saved = taskRepository.save(task);
        return toResponseDTO(saved);
    }

    public void deleteTask(Long userId, Long taskId) {
        TaskEntity task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Tarea no encontrada"));

        if (!task.getUser().getId().equals(userId)) {
            throw new RuntimeException("No tienes permisos para eliminar esta tarea");
        }

        taskRepository.delete(task);
    }

    public TaskResponseDTO completeTask(Long userId, Long taskId) {
        TaskEntity task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Tarea no encontrada"));

        if (!task.getUser().getId().equals(userId)) {
            throw new RuntimeException("No tienes permisos para completar esta tarea");
        }

        task.setStatus("COMPLETED");
        task.setCompletedAt(LocalDateTime.now());

        TaskEntity saved = taskRepository.save(task);
        return toResponseDTO(saved);
    }

    public List<TaskResponseDTO> getTasks(Long userId, String status, String keyword) {
        List<TaskEntity> tasks;

        if (status != null && keyword != null) {
            tasks = taskRepository.findByUserIdAndStatusAndKeyword(userId, status, keyword);
        } else if (status != null) {
            tasks = taskRepository.findByUserIdAndStatus(userId, status);
        } else if (keyword != null) {
            tasks = taskRepository.findByUserIdAndKeyword(userId, keyword);
        } else {
            tasks = taskRepository.findByUserId(userId);
        }

        return tasks.stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    private TaskResponseDTO toResponseDTO(TaskEntity task) {
        TaskResponseDTO dto = new TaskResponseDTO();
        dto.setId(task.getId());
        dto.setTitle(task.getTitle());
        dto.setDescription(task.getDescription());
        dto.setStatus(task.getStatus());
        dto.setDueDate(task.getDueDate().toString());
        dto.setCompletedAt(task.getCompletedAt() != null ? task.getCompletedAt().toString() : null);
        dto.setSectorName(task.getSector().getName());
        dto.setUsername(task.getUser().getUsername());
        dto.setLatitude(task.getLocation().getY());
        dto.setLongitude(task.getLocation().getX());
        return dto;
    }
}
