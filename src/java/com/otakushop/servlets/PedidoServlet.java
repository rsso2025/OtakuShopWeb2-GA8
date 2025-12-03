package com.otakushop.servlets;

import com.otakushop.dao.PedidoDAO;
import com.otakushop.model.Usuario;
import java.io.IOException;
import javax.servlet.http.*;
import javax.servlet.ServletException;

public class PedidoServlet extends HttpServlet {

    private final PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession(false);
        Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuario") : null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (usuario == null) {
            // Usuario no autenticado (HTTP 401)
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
            response.getWriter().write("{\"status\":\"error\",\"mensaje\":\"Usuario no autenticado.\"}");
            return;
        }
        
        int idUsuario = usuario.getId(); // ID obtenido de la sesión (seguro)
        
        try {
            double total = Double.parseDouble(request.getParameter("total"));

            // Llamada al método corregido que devuelve el ID
            int idPedidoGenerado = pedidoDAO.crearPedido(idUsuario, total);

            if (idPedidoGenerado > 0) {
                // Respuesta exitosa (HTTP 200)
                response.getWriter().write("{\"status\":\"ok\",\"mensaje\":\"Pedido creado exitosamente.\", \"idPedido\": " + idPedidoGenerado + "}");
            } else {
                 // Error de base de datos (HTTP 500)
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
                response.getWriter().write("{\"status\":\"error\",\"mensaje\":\"No se pudo crear el pedido en la base de datos.\"}");
            }
            
        } catch (NumberFormatException e) {
            // Error de datos (HTTP 400)
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
            response.getWriter().write("{\"status\":\"error\",\"mensaje\":\"Formato de total inválido.\"}");
        } catch (Exception e) {
            // Error inesperado (HTTP 500)
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
            response.getWriter().write("{\"status\":\"error\",\"mensaje\":\"Error inesperado al procesar el pedido: " + e.getMessage() + "\"}");
        }
    }
}