<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sesion = request.getSession(false);
    Usuario usuario = (Usuario) sesion.getAttribute("usuario");
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
    <form action="LogoutServlet" method="post">
        <button type="submit">Cerrar Sesión</button>
    </form>
</body>
</html>
