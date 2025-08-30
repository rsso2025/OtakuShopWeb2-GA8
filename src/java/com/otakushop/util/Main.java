package com.otakushop.util;

import java.sql.Connection;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        try {
            Connection con = ConexionDB.getConexion();
            if (con != null) {
                System.out.println("Conexión exitosa a la base de datos");
                con.close();
            }
        } catch (SQLException e) {
            System.out.println("Error en la conexión: " + e.getMessage());
        }
    }
}
// Prueba de commit en rama feature/api
