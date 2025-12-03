package com.otakushop.servlets;

import com.otakushop.dao.CarritoDAO;
import com.otakushop.model.Usuario; // Importar el modelo Usuario
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class CarritoServlet extends HttpServlet {

    private final CarritoDAO carritoDAO = new CarritoDAO(); // Usar final

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false); // No crear si no existe
        
        // ⚠️ CORRECCIÓN DE SESIÓN: Obtenemos el objeto Usuario
        Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuario") : null;

        if (usuario == null) {
            // El usuario no está logueado, redirigir al login
            response.sendRedirect("login.jsp");
            return;
        }

        // Obtener el ID del usuario logueado
        int idUsuario = usuario.getId(); 

        try {
            // Recolección de datos del producto
            int idProducto = Integer.parseInt(request.getParameter("idProducto"));
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            // Se asume que subtotal viene ya calculado desde el JSP/cliente, aunque idealmente 
            // debería calcularse en el Servlet o DAO para mayor seguridad.
            double subtotal = Double.parseDouble(request.getParameter("subtotal")); 

            carritoDAO.agregarAlCarrito(idUsuario, idProducto, cantidad, subtotal);

            // Mensaje de éxito o redirección al carrito
            response.sendRedirect("carrito.jsp?estado=agregado");
            
        } catch (NumberFormatException e) {
             // Manejo de error si los parámetros no son números
            response.sendRedirect("productos.jsp?error=Datos de carrito inválidos");
        }
    }
}