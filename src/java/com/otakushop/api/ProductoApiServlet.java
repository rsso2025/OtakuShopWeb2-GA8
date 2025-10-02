package com.otakushop.api;

import com.otakushop.model.Producto;  // CORREGIDO
import com.otakushop.util.Conexion;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/productos/*")
public class ProductoApiServlet extends HttpServlet {

    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Producto> productosList = new ArrayList<>();
        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM productos");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                productosList.add(p);
            }

            String json = gson.toJson(productosList);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8"); // agregado
            response.getWriter().write(json);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Type tipo = new TypeToken<Producto>() {}.getType();
        Producto producto = gson.fromJson(request.getReader(), tipo);

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO productos(nombre, precio, stock) VALUES(?,?,?)")) {

            ps.setString(1, producto.getNombre());
            ps.setDouble(2, producto.getPrecio());
            ps.setInt(3, producto.getStock());
            ps.executeUpdate();

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write("{\"mensaje\":\"Producto creado\"}");

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
