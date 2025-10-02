package com.otakushop.api;

import com.otakushop.model.Carrito;  // CORREGIDO
import com.otakushop.model.Pedido;   // CORREGIDO
import com.otakushop.util.Conexion;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/api/pedidos/*")
public class PedidosApiServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            // Leer el JSON que viene en la petición
            Type tipo = new TypeToken<Pedido>() {}.getType();
            Pedido pedido = gson.fromJson(request.getReader(), tipo);

            if (pedido.getProductos() == null || pedido.getProductos().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "El pedido debe contener al menos un producto");
                return;
            }

            try (Connection conn = Conexion.getConnection()) {
                conn.setAutoCommit(false); // iniciar transacción

                // Validar que el usuario existe
                try (PreparedStatement psUsuario = conn.prepareStatement(
                        "SELECT COUNT(*) FROM usuarios WHERE id=?")) {
                    psUsuario.setInt(1, pedido.getIdUsuario());
                    try (ResultSet rs = psUsuario.executeQuery()) {
                        if (rs.next() && rs.getInt(1) == 0) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                                    "Usuario inválido");
                            return;
                        }
                    }
                }

                // Validar que todos los productos existen y calcular total
                double total = 0;
                for (Carrito c : pedido.getProductos()) {
                    try (PreparedStatement psProd = conn.prepareStatement(
                            "SELECT precio FROM productos WHERE id=?")) {
                        psProd.setInt(1, c.getIdProducto());
                        try (ResultSet rs = psProd.executeQuery()) {
                            if (rs.next()) {
                                double precio = rs.getDouble("precio");
                                c.setSubtotal(precio * c.getCantidad());
                                total += c.getSubtotal();
                            } else {
                                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                                        "Producto con ID " + c.getIdProducto() + " no existe");
                                return;
                            }
                        }
                    }
                }

                pedido.setTotal(total);
                pedido.setEstado("pendiente"); // estado inicial

                // Insertar pedido
                String sqlPedido = "INSERT INTO pedidos(id_usuario, total, estado) VALUES(?,?,?)";
                try (PreparedStatement psPedido = conn.prepareStatement(sqlPedido,
                        Statement.RETURN_GENERATED_KEYS)) {
                    psPedido.setInt(1, pedido.getIdUsuario());
                    psPedido.setDouble(2, pedido.getTotal());
                    psPedido.setString(3, pedido.getEstado());
                    psPedido.executeUpdate();

                    ResultSet rsKeys = psPedido.getGeneratedKeys();
                    int idPedido = 0;
                    if (rsKeys.next()) {
                        idPedido = rsKeys.getInt(1);
                    }

                    // Insertar detalle_pedido
                    String sqlDetalle = "INSERT INTO detalle_pedido(id_pedido, id_producto, cantidad, subtotal) VALUES(?,?,?,?)";
                    try (PreparedStatement psDetalle = conn.prepareStatement(sqlDetalle)) {
                        for (Carrito c : pedido.getProductos()) {
                            psDetalle.setInt(1, idPedido);
                            psDetalle.setInt(2, c.getIdProducto());
                            psDetalle.setInt(3, c.getCantidad());
                            psDetalle.setDouble(4, c.getSubtotal());
                            psDetalle.addBatch();
                        }
                        psDetalle.executeBatch();
                    }

                    conn.commit();
                    response.setStatus(HttpServletResponse.SC_CREATED);
                    response.getWriter().write("{\"mensaje\":\"Pedido creado con ID: " + idPedido + "\"}");
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
