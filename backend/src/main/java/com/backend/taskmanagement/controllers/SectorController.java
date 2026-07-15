package com.backend.taskmanagement.controllers;

import com.backend.taskmanagement.dtos.sector.SectorResponseDTO;
import com.backend.taskmanagement.entities.SectorEntity;
import com.backend.taskmanagement.services.SectorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sectors")
public class SectorController {

    @Autowired
    private SectorService sectorService;

    @GetMapping
    public ResponseEntity<List<SectorResponseDTO>> getAll() {
        return ResponseEntity.ok(sectorService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<SectorResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(sectorService.findById(id));
    }

    //solo el rol de ADMIN  crea, edita y elimina sectores
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<SectorEntity> create(@RequestBody SectorEntity sector) {
        return ResponseEntity.ok(sectorService.save(sector));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<SectorEntity> update(@PathVariable Long id, @RequestBody SectorEntity sector) {
        return ResponseEntity.ok(sectorService.update(id, sector));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        sectorService.delete(id);
        return ResponseEntity.noContent().build();
    }
}