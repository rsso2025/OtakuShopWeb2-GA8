<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - OtakuShop</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .error-container {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .error-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        
        h1 {
            color: #e74c3c;
            margin-bottom: 15px;
            font-size: 28px;
        }
        
        p {
            color: #666;
            margin-bottom: 30px;
            font-size: 16px;
            line-height: 1.6;
        }
        
        .error-details {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: left;
            font-family: monospace;
            font-size: 13px;
            color: #c0392b;
            max-height: 150px;
            overflow-y: auto;
        }
        
        .btn {
            display: inline-block;
            padding: 14px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: bold;
            transition: transform 0.3s, box-shadow 0.3s;
            margin: 5px;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #95a5a6;
        }
        
        .btn-secondary:hover {
            box-shadow: 0 10px 30px rgba(149, 165, 166, 0.4);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">😵</div>
        <h1>¡Oops! Algo salió mal</h1>
        
        <c:choose>
            <c:when test="${not empty requestScope.error}">
                <p>${requestScope.error}</p>
            </c:when>
            <c:when test="${not empty param.mensaje}">
                <p>${param.mensaje}</p>
            </c:when>
            <c:otherwise>
                <p>Ha ocurrido un error inesperado. Por favor, intenta nuevamente o contacta al soporte.</p>
            </c:otherwise>
        </c:choose>
        
        <% if (exception != null) { %>
        <div class="error-details">
            <strong>Detalle técnico:</strong><br>
            <%= exception.getMessage() %>
        </div>
        <% } %>
        
        <div>
            <a href="inicio.jsp" class="btn">🏠 Ir al Inicio</a>
            <a href="javascript:history.back()" class="btn btn-secondary">⬅️ Volver</a>
        </div>
    </div>
</body>
</html>



