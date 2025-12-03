package com.otakushop.dao;

import com.otakushop.util.Conexion;
import java.sql.*;

public class PedidoDAO {

    /**
     * Crea un nuevo pedido en la base de datos y devuelve el ID generado.
     * @param idUsuario ID del usuario que realiza el pedido.
     * @param total Monto total del pedido.
     * @return int El ID del pedido generado, o -1 si falla.
     */
    public int crearPedido(int idUsuario, double total) {
        // La tabla 'pedidos' debe tener la columna 'id_usuario', 'total' y una columna ID auto-incremental.
        String sql = "INSERT INTO pedidos (id_usuario, total) VALUES (?, ?)";
        int idPedido = -1; // Valor predeterminado de fracaso
        
        // Uso de try-with-resources para cerrar automáticamente la conexión
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, idUsuario);
            ps.setDouble(2, total);
            ps.executeUpdate();

            // Obtener el ID que la base de datos generó
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    idPedido = rs.getInt(1); 
                }
            }

        } catch (SQLException e) {
            System.err.println("Error SQL al crear el pedido: " + e.getMessage());
            e.printStackTrace();
            // idPedido se mantiene en -1 (fallo)
        }
        return idPedido; // Devolver el ID generado o -1
    }
}