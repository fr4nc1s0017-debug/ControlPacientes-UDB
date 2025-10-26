package org.example.controlpacientesudb.modelo.entidades;
import java.time.LocalDateTime;

public class CitaMedica {
    private int idCita;
    private int idExpediente;
    private int idMedico;
    private LocalDateTime fechaHoraCita;
    private String tipoCita;
    private String sintomas;
    private String estado;
    private String observaciones;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaModificacion;

    // Constructores
    public CitaMedica() {}

    public CitaMedica(int idExpediente, int idMedico, LocalDateTime fechaHoraCita,
                      String tipoCita, String sintomas, String estado, String observaciones) {
        this.idExpediente = idExpediente;
        this.idMedico = idMedico;
        this.fechaHoraCita = fechaHoraCita;
        this.tipoCita = tipoCita;
        this.sintomas = sintomas;
        this.estado = estado;
        this.observaciones = observaciones;
    }

    // Getters y Setters
    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }

    public int getIdExpediente() { return idExpediente; }
    public void setIdExpediente(int idExpediente) { this.idExpediente = idExpediente; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public LocalDateTime getFechaHoraCita() { return fechaHoraCita; }
    public void setFechaHoraCita(LocalDateTime fechaHoraCita) { this.fechaHoraCita = fechaHoraCita; }

    public String getTipoCita() { return tipoCita; }
    public void setTipoCita(String tipoCita) { this.tipoCita = tipoCita; }

    public String getSintomas() { return sintomas; }
    public void setSintomas(String sintomas) { this.sintomas = sintomas; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public LocalDateTime getFechaModificacion() { return fechaModificacion; }
    public void setFechaModificacion(LocalDateTime fechaModificacion) { this.fechaModificacion = fechaModificacion; }
}