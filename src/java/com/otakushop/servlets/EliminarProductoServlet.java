package com.otakushop.servlets;

import com.otakushop.dao.ProductoDAO;
import com.otakushop.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet para eliminar productos.
 * SOLO usuarios con rol 'admin' o 'administrador' pueden eliminar.
 */
public class EliminarProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarEliminacion(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarEliminacion(request, response);
    }

    private void procesarEliminacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                
        // 1. Validar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp?mensaje=Debes iniciar sesion");
            return;
        }
        
        // 2. Validar rol de administrador
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!esAdmin(usuario)) {
            response.sendRedirect("productos.jsp?error=No tienes permisos para eliminar productos");
            return;
        }
        
        // 3. Obtener y validar ID
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("productos.jsp?error=ID de producto requerido");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            
            // 4. Ejecutar eliminación
            boolean exito = productoDAO.eliminarProducto(id);

            if (exito) {
                response.sendRedirect("productos.jsp?status=eliminado");
            } else {
                response.sendRedirect("productos.jsp?error=No se pudo eliminar el producto");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("productos.jsp?error=ID de producto invalido");
        }
    }
    
    /**
     * Verifica si el usuario tiene rol de administrador
     */
    private boolean esAdmin(Usuario usuario) {
        if (usuario == null || usuario.getRol() == null) {
            return false;
        }
        String rol = usuario.getRol().toLowerCase();
        return rol.equals("admin") || rol.equals("administrador");
    }
}
