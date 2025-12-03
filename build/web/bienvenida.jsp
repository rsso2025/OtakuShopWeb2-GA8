<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%
    // Usamos la sesión implícita de JSP (no necesitamos importar HttpSession)
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Bienvenido</title>
</head>
<body>
    <h2>Bienvenido, <%= usuario.getNombre() %>!</h2>
    <p>Tu email es: <%= usuario.getEmail() %></p>
    <form action="logout" method="get">
        <button type="submit">Cerrar Sesión</button>
    </form>
</body>
</html>
