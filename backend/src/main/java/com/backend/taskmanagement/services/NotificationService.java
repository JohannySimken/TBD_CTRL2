package com.backend.taskmanagement.services;

import com.backend.taskmanagement.entities.TaskEntity;
import com.backend.taskmanagement.repositories.TaskRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    @Autowired
    private TaskRepository taskRepository;

    /*
     Revisa diariamente (a las 8:00 AM) las tareas pendientes próximas a vencer. Si una tarea vence en los próximos 2 días y aún no se ha enviado notificación,
     la marca como notificada y registra un log.
     */
    @Scheduled(cron = "0 0 8 * * *")
    public void checkUpcomingDueDates() {
        logger.info("Ejecutando revisión de tareas próximas a vencer...");

        List<TaskEntity> tasksNearDue = taskRepository.findTasksNearDueDate();

        if (tasksNearDue.isEmpty()) {
            logger.info("No hay tareas próximas a vencer que requieran notificación.");
            return;
        }

        for (TaskEntity task : tasksNearDue) {
            // Marcar como notificada
            task.setNotificationSent(true);
            taskRepository.save(task);

            // Log de la notificación (en producción se enviaría email/push)
            logger.warn("⚠ NOTIFICACIÓN: La tarea '{}' (ID: {}) del usuario '{}' vence el {}.",
                    task.getTitle(),
                    task.getId(),
                    task.getUser().getUsername(),
                    task.getDueDate()
            );
        }

        logger.info("Se notificaron {} tarea(s) próximas a vencer.", tasksNearDue.size());
    }
}
