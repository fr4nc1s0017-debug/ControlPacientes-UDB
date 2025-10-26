package org.example.controlpacientesudb.modelo.entidades;
import java.time.LocalDateTime;

public class Asistencia {
    private int idAsistencia;
    private int idMedico;
    private LocalDateTime fechaHoraEntrada;
    private LocalDateTime fechaHoraSalida;
    private String notas;

    public Asistencia() {}

    public Asistencia(int idMedico, LocalDateTime fechaHoraEntrada, LocalDateTime fechaHoraSalida, String notas) {
        this.idMedico = idMedico;
        this.fechaHoraEntrada = fechaHoraEntrada;
        this.fechaHoraSalida = fechaHoraSalida;
        this.notas = notas;
    }

    public Asistencia(int idAsistencia, int idMedico, LocalDateTime fechaHoraEntrada, LocalDateTime fechaHoraSalida, String notas) {
        this.idAsistencia = idAsistencia;
        this.idMedico = idMedico;
        this.fechaHoraEntrada = fechaHoraEntrada;
        this.fechaHoraSalida = fechaHoraSalida;
        this.notas = notas;
    }

    // Getters y Setters
    public int getIdAsistencia() { return idAsistencia; }
    public void setIdAsistencia(int idAsistencia) { this.idAsistencia = idAsistencia; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public LocalDateTime getFechaHoraEntrada() { return fechaHoraEntrada; }
    public void setFechaHoraEntrada(LocalDateTime fechaHoraEntrada) { this.fechaHoraEntrada = fechaHoraEntrada; }

    public LocalDateTime getFechaHoraSalida() { return fechaHoraSalida; }
    public void setFechaHoraSalida(LocalDateTime fechaHoraSalida) { this.fechaHoraSalida = fechaHoraSalida; }

    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }
}