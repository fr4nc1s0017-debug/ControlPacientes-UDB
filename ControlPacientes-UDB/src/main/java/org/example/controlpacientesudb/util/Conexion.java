package org.example.controlpacientesudb.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    // Configuración para SQL Server LocalDB
    private static final String URL = "jdbc:sqlserver://(localdb)\\MSSQLLocalDB;databaseName=Clinica;encrypt=true;trustServerCertificate=true";
    private static final String USER = ""; // Deja vacío para Windows Authentication
    private static final String PASSWORD = ""; // Deja vacío para Windows Authentication

    // Para autenticación de Windows
    private static final String CONNECTION_STRING = "jdbc:sqlserver://(localdb)\\MSSQLLocalDB;databaseName=Clinica;integratedSecurity=true;encrypt=true;trustServerCertificate=true";

    public static Connection getConnection() throws SQLException {
        try {
            // Cargar el driver de SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQL Server no encontrado", e);
        }

        // Para Windows Authentication (recomendado con LocalDB)
        return DriverManager.getConnection(CONNECTION_STRING);

        // Para SQL Server Authentication (si tienes usuario/contraseña)
        // return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}