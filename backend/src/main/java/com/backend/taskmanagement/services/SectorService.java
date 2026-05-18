package com.backend.taskmanagement.services;

import com.backend.taskmanagement.entities.SectorEntity;
import com.backend.taskmanagement.repositories.SectorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SectorService {

    @Autowired
    private SectorRepository sectorRepository;

    public List<SectorEntity> findAll() {
        return sectorRepository.findAll();
    }

    public SectorEntity findById(Long id) {
        return sectorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Sector no encontrado con id: " + id));
    }

    public SectorEntity save(SectorEntity sector) {
        return sectorRepository.save(sector);
    }

    public SectorEntity update(Long id, SectorEntity sector) {
        SectorEntity existing = findById(id);
        existing.setName(sector.getName());
        existing.setCategory(sector.getCategory());
        existing.setDescription(sector.getDescription());
        existing.setLocation(sector.getLocation());
        return sectorRepository.save(existing);
    }

    public void delete(Long id) {
        findById(id);
        sectorRepository.deleteById(id);
    }
}