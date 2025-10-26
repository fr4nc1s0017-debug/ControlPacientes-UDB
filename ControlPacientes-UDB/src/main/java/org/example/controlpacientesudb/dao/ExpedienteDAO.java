package org.example.controlpacientesudb.dao;

import org.example.controlpacientesudb.modelo.entidades.Expediente;
import org.example.controlpacientesudb.util.Conexion;

import java.sql.*;
import java.time.LocalDate;

public class ExpedienteDAO {
    private static final String INSERT_EXPEDIENTE_SQL =
            "INSERT INTO Expediente (Nombre, Sexo, FechaNacimiento, TipoDocumento, NumeroDocumento, " +
                    "NombreGuardian, TipoDocumentoGuardian, NumeroDocumentoGuardian) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    public boolean insertarExpediente(Expediente expediente) {
        boolean insertado = false;
        try (Connection connection = Conexion.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_EXPEDIENTE_SQL)) {

            preparedStatement.setString(1, expediente.getNombre());
            preparedStatement.setString(2, String.valueOf(expediente.getSexo()));

            // Convertir LocalDate a java.sql.Date
            preparedStatement.setDate(3, Date.valueOf(expediente.getFechaNacimiento()));

            preparedStatement.setString(4, expediente.getTipoDocumento());
            preparedStatement.setString(5, expediente.getNumeroDocumento());
            preparedStatement.setString(6, expediente.getNombreGuardian());
            preparedStatement.setString(7, expediente.getTipoDocumentoGuardian());
            preparedStatement.setString(8, expediente.getNumeroDocumentoGuardian());

            insertado = preparedStatement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al insertar expediente: " + e.getMessage());
            e.printStackTrace();
        }
        return insertado;
    }
}