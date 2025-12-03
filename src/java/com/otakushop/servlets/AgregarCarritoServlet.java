package com.otakushop.servlets;

import com.otakushop.util.Conexion;
import com.otakushop.model.Usuario;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class AgregarCarritoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validar parámetros
        String idProductoStr = request.getParameter("idProducto");
        String cantidadStr = request.getParameter("cantidad");

        if (idProductoStr == null || cantidadStr == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        int idProducto;
        int cantidad;

        try {
            idProducto = Integer.parseInt(idProductoStr);
            cantidad = Integer.parseInt(cantidadStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp");
            return;
        }

        // Validar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int idUsuario = usuario.getId();

        try (Connection con = Conexion.getConnection()) {

            // Obtener precio del producto
            PreparedStatement psPrecio = con.prepareStatement(
                    "SELECT precio FROM productos WHERE id=?");
            psPrecio.setInt(1, idProducto);

            ResultSet rsPrecio = psPrecio.executeQuery();
            BigDecimal precio = BigDecimal.ZERO;

            if (rsPrecio.next()) {
                precio = rsPrecio.getBigDecimal("precio");
            }

            BigDecimal subtotal = precio.multiply(BigDecimal.valueOf(cantidad));

            // Verificar si el producto ya existe en carrito
            PreparedStatement psCheck = con.prepareStatement(
                    "SELECT cantidad FROM carrito WHERE id_usuario=? AND id_producto=?");
            psCheck.setInt(1, idUsuario);
            psCheck.setInt(2, idProducto);

            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // Ya existe → actualizar cantidades
                PreparedStatement psUpdate = con.prepareStatement(
                        "UPDATE carrito SET cantidad = cantidad + ?, subtotal = subtotal + ? " +
                        "WHERE id_usuario=? AND id_producto=?");
                psUpdate.setInt(1, cantidad);
                psUpdate.setBigDecimal(2, subtotal);
                psUpdate.setInt(3, idUsuario);
                psUpdate.setInt(4, idProducto);
                psUpdate.executeUpdate();

            } else {
                // No existe → insertar nuevo
                PreparedStatement psInsert = con.prepareStatement(
                        "INSERT INTO carrito(id_usuario, id_producto, cantidad, subtotal) " +
                        "VALUES (?, ?, ?, ?)");
                psInsert.setInt(1, idUsuario);
                psInsert.setInt(2, idProducto);
                psInsert.setInt(3, cantidad);
                psInsert.setBigDecimal(4, subtotal);
                psInsert.executeUpdate();
            }

            response.sendRedirect("carrito.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
