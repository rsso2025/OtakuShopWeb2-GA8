package com.otakushop.servlets;

import com.otakushop.util.Conexion;
import com.otakushop.model.Usuario;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

public class FinalizarCompraServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp?error=Debe iniciar sesión");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int idUsuario = usuario.getId();

        try (Connection con = Conexion.getConnection()) {

            con.setAutoCommit(false); // Iniciar transacción

            // Obtener productos del carrito
            PreparedStatement psCarrito = con.prepareStatement(
                "SELECT id_producto, cantidad, subtotal FROM carrito WHERE id_usuario=?",
                ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_READ_ONLY
            );
            psCarrito.setInt(1, idUsuario);
            ResultSet rs = psCarrito.executeQuery();

            // Verificar si el carrito está vacío
            if (!rs.next()) {
                con.rollback();
                response.sendRedirect("carrito.jsp?error=Carrito vacío");
                return;
            }

            // Calcular total
            rs.beforeFirst();
            BigDecimal total = BigDecimal.ZERO;
            while (rs.next()) {
                BigDecimal sub = rs.getBigDecimal("subtotal");
                if (sub != null) total = total.add(sub);
            }

            // Insertar encabezado de compra
            PreparedStatement psCompra = con.prepareStatement(
                "INSERT INTO compras(id_usuario, total) VALUES (?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            psCompra.setInt(1, idUsuario);
            psCompra.setBigDecimal(2, total);
            psCompra.executeUpdate();

            ResultSet rsCompra = psCompra.getGeneratedKeys();
            rsCompra.next();
            int idCompra = rsCompra.getInt(1);

            // Insertar detalles y actualizar stock por producto
            rs.beforeFirst();
            while (rs.next()) {

                int idProducto = rs.getInt("id_producto");
                int cantidad = rs.getInt("cantidad");
                BigDecimal subtotal = rs.getBigDecimal("subtotal");

                // Insertar detalle
                PreparedStatement psDetalle = con.prepareStatement(
                    "INSERT INTO detalle_compra(id_compra, id_producto, cantidad, subtotal) " +
                    "VALUES (?, ?, ?, ?)"
                );
                psDetalle.setInt(1, idCompra);
                psDetalle.setInt(2, idProducto);
                psDetalle.setInt(3, cantidad);
                psDetalle.setBigDecimal(4, subtotal);
                psDetalle.executeUpdate();

                // Actualizar stock
                PreparedStatement psStock = con.prepareStatement(
                    "UPDATE productos SET stock = stock - ? WHERE id=?"
                );
                psStock.setInt(1, cantidad);
                psStock.setInt(2, idProducto);
                psStock.executeUpdate();
            }

            // Vaciar carrito
            PreparedStatement psClean = con.prepareStatement(
                "DELETE FROM carrito WHERE id_usuario=?"
            );
            psClean.setInt(1, idUsuario);
            psClean.executeUpdate();

            con.commit(); // Confirmar transacción

            response.sendRedirect("confirmacion.jsp?mensaje=Compra realizada con éxito");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en la compra: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
