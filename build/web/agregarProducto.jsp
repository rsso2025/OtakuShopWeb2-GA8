<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Verificar rol administrador
    if (!"administrador".equals(usuario.getRol())) {
        response.sendRedirect("inicio.jsp?error=Acceso denegado");
        return;
    }
%>
<%@ include file="navbar.jsp" %>

<style>
    .container {
        max-width: 500px;
        margin: 50px auto;
        padding: 40px;
        background: white;
        border-radius: 20px;
        box-shadow: 0 15px 50px rgba(0,0,0,0.15);
    }
    
    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
        font-size: 26px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    label {
        display: block;
        margin-bottom: 8px;
        color: #555;
        font-weight: 600;
        font-size: 14px;
    }
    
    input[type="text"],
    input[type="number"] {
        width: 100%;
        padding: 14px;
        border: 2px solid #e0e0e0;
        border-radius: 10px;
        font-size: 16px;
        transition: border-color 0.3s, box-shadow 0.3s;
    }
    
    input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
    }
    
    .btn-submit {
        width: 100%;
        padding: 16px;
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
        border: none;
        border-radius: 10px;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        transition: transform 0.3s, box-shadow 0.3s;
        margin-top: 10px;
    }
    
    .btn-submit:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 30px rgba(40, 167, 69, 0.4);
    }
    
    .btn-cancel {
        display: block;
        text-align: center;
        margin-top: 15px;
        color: #666;
        text-decoration: none;
    }
    
    .btn-cancel:hover { color: #333; text-decoration: underline; }
    
    .alert {
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 20px;
        text-align: center;
    }
    
    .alert-danger {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    
    .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
</style>

<div class="container">
    <h2>➕ Agregar Nuevo Producto</h2>
    
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger">${requestScope.error}</div>
    </c:if>
    
    <c:if test="${param.status == 'success'}">
        <div class="alert alert-success">¡Producto agregado exitosamente!</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/AgregarProductoServlet" method="post">
        
        <div class="form-group">
            <label for="nombre">Nombre del Producto</label>
            <input type="text" id="nombre" name="nombre" 
                   placeholder="Ej: Figura Goku Super Saiyan" required>
        </div>
        
        <div class="form-group">
            <label for="precio">Precio ($)</label>
            <input type="number" id="precio" name="precio" step="0.01" min="0.01" 
                   placeholder="Ej: 120.50" required>
        </div>
        
        <div class="form-group">
            <label for="stock">Stock Inicial</label>
            <input type="number" id="stock" name="stock" min="0" 
                   placeholder="Ej: 10" required>
        </div>
        
        <button type="submit" class="btn-submit">✅ Agregar Producto</button>
        <a href="productos.jsp" class="btn-cancel">Cancelar</a>
    </form>
</div>
</body>
</html>



