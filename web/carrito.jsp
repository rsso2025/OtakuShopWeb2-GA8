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
    <title>Carrito - OtakuShop</title>
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
    <h2>Tu Carrito</h2>
    <p>Bienvenido, <%= usuario %> | <a href="login.jsp">Cerrar sesión</a></p>

    <table>
        <tr>
            <th>Producto</th>
            <th>Cantidad</th>
            <th>Subtotal</th>
        </tr>
        <%
            try (Connection con = Conexion.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                    "SELECT p.nombre, c.cantidad, c.subtotal " +
                    "FROM carrito c JOIN usuarios u ON c.id_usuario=u.id " +
                    "JOIN productos p ON c.id_producto=p.id " +
                    "WHERE u.nombre=?")) {

                ps.setString(1, usuario);
                ResultSet rs = ps.executeQuery();
                boolean vacio = true;

                while(rs.next()) {
                    vacio = false;
        %>
        <tr>
            <td><%= rs.getString("nombre") %></td>
            <td><%= rs.getInt("cantidad") %></td>
            <td>$<%= rs.getBigDecimal("subtotal") %></td>
        </tr>
        <%
                }

                if(vacio){
                    out.println("<tr><td colspan='3'>El carrito está vacío</td></tr>");
                }

            } catch(SQLException e) {
                out.println("<tr><td colspan='3'>Error al cargar el carrito</td></tr>");
                e.printStackTrace();
            }
        %>
    </table>
    <p><a href="productos.jsp">Ver Productos</a></p>
</div>
</body>
</html>
