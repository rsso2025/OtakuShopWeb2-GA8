package com.otakushop.servlets;

import com.otakushop.dao.CarritoDAO;
import com.otakushop.model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ActualizarCarritoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Validación de sesión
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int idUsuario = usuario.getId();

        // Validación de parámetros
        String idProductoStr = request.getParameter("idProducto");
        String cantidadStr = request.getParameter("cantidad");

        if (idProductoStr == null || cantidadStr == null) {
            response.sendRedirect("carrito.jsp");
            return;
        }

        int idProducto;
        int cantidad;

        try {
            idProducto = Integer.parseInt(idProductoStr);
            cantidad = Integer.parseInt(cantidadStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("carrito.jsp");
            return;
        }

        if (cantidad < 1) cantidad = 1;

        // Actualizar en BD mediante DAO
        CarritoDAO carritoDAO = new CarritoDAO();
        carritoDAO.actualizarCantidad(idUsuario, idProducto, cantidad);

        response.sendRedirect("carrito.jsp");
    }
}
