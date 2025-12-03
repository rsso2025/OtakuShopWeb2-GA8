package com.otakushop.dao;

import com.otakushop.model.Carrito;
import com.otakushop.model.Producto;
import com.otakushop.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object para operaciones del carrito de compras.
 * Todas las operaciones usan try-with-resources para manejo seguro de conexiones.
 */
public class CarritoDAO {

    /**
     * Agrega un producto al carrito del usuario.
     * @param idUsuario ID del usuario
     * @param idProducto ID del producto
     * @param cantidad Cantidad a agregar
     * @param subtotal Subtotal calculado (precio * cantidad)
     * @return true si se agregó correctamente
     */
    public boolean agregarAlCarrito(int idUsuario, int idProducto, int cantidad, double subtotal) {
        String sql = "INSERT INTO carrito (id_usuario, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidad);
            ps.setDouble(4, subtotal);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al agregar al carrito: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualiza la cantidad y recalcula el subtotal de un producto en el carrito.
     * @param idUsuario ID del usuario
     * @param idProducto ID del producto
     * @param cantidad Nueva cantidad
     * @return true si se actualizó correctamente
     */
    public boolean actualizarCantidad(int idUsuario, int idProducto, int cantidad) {
        String sql = "UPDATE carrito SET cantidad = ?, "
                   + "subtotal = ? * (SELECT precio FROM productos WHERE id = ?) "
                   + "WHERE id_usuario = ? AND id_producto = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cantidad);
            ps.setInt(2, cantidad);
            ps.setInt(3, idProducto);
            ps.setInt(4, idUsuario);
            ps.setInt(5, idProducto);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar cantidad en el carrito: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina un producto del carrito de un usuario.
     * @param idUsuario ID del usuario
     * @param idProducto ID del producto a eliminar
     * @return true si se eliminó correctamente
     */
    public boolean eliminarProducto(int idUsuario, int idProducto) {
        String sql = "DELETE FROM carrito WHERE id_usuario = ? AND id_producto = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar producto del carrito: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Obtiene todos los productos del carrito de un usuario con información del producto.
     * @param idUsuario ID del usuario
     * @return Lista de productos en el carrito con datos completos
     */
    public List<Producto> listarCarritoPorUsuario(int idUsuario) {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT c.id, c.id_producto, c.cantidad, c.subtotal, " +
                     "p.nombre, p.precio, p.stock " +
                     "FROM carrito c " +
                     "INNER JOIN productos p ON c.id_producto = p.id " +
                     "WHERE c.id_usuario = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producto p = new Producto();
                    p.setId(rs.getInt("id_producto"));
                    p.setNombre(rs.getString("nombre"));
                    p.setPrecio(rs.getDouble("precio"));
                    p.setStock(rs.getInt("stock"));
                    p.setCantidad(rs.getInt("cantidad")); // Cantidad en carrito
                    productos.add(p);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al listar carrito: " + e.getMessage());
            e.printStackTrace();
        }
        return productos;
    }

    /**
     * Obtiene los items del carrito como objetos Carrito.
     * @param idUsuario ID del usuario
     * @return Lista de items del carrito
     */
    public List<Carrito> obtenerCarritoPorUsuario(int idUsuario) {
        List<Carrito> items = new ArrayList<>();
        String sql = "SELECT id, id_usuario, id_producto, cantidad, subtotal FROM carrito WHERE id_usuario = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Carrito c = new Carrito();
                    c.setId(rs.getInt("id"));
                    c.setUsuarioId(rs.getInt("id_usuario"));
                    c.setIdProducto(rs.getInt("id_producto"));
                    c.setCantidad(rs.getInt("cantidad"));
                    c.setSubtotal(rs.getDouble("subtotal"));
                    items.add(c);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener carrito: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Calcula el total del carrito de un usuario.
     * @param idUsuario ID del usuario
     * @return Total del carrito
     */
    public double calcularTotal(int idUsuario) {
        String sql = "SELECT COALESCE(SUM(subtotal), 0) AS total FROM carrito WHERE id_usuario = ?";
        double total = 0;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getDouble("total");
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al calcular total: " + e.getMessage());
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Vacía el carrito de un usuario (usado después de finalizar compra).
     * @param idUsuario ID del usuario
     * @return true si se vació correctamente
     */
    public boolean vaciarCarrito(int idUsuario) {
        String sql = "DELETE FROM carrito WHERE id_usuario = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            return ps.executeUpdate() >= 0; // Puede ser 0 si ya estaba vacío

        } catch (SQLException e) {
            System.err.println("Error al vaciar carrito: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Verifica si un producto ya existe en el carrito del usuario.
     * @param idUsuario ID del usuario
     * @param idProducto ID del producto
     * @return true si el producto ya está en el carrito
     */
    public boolean existeEnCarrito(int idUsuario, int idProducto) {
        String sql = "SELECT COUNT(*) FROM carrito WHERE id_usuario = ? AND id_producto = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al verificar existencia en carrito: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
