<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.otakushop.model.Usuario" %>
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
    .confirmacion-container {
        max-width: 600px;
        margin: 80px auto;
        padding: 50px;
        background: white;
        border-radius: 20px;
        box-shadow: 0 15px 50px rgba(0,0,0,0.15);
        text-align: center;
    }
    
    .icon-success {
        font-size: 80px;
        margin-bottom: 20px;
        animation: bounce 0.6s ease-out;
    }
    
    @keyframes bounce {
        0% { transform: scale(0); }
        50% { transform: scale(1.2); }
        100% { transform: scale(1); }
    }
    
    h2 {
        color: #28a745;
        margin-bottom: 20px;
        font-size: 32px;
    }
    
    p {
        color: #666;
        font-size: 18px;
        line-height: 1.6;
        margin-bottom: 30px;
    }
    
    .mensaje {
        background: #d4edda;
        color: #155724;
        padding: 15px 25px;
        border-radius: 10px;
        display: inline-block;
        margin-bottom: 30px;
        font-weight: 500;
    }
    
    .btn-group {
        display: flex;
        gap: 15px;
        justify-content: center;
        flex-wrap: wrap;
    }
    
    .btn {
        display: inline-block;
        padding: 14px 30px;
        border-radius: 10px;
        text-decoration: none;
        font-weight: bold;
        transition: transform 0.3s, box-shadow 0.3s;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .btn-secondary {
        background: #f8f9fa;
        color: #333;
        border: 2px solid #ddd;
    }
    
    .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }
    
    .detalles {
        margin-top: 40px;
        padding-top: 30px;
        border-top: 1px solid #eee;
        text-align: left;
    }
    
    .detalles h3 {
        color: #333;
        margin-bottom: 15px;
    }
    
    .detalles ul {
        list-style: none;
        padding: 0;
    }
    
    .detalles li {
        padding: 8px 0;
        color: #666;
        border-bottom: 1px solid #f0f0f0;
    }
    
    .detalles li strong {
        color: #333;
    }
</style>

<div class="confirmacion-container">
    <div class="icon-success">✅</div>
    <h2>¡Compra realizada con éxito!</h2>
    
    <c:if test="${not empty param.mensaje}">
        <div class="mensaje">${param.mensaje}</div>
    </c:if>
    
    <p>Gracias por tu compra, <strong><%= usuario.getNombre() %></strong>. 
       Hemos registrado tu pedido y te enviaremos los detalles a tu correo electrónico.</p>
    
    <div class="btn-group">
        <a href="pedidos.jsp" class="btn btn-primary">📋 Ver mis pedidos</a>
        <a href="productos.jsp" class="btn btn-secondary">🛍️ Seguir comprando</a>
    </div>
    
    <div class="detalles">
        <h3>📧 Información de contacto</h3>
        <ul>
            <li><strong>Email:</strong> <%= usuario.getEmail() %></li>
            <li><strong>Estado del pedido:</strong> Procesando</li>
            <li><strong>Tiempo estimado:</strong> 3-5 días hábiles</li>
        </ul>
    </div>
</div>
</body>
</html>
