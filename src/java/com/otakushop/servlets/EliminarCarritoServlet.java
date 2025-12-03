package com.otakushop.servlets;

import com.otakushop.util.Conexion;
import com.otakushop.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class EliminarCarritoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp?mensaje=Debes iniciar sesión");
            return;
        }

        // Obtener usuario logueado
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int idUsuario = usuario.getId();

        // Validar idProducto
        String idProdParam = request.getParameter("idProducto");
        if (idProdParam == null || idProdParam.isEmpty()) {
            response.sendRedirect("carrito.jsp?error=Producto inválido");
            return;
        }

        try {
            int idProducto = Integer.parseInt(idProdParam);

            try (Connection con = Conexion.getConnection()) {

                PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM carrito WHERE id_usuario = ? AND id_producto = ?"
                );

                ps.setInt(1, idUsuario);
                ps.setInt(2, idProducto);
                ps.executeUpdate();

                response.sendRedirect("carrito.jsp?mensaje=Producto eliminado");

            }

        } catch (NumberFormatException e) {
            response.sendRedirect("carrito.jsp?error=ID de producto inválido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("carrito.jsp?error=Ocurrió un error al eliminar");
        }
    }
}
