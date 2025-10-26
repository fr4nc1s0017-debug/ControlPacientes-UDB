package org.example.controlpacientesudb.modelo.entidades;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Visita {
    private int idVisita;
    private int idExpediente;
    private int idMedico;
    private LocalDateTime fechaHora;
    private String circumstancia;
    private String triage;

    public Visita() {}

    public Visita(int idVisita, int idExpediente, int idMedico, LocalDateTime fechaHora, String circumstancia, String triage) {
        this.idVisita = idVisita;
        this.idExpediente = idExpediente;
        this.idMedico = idMedico;
        this.fechaHora = fechaHora;
        this.circumstancia = circumstancia;
        this.triage = triage;
    }

    // Getters y Setters (los que ya tenías)
    public int getIdVisita() { return idVisita; }
    public void setIdVisita(int idVisita) { this.idVisita = idVisita; }

    public int getIdExpediente() { return idExpediente; }
    public void setIdExpediente(int idExpediente) { this.idExpediente = idExpediente; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }

    public String getCircumstancia() { return circumstancia; }
    public void setCircumstancia(String circumstancia) { this.circumstancia = circumstancia; }

    public String getTriage() { return triage; }
    public void setTriage(String triage) { this.triage = triage; }

    // Métodos auxiliares para formatear fechas
    public String getFechaHoraFormateada() {
        if (fechaHora != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            return fechaHora.format(formatter);
        }
        return "";
    }

    public String getSoloFecha() {
        if (fechaHora != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            return fechaHora.format(formatter);
        }
        return "";
    }

    public String getSoloHora() {
        if (fechaHora != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
            return fechaHora.format(formatter);
        }
        return "";
    }
}