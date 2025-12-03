package com.otakushop.servlets;

import com.otakushop.model.Producto;
import com.otakushop.model.Usuario;
import com.otakushop.dao.ProductoDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet para editar productos existentes.
 * SOLO usuarios con rol 'admin' o 'administrador' pueden editar.
 */
public class EditarProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            response.sendRedirect("productos.jsp?error=No tienes permisos para editar productos");
            return;
        }

        // 3. Obtener ID del producto
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("productos.jsp?error=ID de producto requerido");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Producto p = productoDAO.obtenerProductoPorId(id); 

            if (p == null) {
                response.sendRedirect("productos.jsp?error=Producto no encontrado con ID: " + id);
                return;
            }

            request.setAttribute("producto", p);
            request.getRequestDispatcher("editarProducto.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("productos.jsp?error=ID de producto invalido");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            response.sendRedirect("productos.jsp?error=No tienes permisos para editar productos");
            return;
        }
        
        // 3. Obtener y validar parámetros
        String idStr = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String stockStr = request.getParameter("stock");
        
        if (idStr == null || nombre == null || nombre.trim().isEmpty() || 
            precioStr == null || precioStr.trim().isEmpty() || 
            stockStr == null || stockStr.trim().isEmpty()) {
            response.sendRedirect("productos.jsp?error=Faltan campos obligatorios");
            return;
        }

        int id;
        double precio;
        int stock;
        
        // 4. Validación de tipos y conversión
        try {
            id = Integer.parseInt(idStr);
            precio = Double.parseDouble(precioStr.trim());
            stock = Integer.parseInt(stockStr.trim());
            
            // Validar valores
            if (precio <= 0) {
                response.sendRedirect("EditarProductoServlet?id=" + id + "&error=El precio debe ser mayor a 0");
                return;
            }
            
            if (stock < 0) {
                response.sendRedirect("EditarProductoServlet?id=" + id + "&error=El stock no puede ser negativo");
                return;
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("productos.jsp?error=Datos numericos invalidos");
            return;
        }

        // 5. Crear objeto y actualizar
        Producto p = new Producto();
        p.setId(id);
        p.setNombre(nombre.trim());
        p.setPrecio(precio);
        p.setStock(stock);

        boolean exito = productoDAO.actualizarProducto(p);

        if (exito) {
            response.sendRedirect("productos.jsp?status=actualizado");
        } else {
            response.sendRedirect("productos.jsp?error=Error al actualizar el producto");
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
