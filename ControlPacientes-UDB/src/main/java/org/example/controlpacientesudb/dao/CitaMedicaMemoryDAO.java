package org.example.controlpacientesudb.dao;

import org.example.controlpacientesudb.modelo.entidades.CitaMedica;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public class CitaMedicaMemoryDAO {
    private static final List<CitaMedica> citasEnMemoria = new ArrayList<>();
    private static final AtomicInteger idCounter = new AtomicInteger(1000); // Empezar desde 1000 para distinguir

    // Datos de ejemplo más realistas
    static {
        agregarCitasEjemplo();
    }

    public List<CitaMedica> obtenerTodasCitas() {
        System.out.println("=== OBTAINING CITAS FROM MEMORY ===");
        System.out.println("Total citas en memoria: " + citasEnMemoria.size());
        citasEnMemoria.forEach(cita -> {
            System.out.println("Cita ID: " + cita.getIdCita() +
                    ", Paciente: " + cita.getIdExpediente() +
                    ", Estado: " + cita.getEstado());
        });
        return new ArrayList<>(citasEnMemoria);
    }

    public boolean insertarCita(CitaMedica cita) {
        try {
            // Asignar ID único
            int nuevoId = idCounter.getAndIncrement();
            cita.setIdCita(nuevoId);
            cita.setFechaCreacion(LocalDateTime.now());

            // Agregar a la lista
            citasEnMemoria.add(cita);

            System.out.println("=== NUEVA CITA AGENDADA ===");
            System.out.println("ID: " + cita.getIdCita());
            System.out.println("Expediente: " + cita.getIdExpediente());
            System.out.println("Médico: " + cita.getIdMedico());
            System.out.println("Fecha: " + cita.getFechaHoraCita());
            System.out.println("Tipo: " + cita.getTipoCita());
            System.out.println("Estado: " + cita.getEstado());
            System.out.println("Total citas ahora: " + citasEnMemoria.size());

            return true;
        } catch (Exception e) {
            System.out.println("ERROR guardando cita en memoria: " + e.getMessage());
            return false;
        }
    }

    public CitaMedica obtenerCitaPorId(int idCita) {
        return citasEnMemoria.stream()
                .filter(c -> c.getIdCita() == idCita)
                .findFirst()
                .orElse(null);
    }

    public boolean actualizarCita(CitaMedica citaActualizada) {
        for (int i = 0; i < citasEnMemoria.size(); i++) {
            CitaMedica citaExistente = citasEnMemoria.get(i);
            if (citaExistente.getIdCita() == citaActualizada.getIdCita()) {
                // Mantener la fecha de creación original
                citaActualizada.setFechaCreacion(citaExistente.getFechaCreacion());
                citasEnMemoria.set(i, citaActualizada);

                System.out.println("=== CITA ACTUALIZADA ===");
                System.out.println("ID: " + citaActualizada.getIdCita());
                System.out.println("Nuevo estado: " + citaActualizada.getEstado());

                return true;
            }
        }
        return false;
    }

    public boolean eliminarCita(int idCita) {
        boolean eliminado = citasEnMemoria.removeIf(c -> c.getIdCita() == idCita);
        if (eliminado) {
            System.out.println("=== CITA ELIMINADA ===");
            System.out.println("ID eliminado: " + idCita);
            System.out.println("Citas restantes: " + citasEnMemoria.size());
        }
        return eliminado;
    }

    private static void agregarCitasEjemplo() {
        System.out.println("=== INICIALIZANDO CITAS DE EJEMPLO ===");

        // Cita 1
        CitaMedica cita1 = new CitaMedica();
        cita1.setIdCita(idCounter.getAndIncrement());
        cita1.setIdExpediente(101);
        cita1.setIdMedico(1);
        cita1.setFechaHoraCita(LocalDateTime.now().plusDays(1).withHour(10).withMinute(0));
        cita1.setTipoCita("Consulta General");
        cita1.setSintomas("Dolor de cabeza persistente");
        cita1.setEstado("Pendiente");
        cita1.setObservaciones("Primera consulta del paciente");
        cita1.setFechaCreacion(LocalDateTime.now());
        citasEnMemoria.add(cita1);

        // Cita 2
        CitaMedica cita2 = new CitaMedica();
        cita2.setIdCita(idCounter.getAndIncrement());
        cita2.setIdExpediente(102);
        cita2.setIdMedico(2);
        cita2.setFechaHoraCita(LocalDateTime.now().plusDays(2).withHour(14).withMinute(30));
        cita2.setTipoCita("Control");
        cita2.setSintomas("Seguimiento de tratamiento médico");
        cita2.setEstado("Confirmada");
        cita2.setObservaciones("Traer resultados de exámenes");
        cita2.setFechaCreacion(LocalDateTime.now());
        citasEnMemoria.add(cita2);

        // Cita 3
        CitaMedica cita3 = new CitaMedica();
        cita3.setIdCita(idCounter.getAndIncrement());
        cita3.setIdExpediente(103);
        cita3.setIdMedico(1);
        cita3.setFechaHoraCita(LocalDateTime.now().plusHours(3));
        cita3.setTipoCita("Emergencia");
        cita3.setSintomas("Fiebre alta y malestar general");
        cita3.setEstado("Completada");
        cita3.setObservaciones("Paciente estable después de atención");
        cita3.setFechaCreacion(LocalDateTime.now().minusDays(1));
        citasEnMemoria.add(cita3);

        System.out.println("Citas de ejemplo creadas: " + citasEnMemoria.size());
    }
}