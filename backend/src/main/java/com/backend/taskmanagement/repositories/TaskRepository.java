package com.backend.taskmanagement.repositories;

import com.backend.taskmanagement.entities.TaskEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<TaskEntity, Long> {

    List<TaskEntity> findByUserId(Long userId);

    List<TaskEntity> findByUserIdAndStatus(Long userId, String status);

    @Query(value = """
        SELECT * FROM tasks t
        WHERE t.user_id = :userId
            AND (LOWER(t.title) LIKE LOWER(CONCAT('%%', :keyword, '%%'))
                OR LOWER(t.description) LIKE LOWER(CONCAT('%%', :keyword, '%%')))
        """, nativeQuery = true)
    List<TaskEntity> findByUserIdAndKeyword(@Param("userId") Long userId, @Param("keyword") String keyword);

    @Query(value = """
        SELECT * FROM tasks t
        WHERE t.user_id = :userId
            AND t.status = :status
            AND (LOWER(t.title) LIKE LOWER(CONCAT('%%', :keyword, '%%'))
                OR LOWER(t.description) LIKE LOWER(CONCAT('%%', :keyword, '%%')))
        """, nativeQuery = true)
    List<TaskEntity> findByUserIdAndStatusAndKeyword(@Param("userId") Long userId, @Param("status") String status, @Param("keyword") String keyword);

    // Para notificaciones: tareas próximas a vencer (dentro de una semana)
    @Query(value = """
        SELECT * FROM tasks t
        WHERE t.status = 'PENDING'
            AND t.notification_sent = false
            AND t.due_date <= NOW() + INTERVAL '7 days'
            AND t.due_date >= NOW()
        """, nativeQuery = true)
    List<TaskEntity> findTasksNearDueDate();

    // Marca como EXPIRED las tareas pendientes cuyo vencimiento (fecha y hora) ya pasó
    @Modifying
    @Query(value = """
        UPDATE tasks SET status = 'EXPIRED'
        WHERE status = 'PENDING' AND due_date < NOW()
        """, nativeQuery = true)
    int expireOverdueTasks();
}
