<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalidar la sesión si existe
    if (session != null) {
        session.invalidate();
    }
    // Redirigir al login.jsp
    response.sendRedirect("login.jsp");
%>
