package com.backend.taskmanagement.repositories;

import com.backend.taskmanagement.entities.TaskEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StatsRepository extends JpaRepository<TaskEntity, Long> {

    //1- ¿Cuántas tareas ha hecho el usuario por sector?
    @Query(value = """
    SELECT s.name AS sector_name, COUNT(t.id) as task_count
    FROM tasks t
    JOIN sectors s ON t.sector_id = s.id
    WHERE t.user_id = :userId AND t.status = 'COMPLETED'
    GROUP BY s.name
    ORDER BY task_count DESC
    """, nativeQuery = true)
    List<Object[]> countTasksByUserForSector(@Param("userId") Long userId);


    //2- ¿Cuál es la tarea más cercana al usuario (que esté pendiente)?
    @Query(value = """
    SELECT t.* FROM tasks t 
    JOIN users u ON u.id = t.user_id
    WHERE u.id= :userId
        AND t.status = 'PENDING'
    ORDER BY ST_Distance(t.location::geography, u.location::geography) ASC LIMIT 1
    """, nativeQuery = true)
    TaskEntity findClosestPendingTask(@Param("userId") Long userId);

    //3- ¿Cuál es el sector con más tareas completadas en un radio de 2 kilómetros del usuario?
    @Query(value = """
    SELECT s.name AS sector_name, COUNT(t.id) as completed_count
    FROM tasks t
    JOIN sectors s on t.sector_id = s.id
    CROSS JOIN users u 
    WHERE u.id= :userId
        AND t.user_id = :userId
        AND t.status = 'COMPLETED'
        and ST_DWithin(t.location::geography, u.location::geography, 2000)
    GROUP BY s.name
    ORDER BY completed_count DESC LIMIT 1
    """, nativeQuery = true)
    Object[] findTopSectorCompletedWithin2km(@Param("userId") Long userId);

    //4- ¿Cuál es el promedio de distancia de las tareas completadas respecto a la ubicación del usuario?
    @Query(value = """
    SELECT AVG(ST_DISTANCE(t.location, u.location)) AS avg_distance
    FROM tasks t
    CROSS JOIN users u
    WHERE u.id = :userId
        AND t.user_id = :userId
        AND t.status = 'COMPLETED'
    """, nativeQuery = true)
    Double averageDistanceCompletedTasks(@Param("userId") Long userId);

    //5- ¿En qué sectores geográficos se concentran la mayoría de las tareas pendientes? (utilizando agrupación espacial).
    @Query(value = """
    SELECT s.name AS sector_name,
        COUNT(t.id) AS pending_count,
        ST_AsText(ST_Centroid(ST_Collect(t.location::geometry))) AS centroid_wkt
    FROM tasks t 
    JOIN sectors s ON t.sector_id = s.id
    WHERE t.user_id = :userId
        AND t.status = 'PENDING'
    GROUP BY s.name
    ORDER BY pending_count DESC
    """, nativeQuery = true)
    List<Object[]> findPendingTasksClusteredBySector(@Param("userId") Long userId);

    //6- ¿Cuántas tareas ha realizado cada usuario por sector?
    @Query(value = """
    SELECT u.username, s.name AS sector_name, COUNT(t.id) AS task_count
    FROM tasks t
    JOIN users u ON t.user_id = u.id
    JOIN sectors s ON t.sector_id = s.id
    WHERE t.status = 'COMPLETED'
    GROUP BY u.username, s.name
    ORDER BY task_count DESC
    """, nativeQuery = true)
    List<Object[]> countTasksPerUserBySector();

    //7- ¿Cuál es el sector con más tareas completadas dentro de un radio de 5 km desde la ubicación del usuario?
    @Query(value = """
    SELECT s.name AS sector_name, COUNT(t.id) as completed_count
    FROM tasks t
    JOIN sectors s on t.sector_id = s.id
    CROSS JOIN users u 
    WHERE u.id= :userId
        AND t.user_id = :userId
        AND t.status = 'COMPLETED'
        AND ST_DWithin(t.location::geography, u.location::geography, 5000)
    GROUP BY s.name
    ORDER BY completed_count DESC LIMIT 1
    """, nativeQuery = true)
    Object[] findTopSectorCompletedWithin5km(@Param("userId") Long userId);

    //8- ¿Cuál es el promedio de distancia entre las tareas completadas y el punto registrado del usuario?
    @Query(value = """
    SELECT AVG(ST_Distance(t.location::geography, u.location::geography)) AS avg_distance
    FROM tasks t 
    CROSS JOIN users u
    WHERE u.id = :userId
        AND t.user_id = :userId
        AND t.status = 'COMPLETED'
""", nativeQuery = true)
    Double averageDistanceCompletedToUser(@Param("userId") Long userId);

}
