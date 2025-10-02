package com.otakushop.dao;

import com.otakushop.model.Pedido;
import com.otakushop.util.Conexion;
import java.sql.*;

public class PedidoDAO {

    public void crearPedido(int idUsuario, double total) {
        String sql = "INSERT INTO pedidos (usuario_id, total) VALUES (?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, idUsuario);
            ps.setDouble(2, total);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int idPedido = rs.getInt(1);
                System.out.println("Pedido creado con ID: " + idPedido);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
