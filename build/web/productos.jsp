<%@ page import="java.sql.*, com.otakushop.util.Conexion" %>
<%@ page session="true" %>
<%
    String usuario = (String) session.getAttribute("usuario");
    if(usuario == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Productos - OtakuShop</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f0f0; }
        .container { width: 800px; margin: 50px auto; padding: 20px; background: white; border-radius: 10px; }
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
        th { background-color: #007BFF; color: white; }
        a { text-decoration: none; color: #007BFF; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>Productos Disponibles</h2>
    <p>Bienvenido, <%= usuario %> | <a href="login.jsp">Cerrar sesión</a></p>

    <table>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Precio</th>
            <th>Stock</th>
        </tr>
        <%
            try (Connection con = Conexion.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM productos");
                 ResultSet rs = ps.executeQuery()) {

                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("nombre") %></td>
            <td>$<%= rs.getBigDecimal("precio") %></td>
            <td><%= rs.getInt("stock") %></td>
        </tr>
        <%
                }
            } catch(SQLException e) {
                out.println("<tr><td colspan='4'>Error al cargar productos</td></tr>");
                e.printStackTrace();
            }
        %>
    </table>
    <p><a href="carrito.jsp">Ir al Carrito</a></p>
</div>
</body>
</html>
