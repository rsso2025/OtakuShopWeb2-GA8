package com.otakushop.dao;

import com.otakushop.model.Usuario;
import com.otakushop.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    /**
     * Busca un usuario por email y password.
     * @param emailOrUsername El email o username del usuario.
     * @param password La contraseña (sin cifrar).
     * @return Un objeto Usuario si las credenciales son válidas, o null si no lo son.
     */
    public Usuario login(String emailOrUsername, String password) {
        // Asumo que tu tabla se llama 'usuarios' y tiene columnas 'email', 'password', 'apellido', 'username', 'rol'.
        // Si usas 'username' en lugar de 'email' en el campo de la BD, ajusta el WHERE.
        String sql = "SELECT id, nombre, apellido, email, password, username, rol FROM usuarios WHERE (email = ? OR username = ?) AND password = ?";
        Usuario usuario = null;

        // Uso de try-with-resources para asegurar que la conexión, PreparedStatement y ResultSet se cierren automáticamente
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // Asumiendo que el campo de login puede ser email O username
            ps.setString(1, emailOrUsername);
            ps.setString(2, emailOrUsername); 
            ps.setString(3, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Mapear los datos de la base de datos al objeto Usuario
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellido(rs.getString("apellido")); // Nuevo campo
                    usuario.setEmail(rs.getString("email"));
                    // Opcionalmente, no se recomienda cargar la password, pero se mantiene para coherencia del modelo.
                    usuario.setPassword(rs.getString("password")); 
                    usuario.setUsername(rs.getString("username")); // Nuevo campo
                    usuario.setRol(rs.getString("rol"));           // Nuevo campo
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en la conexión a la base de datos o consulta SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return usuario;
    }
}