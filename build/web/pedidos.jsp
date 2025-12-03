<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%@ page import="com.otakushop.util.Conexion" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ include file="navbar.jsp" %>
<link rel="stylesheet" href="css/styles.css"/>

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
        margin-top: 20px;
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
    
    .estado-pendiente {
        background: #fff3cd;
        color: #856404;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }
    
    .estado-pagado {
        background: #d4edda;
        color: #155724;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }
    
    .estado-enviado {
        background: #cce5ff;
        color: #004085;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }
    
    .no-pedidos {
        text-align: center;
        padding: 50px;
        color: #666;
    }
    
    .no-pedidos .icon { font-size: 60px; margin-bottom: 20px; }
    
    .btn-ver {
        padding: 8px 16px;
        background: #667eea;
        color: white;
        border: none;
        border-radius: 5px;
        text-decoration: none;
        font-size: 13px;
        transition: background 0.3s;
    }
    
    .btn-ver:hover { background: #5a6fd6; }
</style>

<div class="container">
    <h2>📋 Mis Pedidos</h2>
    
    <table>
        <thead>
            <tr>
                <th>N° Pedido</th>
                <th>Fecha</th>
                <th>Total</th>
                <th>Estado</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection con = Conexion.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                         "SELECT id, fecha, total, estado FROM pedidos WHERE id_usuario = ? ORDER BY fecha DESC")) {
                    
                    ps.setInt(1, usuario.getId());
                    ResultSet rs = ps.executeQuery();
                    
                    boolean hayPedidos = false;
                    while (rs.next()) {
                        hayPedidos = true;
                        String estado = rs.getString("estado");
                        String claseEstado = "estado-pendiente";
                        if ("pagado".equalsIgnoreCase(estado)) claseEstado = "estado-pagado";
                        else if ("enviado".equalsIgnoreCase(estado)) claseEstado = "estado-enviado";
            %>
            <tr>
                <td><strong>#<%= rs.getInt("id") %></strong></td>
                <td><%= rs.getTimestamp("fecha") %></td>
                <td>$<%= String.format("%.2f", rs.getDouble("total")) %></td>
                <td><span class="<%= claseEstado %>"><%= estado.toUpperCase() %></span></td>
            </tr>
            <%
                    }
                    
                    if (!hayPedidos) {
            %>
            <tr>
                <td colspan="4" class="no-pedidos">
                    <div class="icon">📭</div>
                    <p>Aún no tienes pedidos. <a href="productos.jsp">¡Explora nuestro catálogo!</a></p>
                </td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='4' style='color:red;'>Error al cargar pedidos: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>
</div>
</body>
</html>



