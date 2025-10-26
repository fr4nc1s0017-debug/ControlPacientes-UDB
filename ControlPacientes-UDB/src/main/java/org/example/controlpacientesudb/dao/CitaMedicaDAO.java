package org.example.controlpacientesudb.dao;

import org.example.controlpacientesudb.modelo.entidades.CitaMedica;
import org.example.controlpacientesudb.util.Conexion;

import java.sql.*;
        import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CitaMedicaDAO {

    // Obtener todas las citas
    public List<CitaMedica> obtenerTodasCitas() {
        List<CitaMedica> citas = new ArrayList<>();
        String sql = "SELECT * FROM CitaMedica ORDER BY FechaHoraCita DESC";

        try (Connection connection = Conexion.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                CitaMedica cita = mapearCita(rs);
                citas.add(cita);
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener citas: " + e.getMessage());
            e.printStackTrace();
        }
        return citas;
    }

    // Obtener cita por ID
    public CitaMedica obtenerCitaPorId(int idCita) {
        String sql = "SELECT * FROM CitaMedica WHERE IDCita = ?";

        try (Connection connection = Conexion.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, idCita);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearCita(rs);
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener cita: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Insertar nueva cita
    public boolean insertarCita(CitaMedica cita) {
        String sql = "INSERT INTO CitaMedica (IDExpediente, IDMedico, FechaHoraCita, TipoCita, Sintomas, Estado, Observaciones) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = Conexion.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, cita.getIdExpediente());
            stmt.setInt(2, cita.getIdMedico());
            stmt.setTimestamp(3, Timestamp.valueOf(cita.getFechaHoraCita()));
            stmt.setString(4, cita.getTipoCita());
            stmt.setString(5, cita.getSintomas());
            stmt.setString(6, cita.getEstado());
            stmt.setString(7, cita.getObservaciones());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al insertar cita: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Actualizar cita
    public boolean actualizarCita(CitaMedica cita) {
        String sql = "UPDATE CitaMedica SET IDExpediente=?, IDMedico=?, FechaHoraCita=?, TipoCita=?, Sintomas=?, Estado=?, Observaciones=?, FechaModificacion=GETDATE() WHERE IDCita=?";

        try (Connection connection = Conexion.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, cita.getIdExpediente());
            stmt.setInt(2, cita.getIdMedico());
            stmt.setTimestamp(3, Timestamp.valueOf(cita.getFechaHoraCita()));
            stmt.setString(4, cita.getTipoCita());
            stmt.setString(5, cita.getSintomas());
            stmt.setString(6, cita.getEstado());
            stmt.setString(7, cita.getObservaciones());
            stmt.setInt(8, cita.getIdCita());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al actualizar cita: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Eliminar cita
    public boolean eliminarCita(int idCita) {
        String sql = "DELETE FROM CitaMedica WHERE IDCita = ?";

        try (Connection connection = Conexion.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, idCita);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al eliminar cita: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Método auxiliar para mapear ResultSet a objeto CitaMedica
    private CitaMedica mapearCita(ResultSet rs) throws SQLException {
        CitaMedica cita = new CitaMedica();
        cita.setIdCita(rs.getInt("IDCita"));
        cita.setIdExpediente(rs.getInt("IDExpediente"));
        cita.setIdMedico(rs.getInt("IDMedico"));

        Timestamp timestamp = rs.getTimestamp("FechaHoraCita");
        if (timestamp != null) {
            cita.setFechaHoraCita(timestamp.toLocalDateTime());
        }

        cita.setTipoCita(rs.getString("TipoCita"));
        cita.setSintomas(rs.getString("Sintomas"));
        cita.setEstado(rs.getString("Estado"));
        cita.setObservaciones(rs.getString("Observaciones"));

        timestamp = rs.getTimestamp("FechaCreacion");
        if (timestamp != null) {
            cita.setFechaCreacion(timestamp.toLocalDateTime());
        }

        timestamp = rs.getTimestamp("FechaModificacion");
        if (timestamp != null) {
            cita.setFechaModificacion(timestamp.toLocalDateTime());
        }

        return cita;
    }
}