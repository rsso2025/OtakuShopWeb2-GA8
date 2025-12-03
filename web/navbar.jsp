<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 
    NAVBAR.JSP - Refactorizado con JSTL/EL puro
    SIN scriptlets Java - Elimina error "Duplicate local variable"
--%>

<%-- Determinar si es admin (compatible con 'admin' y 'administrador') --%>
<c:set var="esAdmin" value="${sessionScope.usuario.rol == 'admin' || sessionScope.usuario.rol == 'administrador'}"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OtakuShop</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f2f5; }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .navbar .logo {
            color: white;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
        }
        
        .navbar .logo:hover { opacity: 0.9; }
        
        .navbar nav { display: flex; gap: 20px; align-items: center; flex-wrap: wrap; }
        
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: background 0.3s, transform 0.2s;
            font-weight: 500;
        }
        
        .navbar a:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }
        
        .navbar .user-info {
            color: rgba(255,255,255,0.9);
            font-size: 14px;
            padding: 8px 12px;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .navbar .btn-logout {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .navbar .btn-logout:hover {
            background: #e74c3c;
            border-color: #e74c3c;
        }
        
        .admin-badge {
            background: #f39c12;
            color: #000;
            font-size: 11px;
            padding: 3px 10px;
            border-radius: 10px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .cliente-badge {
            background: #3498db;
            color: white;
            font-size: 11px;
            padding: 3px 10px;
            border-radius: 10px;
        }
        
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 15px;
            }
            .navbar nav {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/inicio.jsp" class="logo">🎌 OtakuShop</a>
        <nav>
            <a href="${pageContext.request.contextPath}/inicio.jsp">🏠 Inicio</a>
            
            <%-- ENLACE CORREGIDO: Apunta al Servlet, no al JSP directo --%>
            <a href="${pageContext.request.contextPath}/productos">📦 Productos</a>
            
            <a href="${pageContext.request.contextPath}/carrito.jsp">🛒 Carrito</a>
            <a href="${pageContext.request.contextPath}/pedidos.jsp">📋 Pedidos</a>
            
            <%-- Solo admin puede ver el enlace de agregar producto --%>
            <c:if test="${esAdmin}">
                <a href="${pageContext.request.contextPath}/productos?accion=nuevo">➕ Agregar Producto</a>
            </c:if>
            
            <%-- Información del usuario usando EL --%>
            <span class="user-info">
                👤 
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario.nombre}">
                        ${sessionScope.usuario.nombre}
                    </c:when>
                    <c:otherwise>
                        Invitado
                    </c:otherwise>
                </c:choose>
                
                <%-- Badge de rol --%>
                <c:choose>
                    <c:when test="${esAdmin}">
                        <span class="admin-badge">👑 ADMIN</span>
                    </c:when>
                    <c:when test="${not empty sessionScope.usuario}">
                        <span class="cliente-badge">CLIENTE</span>
                    </c:when>
                </c:choose>
            </span>
            
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Salir</a>
        </nav>
    </div>
