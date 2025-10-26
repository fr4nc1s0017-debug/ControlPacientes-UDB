package org.example.controlpacientesudb.modelo.entidades;
import java.time.LocalDateTime;

public class Atencion {
    private int idAtencion;
    private int idVisita;
    private int idMedico;
    private LocalDateTime fechaHora;
    private String consultaPor;
    private String presenteEnfermedad;
    private String diagnostico;
    private String tratamiento;
    private String anotaciones;

    public Atencion() {}

    public Atencion(int idVisita, int idMedico, LocalDateTime fechaHora, String consultaPor, String presenteEnfermedad, String diagnostico, String tratamiento, String anotaciones) {
        this.idVisita = idVisita;
        this.idMedico = idMedico;
        this.fechaHora = fechaHora;
        this.consultaPor = consultaPor;
        this.presenteEnfermedad = presenteEnfermedad;
        this.diagnostico = diagnostico;
        this.tratamiento = tratamiento;
        this.anotaciones = anotaciones;
    }

    public Atencion(int idAtencion, int idVisita, int idMedico, LocalDateTime fechaHora, String consultaPor, String presenteEnfermedad, String diagnostico, String tratamiento, String anotaciones) {
        this.idAtencion = idAtencion;
        this.idVisita = idVisita;
        this.idMedico = idMedico;
        this.fechaHora = fechaHora;
        this.consultaPor = consultaPor;
        this.presenteEnfermedad = presenteEnfermedad;
        this.diagnostico = diagnostico;
        this.tratamiento = tratamiento;
        this.anotaciones = anotaciones;
    }

    // Getters y Setters
    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }

    public int getIdVisita() { return idVisita; }
    public void setIdVisita(int idVisita) { this.idVisita = idVisita; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public LocalDateTime getFechaHora() { return fechaHora; }
    public void setFechaHora(LocalDateTime fechaHora) { this.fechaHora = fechaHora; }

    public String getConsultaPor() { return consultaPor; }
    public void setConsultaPor(String consultaPor) { this.consultaPor = consultaPor; }

    public String getPresenteEnfermedad() { return presenteEnfermedad; }
    public void setPresenteEnfermedad(String presenteEnfermedad) { this.presenteEnfermedad = presenteEnfermedad; }

    public String getDiagnostico() { return diagnostico; }
    public void setDiagnostico(String diagnostico) { this.diagnostico = diagnostico; }

    public String getTratamiento() { return tratamiento; }
    public void setTratamiento(String tratamiento) { this.tratamiento = tratamiento; }

    public String getAnotaciones() { return anotaciones; }
    public void setAnotaciones(String anotaciones) { this.anotaciones = anotaciones; }
}