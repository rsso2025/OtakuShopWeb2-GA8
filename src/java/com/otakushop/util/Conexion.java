package com.otakushop.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // Driver compatible con mysql-connector-java-5.1.49
    // Si usas MySQL Connector 8.x, cambia a: com.mysql.cj.jdbc.Driver
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/otakushop?useSSL=false&useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "16321548xD";

    /**
     * Intenta establecer y retornar una conexión a la base de datos.
     * @return Connection La conexión activa, o lanza SQLException.
     * @throws SQLException Si hay un error de conexión o el driver no se encuentra.
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Carga dinámica del driver JDBC
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            // En proyectos modernos (Java 6+ con Servlets 3.0+), esto ya no es estrictamente necesario,
            // pero es una buena práctica para asegurar que el driver se carga.
            System.err.println("Error: Driver JDBC no encontrado.");
            e.printStackTrace();
            throw new SQLException("Driver JDBC no encontrado: " + e.getMessage());
        }

        // Establece la conexión
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}