package org.example.controlpacientesudb.dao;

import org.example.controlpacientesudb.modelo.entidades.Paciente;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public class PacienteMemoryDAO {
    private static final List<Paciente> pacientesEnMemoria = new ArrayList<>();
    private static final AtomicInteger idCounter = new AtomicInteger(1000);

    static {
        agregarPacientesEjemplo();
    }

    public List<Paciente> obtenerTodosPacientes() {
        return new ArrayList<>(pacientesEnMemoria);
    }

    public Paciente obtenerPacientePorId(int idPaciente) {
        return pacientesEnMemoria.stream()
                .filter(p -> p.getIdPaciente() == idPaciente)
                .findFirst()
                .orElse(null);
    }

    public boolean insertarPaciente(Paciente paciente) {
        try {
            paciente.setIdPaciente(idCounter.getAndIncrement());
            pacientesEnMemoria.add(paciente);
            System.out.println("Nuevo paciente registrado: " + paciente.getNombreCompleto());
            return true;
        } catch (Exception e) {
            System.out.println("Error guardando paciente: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarPaciente(Paciente pacienteActualizado) {
        for (int i = 0; i < pacientesEnMemoria.size(); i++) {
            if (pacientesEnMemoria.get(i).getIdPaciente() == pacienteActualizado.getIdPaciente()) {
                pacientesEnMemoria.set(i, pacienteActualizado);
                System.out.println("Paciente actualizado: " + pacienteActualizado.getNombreCompleto());
                return true;
            }
        }
        return false;
    }

    public boolean eliminarPaciente(int idPaciente) {
        boolean eliminado = pacientesEnMemoria.removeIf(p -> p.getIdPaciente() == idPaciente);
        if (eliminado) {
            System.out.println("Paciente eliminado ID: " + idPaciente);
        }
        return eliminado;
    }

    private static void agregarPacientesEjemplo() {
        // Pacientes de ejemplo
        agregarPaciente("María López García", LocalDate.of(1990, 5, 15), "Femenino", "7777-8888", "maria@email.com", "San Salvador");
        agregarPaciente("Carlos Ruiz Hernández", LocalDate.of(1985, 8, 22), "Masculino", "7777-9999", "carlos@email.com", "Santa Tecla");
        agregarPaciente("Ana Martínez Rodríguez", LocalDate.of(1978, 12, 3), "Femenino", "7777-7777", "ana@email.com", "Soyapango");
        agregarPaciente("Roberto Sánchez Pérez", LocalDate.of(1995, 3, 10), "Masculino", "7777-6666", "roberto@email.com", "Mejicanos");
        agregarPaciente("Laura García de Jesús", LocalDate.of(1988, 7, 25), "Femenino", "7777-5555", "laura@email.com", "Apopa");
    }

    private static void agregarPaciente(String nombre, LocalDate fechaNac, String sexo, String telefono, String email, String direccion) {
        Paciente paciente = new Paciente(nombre, fechaNac, sexo, telefono, email, direccion);
        paciente.setIdPaciente(idCounter.getAndIncrement());
        pacientesEnMemoria.add(paciente);
    }
}