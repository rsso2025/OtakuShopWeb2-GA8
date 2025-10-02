<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login OtakuShop</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f0f0; }
        .container { width: 400px; margin: 100px auto; padding: 20px; background: white; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; }
        input { width: 100%; padding: 10px; margin: 5px 0; }
        button { width: 100%; padding: 10px; background: #007BFF; color: white; border: none; border-radius: 5px; }
        .error { color: red; text-align: center; }
    </style>
</head>
<body>
<div class="container">
    <h2>Login OtakuShop</h2>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form method="post" action="login">
        <input type="text" name="usuario" placeholder="Correo electrónico" required>
        <input type="password" name="clave" placeholder="Contraseña" required>
        <button type="submit">Iniciar sesión</button>
    </form>
</div>
</body>
</html>
