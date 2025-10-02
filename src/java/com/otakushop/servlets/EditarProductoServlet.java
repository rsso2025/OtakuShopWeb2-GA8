package com.otakushop.servlets;

import com.otakushop.model.Producto;
import com.otakushop.dao.ProductoDAO;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class EditarProductoServlet extends HttpServlet {

    private ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Producto p = productoDAO.obtenerProductoPorId(id);
        request.setAttribute("producto", p);
        request.getRequestDispatcher("editarProducto.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        double precio = Double.parseDouble(request.getParameter("precio"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        Producto p = new Producto();
        p.setId(id);
        p.setNombre(nombre);
        p.setPrecio(precio);
        p.setStock(stock);

        productoDAO.actualizarProducto(p);
        response.sendRedirect("AgregarProductoServlet");
    }
}
