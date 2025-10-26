package org.example.controlpacientesudb.modelo.entidades;

import java.time.LocalDate;

public class Paciente {
    private int idPaciente;
    private String nombreCompleto;
    private LocalDate fechaNacimiento;
    private String sexo;
    private String telefono;
    private String email;
    private String direccion;

    public Paciente() {}

    public Paciente(String nombreCompleto, LocalDate fechaNacimiento, String sexo, String telefono, String email, String direccion) {
        this.nombreCompleto = nombreCompleto;
        this.fechaNacimiento = fechaNacimiento;
        this.sexo = sexo;
        this.telefono = telefono;
        this.email = email;
        this.direccion = direccion;
    }

    // Getters y Setters
    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public LocalDate getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(LocalDate fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    // Método para calcular edad
    public int getEdad() {
        if (fechaNacimiento == null) return 0;
        return LocalDate.now().getYear() - fechaNacimiento.getYear();
    }
}