package com.backend.taskmanagement.repositories;

import com.backend.taskmanagement.entities.SectorEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface SectorRepository extends JpaRepository<SectorEntity, Long> {

    Optional<SectorEntity> findByName(String name);
}