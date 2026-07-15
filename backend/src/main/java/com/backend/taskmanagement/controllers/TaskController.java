package com.backend.taskmanagement.controllers;

import com.backend.taskmanagement.dtos.task.TaskRequestDTO;
import com.backend.taskmanagement.dtos.task.TaskResponseDTO;
import com.backend.taskmanagement.services.TaskService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    @Autowired
    private TaskService taskService;

    @PostMapping
    public ResponseEntity<TaskResponseDTO> createTask(HttpServletRequest request, @RequestBody TaskRequestDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(taskService.createTask(userId, dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TaskResponseDTO> updateTask(HttpServletRequest request, @PathVariable Long id, @RequestBody TaskRequestDTO dto) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(taskService.updateTask(userId, id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        taskService.deleteTask(userId, id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/complete")
    public ResponseEntity<TaskResponseDTO> completeTask(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(taskService.completeTask(userId, id));
    }

    @PatchMapping("/{id}/revert")
    public ResponseEntity<TaskResponseDTO> revertTask(HttpServletRequest request, @PathVariable Long id) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(taskService.revertTask(userId, id));
    }

    @GetMapping
    public ResponseEntity<List<TaskResponseDTO>> getTasks(HttpServletRequest request,
                                                          @RequestParam(required = false) String status,
                                                          @RequestParam(required = false) String keyword) {
        Long userId = (Long) request.getAttribute("userId");
        return ResponseEntity.ok(taskService.getTasks(userId, status, keyword));
    }
}
