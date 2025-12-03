<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%@ page import="com.otakushop.model.Producto" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Validación de sesión --%>
<c:if test="${empty sessionScope.usuario}">
    <c:redirect url="login.jsp"/>
</c:if>

<%-- Determinar si es admin --%>
<c:set var="esAdmin" value="${sessionScope.usuario.rol == 'admin' || sessionScope.usuario.rol == 'administrador'}"/>

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
    
    .rol-admin {
        background: #f39c12;
        color: white;
    }
    
    .rol-cliente {
        background: #3498db;
        color: white;
    }
    
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
        letter-spacing: 1px;
    }
    
    tr:hover { background: #f8f9fa; }
    
    .precio { 
        color: #28a745; 
        font-weight: bold; 
        font-size: 18px; 
    }
    
    .stock-critico {
        color: #e74c3c;
        font-weight: bold;
        background: #ffeaea;
        padding: 5px 10px;
        border-radius: 5px;
        animation: pulse 1s infinite;
    }
    
    .stock-bajo {
        color: #f39c12;
        font-weight: bold;
    }
    
    .stock-normal {
        color: #27ae60;
        font-weight: bold;
    }
    
    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.7; }
    }
    
    .btn {
        padding: 10px 18px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        text-decoration: none;
        display: inline-block;
        transition: transform 0.2s, background 0.3s;
        margin: 3px;
        font-size: 13px;
    }
    
    .btn-carrito {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .btn-carrito:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }
    
    .btn-editar {
        background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
        color: white;
    }
    
    .btn-editar:hover { 
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(243, 156, 18, 0.4);
    }
    
    .btn-eliminar {
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        color: white;
    }
    
    .btn-eliminar:hover { 
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
    }
    
    .alert {
        padding: 15px 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        text-align: center;
        font-weight: 500;
    }
    
    .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    
    .alert-danger {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    
    .no-productos {
        text-align: center;
        padding: 60px;
        color: #666;
    }
    
    .no-productos .icon {
        font-size: 60px;
        margin-bottom: 20px;
    }
    
    .cantidad-input {
        width: 65px;
        padding: 8px;
        border: 2px solid #ddd;
        border-radius: 6px;
        text-align: center;
        font-size: 14px;
    }
    
    .cantidad-input:focus {
        border-color: #667eea;
        outline: none;
    }
    
    .sin-stock {
        color: #e74c3c;
        font-style: italic;
    }
    
    /* Modal para agregar producto */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
    }
    
    .modal-content {
        background-color: white;
        margin: 5% auto;
        padding: 30px;
        border-radius: 15px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        animation: modalSlide 0.3s ease;
    }
    
    @keyframes modalSlide {
        from { transform: translateY(-50px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #eee;
    }
    
    .modal-header h3 {
        margin: 0;
        color: #333;
        font-size: 22px;
    }
    
    .close-btn {
        font-size: 28px;
        cursor: pointer;
        color: #999;
        transition: color 0.3s;
    }
    
    .close-btn:hover { color: #e74c3c; }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #555;
    }
    
    .form-group input {
        width: 100%;
        padding: 12px 15px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 16px;
        transition: border-color 0.3s;
    }
    
    .form-group input:focus {
        border-color: #667eea;
        outline: none;
    }
    
    .btn-guardar {
        width: 100%;
        padding: 15px;
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
        border: none;
        border-radius: 10px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: transform 0.3s;
    }
    
    .btn-guardar:hover {
        transform: translateY(-2px);
    }
</style>

<div class="container">
    <h2>📦 Gestión de Productos</h2>
    
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
            <button onclick="abrirModal()" class="btn-agregar-nuevo">
                ➕ Agregar Nuevo Producto
            </button>
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
                <%-- Columna de carrito para todos --%>
                <th>
                    <c:choose>
                        <c:when test="${esAdmin}">Agregar al Carrito</c:when>
                        <c:otherwise>Comprar</c:otherwise>
                    </c:choose>
                </th>
                <%-- Columna de admin solo para administradores --%>
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
                                <button onclick="abrirModal()" class="btn btn-carrito" style="margin-top: 20px;">
                                    ➕ Agregar el primer producto
                                </button>
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
                                <%-- Stock con alertas visuales para admin --%>
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
                                            <c:if test="${esAdmin}"> (Bajo)</c:if>
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
                                <%-- Botón agregar al carrito --%>
                                <c:choose>
                                    <c:when test="${producto.stock > 0}">
                                        <form action="AgregarCarritoServlet" method="post" style="display: inline;">
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
                            <%-- Botones de administración solo para admin --%>
                            <c:if test="${esAdmin}">
                                <td>
                                    <a href="productos?accion=editar&id=${producto.id}" class="btn btn-editar">
                                        ✏️ Editar
                                    </a>
                                    <a href="productos?accion=eliminar&id=${producto.id}" class="btn btn-eliminar"
                                       onclick="return confirm('¿Estás seguro de eliminar el producto: ${producto.nombre}?')">
                                        🗑️ Eliminar
                                    </a>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    
    <p style="text-align: center; margin-top: 30px;">
        <a href="carrito.jsp" style="color: #667eea; font-weight: bold; text-decoration: none; font-size: 18px;">
            🛒 Ver mi Carrito
        </a>
    </p>
</div>

<%-- Modal para agregar producto (solo visible para admin) --%>
<c:if test="${esAdmin}">
<div id="modalAgregar" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>➕ Agregar Nuevo Producto</h3>
            <span class="close-btn" onclick="cerrarModal()">&times;</span>
        </div>
        <form action="productos" method="post">
            <input type="hidden" name="accion" value="agregar">
            
            <div class="form-group">
                <label for="nombre">Nombre del Producto</label>
                <input type="text" id="nombre" name="nombre" placeholder="Ej: Figura Goku" required>
            </div>
            
            <div class="form-group">
                <label for="precio">Precio ($)</label>
                <input type="number" id="precio" name="precio" step="0.01" min="0.01" 
                       placeholder="Ej: 120.50" required>
            </div>
            
            <div class="form-group">
                <label for="stock">Stock Inicial</label>
                <input type="number" id="stock" name="stock" min="0" placeholder="Ej: 10" required>
            </div>
            
            <button type="submit" class="btn-guardar">💾 Guardar Producto</button>
        </form>
    </div>
</div>

<script>
    function abrirModal() {
        document.getElementById('modalAgregar').style.display = 'block';
    }
    
    function cerrarModal() {
        document.getElementById('modalAgregar').style.display = 'none';
    }
    
    // Cerrar modal al hacer clic fuera
    window.onclick = function(event) {
        var modal = document.getElementById('modalAgregar');
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }
    
    // Cerrar con ESC
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            cerrarModal();
        }
    });
</script>
</c:if>

</body>
</html>



