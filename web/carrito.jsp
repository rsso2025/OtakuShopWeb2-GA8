<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%@ page import="com.otakushop.util.Conexion" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ include file="navbar.jsp" %>

<style>
    .container {
        max-width: 1000px;
        margin: 30px auto;
        padding: 30px;
        background: white;
        border-radius: 15px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    }
    
    h2 {
        color: #333;
        margin-bottom: 30px;
        text-align: center;
        font-size: 28px;
    }
    
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
    }
    
    th, td {
        padding: 15px;
        text-align: center;
        border-bottom: 1px solid #e0e0e0;
    }
    
    th {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 13px;
        letter-spacing: 1px;
    }
    
    tr:hover { background: #f8f9fa; }
    
    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        transition: transform 0.3s, background 0.3s;
    }
    
    .btn-actualizar {
        background: #3498db;
        color: white;
    }
    
    .btn-actualizar:hover {
        background: #2980b9;
        transform: translateY(-2px);
    }
    
    .btn-eliminar {
        background: #e74c3c;
        color: white;
        text-decoration: none;
        display: inline-block;
    }
    
    .btn-eliminar:hover {
        background: #c0392b;
        transform: translateY(-2px);
    }
    
    .btn-comprar {
        width: 100%;
        padding: 18px;
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
        font-size: 18px;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        transition: transform 0.3s, box-shadow 0.3s;
    }
    
    .btn-comprar:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 30px rgba(40, 167, 69, 0.4);
    }
    
    .total-container {
        text-align: right;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 10px;
        margin-bottom: 20px;
    }
    
    .total-label {
        font-size: 18px;
        color: #666;
    }
    
    .total-amount {
        font-size: 32px;
        font-weight: bold;
        color: #28a745;
    }
    
    .carrito-vacio {
        text-align: center;
        padding: 60px;
        color: #666;
    }
    
    .carrito-vacio .icon { font-size: 80px; margin-bottom: 20px; }
    
    .carrito-vacio a {
        color: #667eea;
        text-decoration: none;
        font-weight: bold;
    }
    
    .carrito-vacio a:hover { text-decoration: underline; }
    
    input[type="number"] {
        width: 70px;
        padding: 8px;
        border: 2px solid #ddd;
        border-radius: 6px;
        text-align: center;
        font-size: 14px;
    }
    
    .alert {
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 20px;
        text-align: center;
    }
    
    .alert-success {
        background: #d4edda;
        color: #155724;
    }
    
    .alert-danger {
        background: #f8d7da;
        color: #721c24;
    }
</style>

<div class="container">
    <h2>🛒 Mi Carrito de Compras</h2>
    
    <c:if test="${not empty param.estado}">
        <div class="alert alert-success">Producto agregado al carrito</div>
    </c:if>
    <c:if test="${not empty param.mensaje}">
        <div class="alert alert-success">${param.mensaje}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">${param.error}</div>
    </c:if>
    
    <%
        BigDecimal totalCarrito = BigDecimal.ZERO;
        boolean tieneProductos = false;
        
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT c.id, c.id_producto, c.cantidad, c.subtotal, p.nombre, p.precio " +
                 "FROM carrito c " +
                 "INNER JOIN productos p ON c.id_producto = p.id " +
                 "WHERE c.id_usuario = ?")) {
            
            ps.setInt(1, usuario.getId());
            ResultSet rs = ps.executeQuery();
    %>
    
    <table>
        <thead>
            <tr>
                <th>Producto</th>
                <th>Precio Unitario</th>
                <th>Cantidad</th>
                <th>Subtotal</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
    <%
            while (rs.next()) {
                tieneProductos = true;
                int idProducto = rs.getInt("id_producto");
                String nombreProducto = rs.getString("nombre");
                BigDecimal precio = rs.getBigDecimal("precio");
                int cantidad = rs.getInt("cantidad");
                BigDecimal subtotal = rs.getBigDecimal("subtotal");
                totalCarrito = totalCarrito.add(subtotal);
    %>
            <tr>
                <td><strong><%= nombreProducto %></strong></td>
                <td>$<%= String.format("%.2f", precio) %></td>
                <td>
                    <form action="ActualizarCarritoServlet" method="post" style="display: inline;">
                        <input type="hidden" name="idProducto" value="<%= idProducto %>">
                        <input type="number" name="cantidad" value="<%= cantidad %>" min="1">
                        <button type="submit" class="btn btn-actualizar">Actualizar</button>
                    </form>
                </td>
                <td><strong>$<%= String.format("%.2f", subtotal) %></strong></td>
                <td>
                    <a href="EliminarCarritoServlet?idProducto=<%= idProducto %>" 
                       class="btn btn-eliminar"
                       onclick="return confirm('¿Eliminar este producto del carrito?')">
                        🗑️ Eliminar
                    </a>
                </td>
            </tr>
    <%
            }
            
            if (!tieneProductos) {
    %>
            <tr>
                <td colspan="5" class="carrito-vacio">
                    <div class="icon">🛒</div>
                    <p>Tu carrito está vacío</p>
                    <a href="productos.jsp">¡Explora nuestros productos!</a>
                </td>
            </tr>
    <%
            }
        } catch (SQLException e) {
            out.println("<tr><td colspan='5' style='color:red;'>Error al cargar el carrito: " + e.getMessage() + "</td></tr>");
        }
    %>
        </tbody>
    </table>
    
    <% if (tieneProductos) { %>
    <div class="total-container">
        <span class="total-label">Total a pagar:</span>
        <span class="total-amount">$<%= String.format("%.2f", totalCarrito) %></span>
    </div>
    
    <form action="FinalizarCompraServlet" method="post">
        <button type="submit" class="btn-comprar">
            ✅ Finalizar Compra
        </button>
    </form>
    <% } %>
</div>
</body>
</html>
