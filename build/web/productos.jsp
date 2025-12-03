<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.otakushop.dao.ProductoDAO" %>
<%@ page import="com.otakushop.model.Producto" %>
<%@ page import="java.util.List" %>
<%-- 
    PRODUCTOS.JSP - Vista de productos
    Refactorizado: Mínimos scriptlets, máximo JSTL/EL
--%>

<%-- Validación de sesión --%>
<c:if test="${empty sessionScope.usuario}">
    <c:redirect url="login.jsp"/>
</c:if>

<%-- Determinar si es admin --%>
<c:set var="esAdmin" value="${sessionScope.usuario.rol == 'admin' || sessionScope.usuario.rol == 'administrador'}"/>

<%-- Cargar productos si no vienen del servlet --%>
<c:if test="${empty productos}">
    <%
        ProductoDAO dao = new ProductoDAO();
        List<Producto> listaProductos = dao.listarProductos();
        request.setAttribute("productos", listaProductos);
    %>
</c:if>

<%@ include file="navbar.jsp" %>

<style>
    .container {
        max-width: 1200px;
        margin: 30px auto;
        padding: 30px;
        background: white;
        border-radius: 15px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    }
    
    h2 {
        color: #333;
        margin-bottom: 10px;
        text-align: center;
        font-size: 28px;
    }
    
    .header-info {
        text-align: center;
        margin-bottom: 30px;
        color: #666;
    }
    
    .rol-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
        margin-left: 10px;
    }
    
    .rol-admin { background: #f39c12; color: white; }
    .rol-cliente { background: #3498db; color: white; }
    
    .admin-actions {
        text-align: center;
        margin-bottom: 30px;
    }
    
    .btn-agregar-nuevo {
        display: inline-block;
        padding: 14px 30px;
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
        text-decoration: none;
        border-radius: 10px;
        font-weight: bold;
        transition: transform 0.3s, box-shadow 0.3s;
        border: none;
        cursor: pointer;
        font-size: 16px;
    }
    
    .btn-agregar-nuevo:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 30px rgba(40, 167, 69, 0.4);
    }
    
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    
    th, td {
        padding: 15px;
        text-align: center;
        border-bottom: 1px solid #e0e0e0;
    }
    
    th {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 13px;
    }
    
    tr:hover { background: #f8f9fa; }
    
    .precio { color: #28a745; font-weight: bold; font-size: 18px; }
    
    .stock-critico {
        color: #e74c3c;
        font-weight: bold;
        background: #ffeaea;
        padding: 5px 10px;
        border-radius: 5px;
    }
    
    .stock-bajo { color: #f39c12; font-weight: bold; }
    .stock-normal { color: #27ae60; font-weight: bold; }
    
    .btn {
        padding: 10px 18px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        text-decoration: none;
        display: inline-block;
        transition: transform 0.2s;
        margin: 3px;
        font-size: 13px;
    }
    
    .btn-carrito {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .btn-carrito:hover { transform: translateY(-2px); }
    
    .btn-editar {
        background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
        color: white;
    }
    
    .btn-eliminar {
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        color: white;
    }
    
    .alert {
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 20px;
        text-align: center;
    }
    
    .alert-success { background: #d4edda; color: #155724; }
    .alert-danger { background: #f8d7da; color: #721c24; }
    
    .no-productos {
        text-align: center;
        padding: 60px;
        color: #666;
    }
    
    .no-productos .icon { font-size: 60px; margin-bottom: 20px; }
    
    .cantidad-input {
        width: 65px;
        padding: 8px;
        border: 2px solid #ddd;
        border-radius: 6px;
        text-align: center;
    }
    
    .sin-stock { color: #e74c3c; font-style: italic; }
</style>

<div class="container">
    <h2>📦 Productos Disponibles</h2>
    
    <p class="header-info">
        Bienvenido, <strong>${sessionScope.usuario.nombre}</strong>
        <c:choose>
            <c:when test="${esAdmin}">
                <span class="rol-badge rol-admin">👑 ADMINISTRADOR</span>
            </c:when>
            <c:otherwise>
                <span class="rol-badge rol-cliente">👤 CLIENTE</span>
            </c:otherwise>
        </c:choose>
    </p>
    
    <%-- Botón agregar solo para admin --%>
    <c:if test="${esAdmin}">
        <div class="admin-actions">
            <a href="${pageContext.request.contextPath}/productos?accion=nuevo" class="btn-agregar-nuevo">
                ➕ Agregar Nuevo Producto
            </a>
        </div>
    </c:if>
    
    <%-- Mensajes de estado --%>
    <c:if test="${param.status == 'success'}">
        <div class="alert alert-success">✅ Producto agregado exitosamente</div>
    </c:if>
    <c:if test="${param.status == 'actualizado'}">
        <div class="alert alert-success">✅ Producto actualizado exitosamente</div>
    </c:if>
    <c:if test="${param.status == 'eliminado'}">
        <div class="alert alert-success">✅ Producto eliminado exitosamente</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">❌ ${param.error}</div>
    </c:if>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Precio</th>
                <th>Stock</th>
                <th>Agregar al Carrito</th>
                <c:if test="${esAdmin}">
                    <th>Administrar</th>
                </c:if>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty productos}">
                    <tr>
                        <td colspan="${esAdmin ? '6' : '5'}" class="no-productos">
                            <div class="icon">📭</div>
                            <p>No hay productos registrados</p>
                            <c:if test="${esAdmin}">
                                <a href="${pageContext.request.contextPath}/productos?accion=nuevo" 
                                   class="btn btn-carrito" style="margin-top: 20px;">
                                    ➕ Agregar el primer producto
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="producto" items="${productos}">
                        <tr>
                            <td>${producto.id}</td>
                            <td><strong>${producto.nombre}</strong></td>
                            <td class="precio">
                                $<fmt:formatNumber value="${producto.precio}" pattern="#,##0.00"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${producto.stock == 0}">
                                        <span class="stock-critico">⚠️ SIN STOCK</span>
                                    </c:when>
                                    <c:when test="${producto.stock < 5}">
                                        <span class="stock-critico">
                                            🔴 ${producto.stock} unidades
                                            <c:if test="${esAdmin}"> (¡CRÍTICO!)</c:if>
                                        </span>
                                    </c:when>
                                    <c:when test="${producto.stock < 10}">
                                        <span class="stock-bajo">
                                            🟡 ${producto.stock} unidades
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-normal">
                                            🟢 ${producto.stock} unidades
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${producto.stock > 0}">
                                        <form action="${pageContext.request.contextPath}/AgregarCarritoServlet" 
                                              method="post" style="display: inline;">
                                            <input type="hidden" name="idProducto" value="${producto.id}">
                                            <input type="number" name="cantidad" value="1" min="1" 
                                                   max="${producto.stock}" class="cantidad-input">
                                            <button type="submit" class="btn btn-carrito">🛒 Agregar</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="sin-stock">Sin stock disponible</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <c:if test="${esAdmin}">
                                <td>
                                    <a href="${pageContext.request.contextPath}/productos?accion=editar&id=${producto.id}" 
                                       class="btn btn-editar">✏️ Editar</a>
                                    <a href="${pageContext.request.contextPath}/productos?accion=eliminar&id=${producto.id}" 
                                       class="btn btn-eliminar"
                                       onclick="return confirm('¿Eliminar ${producto.nombre}?')">🗑️ Eliminar</a>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    
    <p style="text-align: center; margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/carrito.jsp" 
           style="color: #667eea; font-weight: bold; text-decoration: none; font-size: 18px;">
            🛒 Ver mi Carrito
        </a>
    </p>
</div>
</body>
</html>
