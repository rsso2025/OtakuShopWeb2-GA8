package com.otakushop.servlets;

import com.otakushop.dao.ProductoDAO;
import com.otakushop.model.Producto;
import com.otakushop.model.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet centralizado para gestión de productos.
 * Maneja listado, agregar, editar y eliminar con control de roles.
 */
public class ProductoServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();

    /**
     * Maneja peticiones GET - Listar productos o mostrar formulario de edición
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String accion = request.getParameter("accion");

        // Si no hay acción, mostrar listado
        if (accion == null || accion.isEmpty()) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                listarProductos(request, response);
                break;
                
            case "editar":
                // Solo admin puede editar
                if (!esAdmin(usuario)) {
                    response.sendRedirect("productos?error=Acceso denegado");
                    return;
                }
                mostrarFormularioEdicion(request, response);
                break;
                
            case "eliminar":
                // Solo admin puede eliminar
                if (!esAdmin(usuario)) {
                    response.sendRedirect("productos?error=Acceso denegado");
                    return;
                }
                eliminarProducto(request, response);
                break;
                
            case "nuevo":
                // Solo admin puede agregar
                if (!esAdmin(usuario)) {
                    response.sendRedirect("productos?error=Acceso denegado");
                    return;
                }
                request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
                break;
                
            default:
                listarProductos(request, response);
        }
    }

    /**
     * Maneja peticiones POST - Guardar o actualizar productos
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Validar sesión y rol admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        // Solo admin puede hacer POST (agregar/actualizar)
        if (!esAdmin(usuario)) {
            response.sendRedirect("productos?error=No tienes permisos para esta accion");
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "agregar";
        }

        switch (accion) {
            case "agregar":
                agregarProducto(request, response);
                break;
                
            case "actualizar":
                actualizarProducto(request, response);
                break;
                
            default:
                response.sendRedirect("productos");
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

    /**
     * Lista todos los productos y los envía a la vista
     */
    private void listarProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Producto> productos = productoDAO.listarProductos();
        request.setAttribute("productos", productos);
        request.getRequestDispatcher("listarProductos.jsp").forward(request, response);
    }

    /**
     * Muestra el formulario de edición con los datos del producto
     */
    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("productos?error=ID de producto requerido");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Producto producto = productoDAO.obtenerProductoPorId(id);
            
            if (producto == null) {
                response.sendRedirect("productos?error=Producto no encontrado");
                return;
            }
            
            request.setAttribute("producto", producto);
            request.getRequestDispatcher("editarProducto.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("productos?error=ID invalido");
        }
    }

    /**
     * Elimina un producto
     */
    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("productos?error=ID de producto requerido");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            boolean exito = productoDAO.eliminarProducto(id);
            
            if (exito) {
                response.sendRedirect("productos?status=eliminado");
            } else {
                response.sendRedirect("productos?error=No se pudo eliminar el producto");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("productos?error=ID invalido");
        }
    }

    /**
     * Agrega un nuevo producto
     */
    private void agregarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String stockStr = request.getParameter("stock");

        // Validar campos
        if (nombre == null || nombre.trim().isEmpty() ||
            precioStr == null || precioStr.trim().isEmpty() ||
            stockStr == null || stockStr.trim().isEmpty()) {
            
            request.setAttribute("error", "Todos los campos son obligatorios");
            request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
            return;
        }

        try {
            double precio = Double.parseDouble(precioStr);
            int stock = Integer.parseInt(stockStr);

            Producto p = new Producto();
            p.setNombre(nombre.trim());
            p.setPrecio(precio);
            p.setStock(stock);

            boolean exito = productoDAO.agregarProducto(p);

            if (exito) {
                response.sendRedirect("productos?status=success");
            } else {
                request.setAttribute("error", "Error al guardar el producto");
                request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Precio y Stock deben ser numeros validos");
            request.getRequestDispatcher("agregarProducto.jsp").forward(request, response);
        }
    }

    /**
     * Actualiza un producto existente
     */
    private void actualizarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String stockStr = request.getParameter("stock");

        // Validar campos
        if (idStr == null || nombre == null || nombre.trim().isEmpty() ||
            precioStr == null || stockStr == null) {
            
            response.sendRedirect("productos?error=Datos incompletos");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            double precio = Double.parseDouble(precioStr);
            int stock = Integer.parseInt(stockStr);

            Producto p = new Producto();
            p.setId(id);
            p.setNombre(nombre.trim());
            p.setPrecio(precio);
            p.setStock(stock);

            boolean exito = productoDAO.actualizarProducto(p);

            if (exito) {
                response.sendRedirect("productos?status=actualizado");
            } else {
                response.sendRedirect("productos?error=Error al actualizar");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("productos?error=Datos numericos invalidos");
        }
    }
}



