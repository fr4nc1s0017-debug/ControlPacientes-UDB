package org.example.controlpacientesudb.modelo.entidades;

public class Medico {
    private int idMedico;
    private String nombre;

    public Medico() {}

    public Medico(int idMedico, String nombre) {
        this.idMedico = idMedico;
        this.nombre = nombre;
    }

    // Getters y Setters
    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
}