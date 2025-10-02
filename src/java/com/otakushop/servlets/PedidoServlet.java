package com.otakushop.servlets;

import com.otakushop.dao.PedidoDAO;
import com.otakushop.model.Pedido;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class PedidoServlet extends HttpServlet {

    private PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            double total = Double.parseDouble(request.getParameter("total"));

            pedidoDAO.crearPedido(idUsuario, total);

            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"ok\",\"mensaje\":\"Pedido creado exitosamente\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"mensaje\":\"" + e.getMessage() + "\"}");
        }
    }
}
