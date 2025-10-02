package com.otakushop.api;

import com.otakushop.model.Carrito;  // CORREGIDO
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

@WebServlet("/api/carrito/*")
public class CarritoApiServlet extends HttpServlet {

    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Carrito> carritoList = new ArrayList<>();
        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM carrito");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Carrito c = new Carrito();
                c.setId(rs.getInt("id"));
                c.setUsuarioId(rs.getInt("id_usuario"));
                c.setIdProducto(rs.getInt("id_producto"));
                c.setCantidad(rs.getInt("cantidad"));
                c.setSubtotal(rs.getDouble("subtotal"));
                carritoList.add(c);
            }

            String json = gson.toJson(carritoList);
            response.setContentType("application/json");
            response.getWriter().write(json);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Type tipo = new TypeToken<Carrito>() {}.getType();
        Carrito carrito = gson.fromJson(request.getReader(), tipo);

        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO carrito(id_usuario, id_producto, cantidad, subtotal) VALUES(?,?,?,?)")) {

            ps.setInt(1, carrito.getUsuarioId());
            ps.setInt(2, carrito.getIdProducto());
            ps.setInt(3, carrito.getCantidad());
            ps.setDouble(4, carrito.getSubtotal());
            ps.executeUpdate();
            response.setStatus(HttpServletResponse.SC_CREATED);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
