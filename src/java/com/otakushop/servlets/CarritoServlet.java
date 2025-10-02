package com.otakushop.servlets;

import com.otakushop.model.Carrito;
import com.otakushop.dao.CarritoDAO;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class CarritoServlet extends HttpServlet {

    private CarritoDAO carritoDAO = new CarritoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();
        Integer idUsuario = (Integer) sesion.getAttribute("idUsuario");

        if (idUsuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idProducto = Integer.parseInt(request.getParameter("idProducto"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        double subtotal = Double.parseDouble(request.getParameter("subtotal"));

        carritoDAO.agregarAlCarrito(idUsuario, idProducto, cantidad, subtotal);

        response.sendRedirect("carrito.jsp");
    }
}
