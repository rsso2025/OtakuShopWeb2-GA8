package com.otakushop.servlets;

import com.otakushop.model.Producto;
import com.otakushop.dao.ProductoDAO;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class AgregarProductoServlet extends HttpServlet {

    private ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        double precio = Double.parseDouble(request.getParameter("precio"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        Producto p = new Producto();
        p.setNombre(nombre);
        p.setPrecio(precio);
        p.setStock(stock);

        productoDAO.agregarProducto(p);

        response.sendRedirect("productos.jsp");
    }
}
