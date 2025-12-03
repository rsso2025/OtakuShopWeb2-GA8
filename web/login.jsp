<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - OtakuShopWeb2</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
        .login-container { width: 300px; margin: 100px auto; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 0 10px #ccc; }
        input { width: 100%; padding: 10px; margin: 5px 0; }
        button { width: 100%; padding: 10px; background-color: #5c6bc0; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #3f51b5; }
        .error { color: red; font-size: 0.9em; margin-bottom: 15px; text-align: center;}
    </style>
</head>
<body>
<div class="login-container">
    <h2>Iniciar Sesión</h2>

    <%-- ⚠️ CORRECCIÓN 1: Se usa el atributo de request "error" que envía el Servlet, no un parámetro. --%>
    <c:if test="${not empty requestScope.error}">
        <div class="error">${requestScope.error}</div>
    </c:if>

    <%-- ⚠️ CORRECCIÓN 2: La ruta del action apunta al mapeo /login definido en web.xml. --%>
    <form action="${pageContext.request.contextPath}/login" method="post">
        
        <%-- ⚠️ CORRECCIÓN 3: Los campos ahora usan los nombres 'usuario' y 'clave' que espera el Servlet. --%>
        <input type="text" name="usuario" placeholder="Usuario o Email" required>
        <input type="password" name="clave" placeholder="Contraseña" required>
        <button type="submit">Ingresar</button>
    </form>
</div>
</body>
</html>