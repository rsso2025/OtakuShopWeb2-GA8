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
 * Servlet para agregar nuevos productos.
 * SOLO usuarios con rol 'admin' o 'administrador' pueden agregar.
 */
public class AgregarProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Validar sesión y rol antes de mostrar formulario
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!esAdmin(usuario)) {
            response.sendRedirect("productos.jsp?error=No tienes permisos para agregar productos");
            return;
        }
        
        // Mostrar formulario de agregar
        request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 2. Validar rol de administrador
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!esAdmin(usuario)) {
            response.sendRedirect("productos.jsp?error=No tienes permisos para agregar productos");
            return;
        }

        // 3. Obtener parámetros
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String stockStr = request.getParameter("stock");

        // 4. Validar campos obligatorios
        if (nombre == null || nombre.trim().isEmpty() || 
            precioStr == null || precioStr.trim().isEmpty() || 
            stockStr == null || stockStr.trim().isEmpty()) {
            
            request.setAttribute("error", "Error: Todos los campos son obligatorios.");
            request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
            return;
        }

        double precio;
        int stock;

        // 5. Convertir a tipos numéricos
        try {
            precio = Double.parseDouble(precioStr.trim());
            stock = Integer.parseInt(stockStr.trim());
            
            // Validar valores positivos
            if (precio <= 0) {
                request.setAttribute("error", "Error: El precio debe ser mayor a 0.");
                request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
                return;
            }
            
            if (stock < 0) {
                request.setAttribute("error", "Error: El stock no puede ser negativo.");
                request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
                return;
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: Precio y Stock deben ser números válidos.");
            request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
            return;
        }

        // 6. Crear objeto Producto
        Producto p = new Producto();
        p.setNombre(nombre.trim());
        p.setPrecio(precio);
        p.setStock(stock);

        // 7. Guardar en BD
        boolean exito = productoDAO.agregarProducto(p); 

        if (exito) {
            response.sendRedirect("productos.jsp?status=success");
        } else {
            request.setAttribute("error", "Error interno al guardar el producto en la base de datos.");
            request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
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
