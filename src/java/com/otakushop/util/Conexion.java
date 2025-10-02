package com.otakushop.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    /**
     * Obtiene una nueva conexión a la base de datos.
     * Cada llamada retorna una conexión independiente.
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Driver para MySQL Connector/J 5.1.49
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Error: Driver JDBC no encontrado.");
            e.printStackTrace();
        }

        // URL de conexión compatible con MySQL 5.1
        String url = "jdbc:mysql://localhost:3306/otakushop?useSSL=false";
        String user = "root";
        String password = "16321548xD";

        return DriverManager.getConnection(url, user, password);
    }
}

