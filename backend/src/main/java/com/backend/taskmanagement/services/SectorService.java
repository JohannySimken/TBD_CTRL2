package com.backend.taskmanagement.services;

import com.backend.taskmanagement.dtos.sector.SectorResponseDTO;
import com.backend.taskmanagement.entities.SectorEntity;
import com.backend.taskmanagement.repositories.SectorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SectorService {

    @Autowired
    private SectorRepository sectorRepository;

    public List<SectorResponseDTO> findAll() {
        return sectorRepository.findAll().stream().map(this::toDTO).toList();
    }

    public SectorResponseDTO findById(Long id) {
        return toDTO(sectorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Sector no encontrado con id: " + id)));
    }

    public SectorEntity save(SectorEntity sector) {
        return sectorRepository.save(sector);
    }

    public SectorEntity update(Long id, SectorEntity sector) {
        SectorEntity existing = sectorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Sector no encontrado con id: " + id));
        existing.setName(sector.getName());
        existing.setCategory(sector.getCategory());
        existing.setDescription(sector.getDescription());
        existing.setLocation(sector.getLocation());
        return sectorRepository.save(existing);
    }

    public void delete(Long id) {
        sectorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Sector no encontrado con id: " + id));
        sectorRepository.deleteById(id);
    }

    private SectorResponseDTO toDTO(SectorEntity s) {
        Double lat = s.getLocation() != null ? s.getLocation().getY() : null;
        Double lng = s.getLocation() != null ? s.getLocation().getX() : null;
        return new SectorResponseDTO(s.getId(), s.getName(), s.getCategory(), s.getDescription(), lat, lng);
    }
}