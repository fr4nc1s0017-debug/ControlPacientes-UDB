package org.example.controlpacientesudb.dao;

import org.example.controlpacientesudb.modelo.entidades.Visita;
import org.example.controlpacientesudb.util.Conexion;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class VisitaDAO {
    private static final String SELECCIONAR_TODAS_VISITAS =
            "SELECT IDVisita, IDExpediente, IDMedico, FechaHora, Circumstancia, Triage " +
                    "FROM Visita ORDER BY FechaHora DESC";

    private static final String INSERTAR_VISITA =
            "INSERT INTO Visita (IDExpediente, IDMedico, FechaHora, Circumstancia, Triage) VALUES (?, ?, ?, ?, ?)";

    public List<Visita> SeleccionarTodasVisitas() {
        List<Visita> visitas = new ArrayList<>();

        try (Connection connection = Conexion.getConnection();
             PreparedStatement sentencia = connection.prepareStatement(SELECCIONAR_TODAS_VISITAS);
             ResultSet rs = sentencia.executeQuery()) {

            while (rs.next()) {
                Visita visita = new Visita();
                visita.setIdVisita(rs.getInt("IDVisita"));
                visita.setIdExpediente(rs.getInt("IDExpediente"));
                visita.setIdMedico(rs.getInt("IDMedico"));

                // Convertir Timestamp a LocalDateTime para SQL Server
                Timestamp timestamp = rs.getTimestamp("FechaHora");
                if (timestamp != null) {
                    visita.setFechaHora(timestamp.toLocalDateTime());
                }

                visita.setCircumstancia(rs.getString("Circumstancia"));
                visita.setTriage(rs.getString("Triage"));

                visitas.add(visita);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener las visitas: " + e.getMessage());
            e.printStackTrace();
        }
        return visitas;
    }

    public boolean InsertarVisita(Visita visita) {
        boolean insertado = false;
        try (Connection connection = Conexion.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERTAR_VISITA)) {

            preparedStatement.setInt(1, visita.getIdExpediente());
            preparedStatement.setInt(2, visita.getIdMedico());
            preparedStatement.setTimestamp(3, java.sql.Timestamp.valueOf(visita.getFechaHora()));
            preparedStatement.setString(4, visita.getCircumstancia());
            preparedStatement.setString(5, visita.getTriage());

            insertado = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al insertar la visita: " + e.getMessage());
            e.printStackTrace();
        }
        return insertado;
    }
}