package com.otakushop.dao;

import com.otakushop.model.Carrito;
import com.otakushop.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class CarritoDAO {

    public void agregarAlCarrito(int idUsuario, int idProducto, int cantidad, double subtotal) {
        String sql = "INSERT INTO carrito (usuario_id, producto_id, cantidad, subtotal) VALUES (?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidad);
            ps.setDouble(4, subtotal);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
