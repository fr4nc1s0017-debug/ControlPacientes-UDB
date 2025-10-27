package org.example.controlpacientesudb.dao;

import org.example.controlpacientesudb.modelo.entidades.Visita;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class VisitaMemoryDAO {
    private static final List<Visita> visitasEnMemoria = new ArrayList<>();
    private static final AtomicInteger idCounter = new AtomicInteger(2000);

    static {
        agregarVisitasEjemplo();
    }

    // AGREGA ESTE MÉTODO A TU CLASE VisitaMemoryDAO
    public Map<Integer, String> obtenerMedicos() {
        Map<Integer, String> medicos = new HashMap<>();
        medicos.put(1, "Dr. Juan Pérez");
        medicos.put(2, "Dra. Ana Gómez");
        medicos.put(3, "Dr. Carlos Rodríguez");
        medicos.put(4, "Dra. María López");
        medicos.put(5, "Dr. Roberto Sánchez");
        return medicos;
    }

    // El resto de tus métodos existentes...
    public List<Visita> obtenerTodasVisitas() {
        return new ArrayList<>(visitasEnMemoria);
    }

    public List<Visita> buscarVisitasConFiltros(Integer idPaciente, LocalDateTime fechaDesde, LocalDateTime fechaHasta, String triage) {
        List<Visita> visitasFiltradas = visitasEnMemoria.stream()
                .filter(visita -> {
                    boolean coincide = true;

                    // Filtro por paciente (antes era expediente)
                    if (idPaciente != null) {
                        coincide = coincide && (visita.getIdExpediente() == idPaciente);
                    }

                    // Filtro por fecha desde
                    if (fechaDesde != null) {
                        coincide = coincide && (visita.getFechaHora().isAfter(fechaDesde) || visita.getFechaHora().isEqual(fechaDesde));
                    }

                    // Filtro por fecha hasta
                    if (fechaHasta != null) {
                        coincide = coincide && (visita.getFechaHora().isBefore(fechaHasta) || visita.getFechaHora().isEqual(fechaHasta));
                    }

                    // Filtro por triage
                    if (triage != null && !triage.isEmpty() && !"Todos".equals(triage)) {
                        coincide = coincide && triage.equals(visita.getTriage());
                    }

                    return coincide;
                })
                .collect(Collectors.toList());

        System.out.println("Visitas filtradas: " + visitasFiltradas.size() +
                " | Filtros: Paciente=" + idPaciente +
                ", Desde=" + fechaDesde +
                ", Hasta=" + fechaHasta +
                ", Triage=" + triage);

        return visitasFiltradas;
    }

    public boolean insertarVisita(Visita visita) {
        try {
            visita.setIdVisita(idCounter.getAndIncrement());
            visitasEnMemoria.add(visita);
            System.out.println("Nueva visita agregada: ID=" + visita.getIdVisita());
            return true;
        } catch (Exception e) {
            System.out.println("Error guardando visita: " + e.getMessage());
            return false;
        }
    }

    private static void agregarVisitasEjemplo() {
        System.out.println("=== INICIALIZANDO VISITAS DE EJEMPLO ===");

        // Visitas para diferentes expedientes y fechas
        agregarVisita(101, 1, LocalDateTime.now().minusDays(2), "Consulta de rutina", "Verde");
        agregarVisita(102, 2, LocalDateTime.now().minusDays(1), "Dolor abdominal", "Amarillo");
        agregarVisita(103, 1, LocalDateTime.now().minusHours(6), "Fiebre alta", "Rojo");
        agregarVisita(101, 3, LocalDateTime.now().minusDays(5), "Control post-operatorio", "Verde");
        agregarVisita(104, 2, LocalDateTime.now().minusDays(3), "Emergencia respiratoria", "Rojo");
        agregarVisita(102, 1, LocalDateTime.now().minusHours(12), "Revisión de resultados", "Verde");
        agregarVisita(105, 3, LocalDateTime.now().minusDays(7), "Vacunación", "Verde");
        agregarVisita(103, 2, LocalDateTime.now().minusDays(4), "Trauma por accidente", "Negro");

        System.out.println("Total visitas de ejemplo: " + visitasEnMemoria.size());
    }

    private static void agregarVisita(int expediente, int medico, LocalDateTime fecha, String circunstancia, String triage) {
        Visita visita = new Visita();
        visita.setIdVisita(idCounter.getAndIncrement());
        visita.setIdExpediente(expediente);
        visita.setIdMedico(medico);
        visita.setFechaHora(fecha);
        visita.setCircumstancia(circunstancia);
        visita.setTriage(triage);
        visitasEnMemoria.add(visita);
    }

    // Método para obtener expedientes únicos (para el dropdown)
    public List<Integer> obtenerExpedientesUnicos() {
        return visitasEnMemoria.stream()
                .map(Visita::getIdExpediente)
                .distinct()
                .sorted()
                .collect(Collectors.toList());
    }
}