package org.example.controlpacientesudb.modelo.entidades;
import java.time.LocalDate;

public class Expediente {
    private int idExpediente;
    private String nombre;
    private char sexo;
    private LocalDate fechaNacimiento;
    private String tipoDocumento;
    private String numeroDocumento;
    private String nombreGuardian;
    private String tipoDocumentoGuardian;
    private String numeroDocumentoGuardian;

    public Expediente() {}

    public Expediente(int idExpediente, String nombre, char sexo, LocalDate fechaNacimiento, String tipoDocumento, String numeroDocumento, String nombreGuardian, String tipoDocumentoGuardian, String numeroDocumentoGuardian) {
        this.idExpediente = idExpediente;
        this.nombre = nombre;
        this.sexo = sexo;
        this.fechaNacimiento = fechaNacimiento;
        this.tipoDocumento = tipoDocumento;
        this.numeroDocumento = numeroDocumento;
        this.nombreGuardian = nombreGuardian;
        this.tipoDocumentoGuardian = tipoDocumentoGuardian;
        this.numeroDocumentoGuardian = numeroDocumentoGuardian;
    }

    // Getters y Setters
    public int getIdExpediente() { return idExpediente; }
    public void setIdExpediente(int idExpediente) { this.idExpediente = idExpediente; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public char getSexo() { return sexo; }
    public void setSexo(char sexo) { this.sexo = sexo; }

    public LocalDate getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(LocalDate fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public String getTipoDocumento() { return tipoDocumento; }
    public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }

    public String getNumeroDocumento() { return numeroDocumento; }
    public void setNumeroDocumento(String numeroDocumento) { this.numeroDocumento = numeroDocumento; }

    public String getNombreGuardian() { return nombreGuardian; }
    public void setNombreGuardian(String nombreGuardian) { this.nombreGuardian = nombreGuardian; }

    public String getTipoDocumentoGuardian() { return tipoDocumentoGuardian; }
    public void setTipoDocumentoGuardian(String tipoDocumentoGuardian) { this.tipoDocumentoGuardian = tipoDocumentoGuardian; }

    public String getNumeroDocumentoGuardian() { return numeroDocumentoGuardian; }
    public void setNumeroDocumentoGuardian(String numeroDocumentoGuardian) { this.numeroDocumentoGuardian = numeroDocumentoGuardian; }
}