package com.otakushop.servlets;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

// ⚠️ Se elimina el @WebServlet, el mapeo va en web.xml

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener la sesión existente (si hay una)
        HttpSession session = request.getSession(false); 
        
        if (session != null) {
            session.invalidate(); // Cierra la sesión
        }

        // Redirige a login, opcionalmente con un mensaje
        response.sendRedirect("login.jsp?mensaje=Cierre de sesión exitoso");
    }

    // Opcional: permitir también cerrar sesión vía POST, delegando al doGet
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}