package org.example.controlpacientesudb.modelo.entidades;
import java.time.LocalDateTime;

public class Agenda {
    private int idAgenda;
    private int idMedico;
    private LocalDateTime fechaHora;

    public Agenda() {}

    public Agenda(int idAgenda, int idMedico, LocalDateTime fechaHora) {
        this.idAgenda = idAgenda;
        this.idMedico = idMedico;
        this.fechaHora = fechaHora;
    }

    // Getters y Setters
    public int getIdAgenda() { return idAgenda; }
    public void setIdAgenda(int idAgenda) { this.idAgenda = idAgenda; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }
}