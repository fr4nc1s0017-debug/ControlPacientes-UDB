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

        // Primero intentar con la base de datos real
        try {
            String sql = "SELECT * FROM CitaMedica ORDER BY FechaHoraCita DESC";

            try (Connection connection = Conexion.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    CitaMedica cita = mapearCita(rs);
                    citas.add(cita);
                }
                System.out.println("Citas obtenidas de BD: " + citas.size());
                return citas;

            }
        } catch (Exception e) {
            System.out.println("Error al obtener citas de BD: " + e.getMessage());
            // Si hay error, devolver lista vacía
            return new ArrayList<>();
        }
    }

    // Insertar nueva cita (versión mejorada)
    public boolean insertarCita(CitaMedica cita) {
        System.out.println("Intentando insertar cita en BD...");

        // Primero intentar con BD real
        try {
            String sql = "INSERT INTO CitaMedica (IDExpediente, IDMedico, FechaHoraCita, TipoCita, Sintomas, Estado, Observaciones) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (Connection connection = Conexion.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                stmt.setInt(1, cita.getIdExpediente());
                stmt.setInt(2, cita.getIdMedico());
                stmt.setTimestamp(3, Timestamp.valueOf(cita.getFechaHoraCita()));
                stmt.setString(4, cita.getTipoCita());
                stmt.setString(5, cita.getSintomas());
                stmt.setString(6, cita.getEstado());
                stmt.setString(7, cita.getObservaciones());

                int filasAfectadas = stmt.executeUpdate();
                System.out.println("Filas afectadas al insertar: " + filasAfectadas);

                // Obtener el ID generado
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        cita.setIdCita(generatedKeys.getInt(1));
                        System.out.println("Cita insertada con ID: " + cita.getIdCita());
                    }
                }

                return filasAfectadas > 0;

            }
        } catch (Exception e) {
            System.out.println("Error al insertar cita en BD: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
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

        return cita;
    }

    // Otros métodos (actualizar, eliminar, obtener por ID) permanecen igual...
    public CitaMedica obtenerCitaPorId(int idCita) {
        try {
            String sql = "SELECT * FROM CitaMedica WHERE IDCita = ?";

            try (Connection connection = Conexion.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql)) {

                stmt.setInt(1, idCita);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    return mapearCita(rs);
                }

            }
        } catch (Exception e) {
            System.out.println("Error al obtener cita por ID: " + e.getMessage());
        }
        return null;
    }

    public boolean actualizarCita(CitaMedica cita) {
        try {
            String sql = "UPDATE CitaMedica SET IDExpediente=?, IDMedico=?, FechaHoraCita=?, TipoCita=?, Sintomas=?, Estado=?, Observaciones=? WHERE IDCita=?";

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

            }
        } catch (Exception e) {
            System.out.println("Error al actualizar cita: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarCita(int idCita) {
        try {
            String sql = "DELETE FROM CitaMedica WHERE IDCita = ?";

            try (Connection connection = Conexion.getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql)) {

                stmt.setInt(1, idCita);
                return stmt.executeUpdate() > 0;

            }
        } catch (Exception e) {
            System.out.println("Error al eliminar cita: " + e.getMessage());
            return false;
        }
    }
}