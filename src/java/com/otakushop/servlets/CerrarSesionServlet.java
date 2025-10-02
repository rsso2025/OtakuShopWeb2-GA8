package com.otakushop.servlets;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class CerrarSesionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // No crea nueva sesión
        if (session != null) {
            session.invalidate(); // Cierra la sesión
        }

        // Redirige a login con mensaje opcional de cierre de sesión
        response.sendRedirect("login.jsp?mensaje=Cierre de sesión exitoso");
    }

    // Opcional: permitir también cerrar sesión vía POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
