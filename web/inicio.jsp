<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 
    INICIO.JSP - Dashboard principal
    Refactorizado: SIN scriptlets Java - 100% JSTL/EL
--%>

<%-- Validación de sesión con JSTL --%>
<c:if test="${empty sessionScope.usuario}">
    <c:redirect url="login.jsp"/>
</c:if>

<%-- Determinar si es admin --%>
<c:set var="esAdmin" value="${sessionScope.usuario.rol == 'admin' || sessionScope.usuario.rol == 'administrador'}"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - OtakuShop</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        
        .main-content {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .welcome-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .welcome-card h2 {
            color: #333;
            margin-bottom: 15px;
            font-size: 28px;
        }
        
        .user-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .detail-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .detail-item label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            display: block;
            margin-bottom: 5px;
        }
        
        .detail-item span {
            font-size: 16px;
            color: #333;
            font-weight: 600;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .menu-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            color: inherit;
        }
        
        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .menu-card .icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .menu-card h3 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .menu-card p {
            color: #666;
            font-size: 14px;
        }
        
        .admin-section {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            color: white;
        }
        
        .admin-section h3, .admin-section p {
            color: white;
        }

        /* Chatbot Styles */
        .chat-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 450px;
        }
        
        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            font-weight: bold;
            font-size: 16px;
        }
        
        .chat-messages {
            padding: 15px;
            min-height: 200px;
            max-height: 300px;
            overflow-y: auto;
            background: #f8f9fa;
        }
        
        .chat-message {
            margin: 10px 0;
            padding: 12px 15px;
            border-radius: 12px;
            max-width: 85%;
            font-size: 14px;
            line-height: 1.4;
        }
        
        .chat-bot {
            background: #e8f0fe;
            color: #333;
            margin-right: auto;
        }
        
        .chat-user {
            background: #667eea;
            color: white;
            margin-left: auto;
        }
        
        .chat-input-area {
            display: flex;
            padding: 15px;
            gap: 10px;
            border-top: 1px solid #eee;
        }
        
        .chat-input-area input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 14px;
            outline: none;
        }
        
        .chat-input-area input:focus {
            border-color: #667eea;
        }
        
        .chat-input-area button {
            padding: 12px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            transition: transform 0.2s;
        }
        
        .chat-input-area button:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <%-- Incluir navbar --%>
    <%@ include file="navbar.jsp" %>
    
    <div class="main-content">
        <%-- Tarjeta de bienvenida --%>
        <div class="welcome-card">
            <h2>
                Bienvenido, ${sessionScope.usuario.nombre} 
                <c:if test="${not empty sessionScope.usuario.apellido}">
                    ${sessionScope.usuario.apellido}
                </c:if>
                👋
            </h2>
            
            <div class="user-details">
                <div class="detail-item">
                    <label>📧 Email</label>
                    <span>${sessionScope.usuario.email}</span>
                </div>
                <div class="detail-item">
                    <label>👤 Username</label>
                    <span>
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuario.username}">
                                ${sessionScope.usuario.username}
                            </c:when>
                            <c:otherwise>
                                No definido
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="detail-item">
                    <label>🎭 Rol</label>
                    <span>
                        <c:choose>
                            <c:when test="${esAdmin}">
                                <strong style="color: #f39c12;">👑 Administrador</strong>
                            </c:when>
                            <c:otherwise>
                                <strong style="color: #3498db;">Cliente</strong>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
        
        <%-- Menú de navegación --%>
        <div class="menu-grid">
            <%-- ENLACE CORREGIDO: Apunta al Servlet --%>
            <a href="${pageContext.request.contextPath}/productos" class="menu-card">
                <div class="icon">📦</div>
                <h3>Productos</h3>
                <p>Explora nuestro catálogo de productos otaku</p>
            </a>
            
            <a href="${pageContext.request.contextPath}/carrito.jsp" class="menu-card">
                <div class="icon">🛒</div>
                <h3>Mi Carrito</h3>
                <p>Revisa los productos en tu carrito</p>
            </a>
            
            <a href="${pageContext.request.contextPath}/pedidos.jsp" class="menu-card">
                <div class="icon">📋</div>
                <h3>Mis Pedidos</h3>
                <p>Historial de compras realizadas</p>
            </a>
            
            <%-- Opciones solo para admin --%>
            <c:if test="${esAdmin}">
                <a href="${pageContext.request.contextPath}/productos?accion=nuevo" class="menu-card admin-section">
                    <div class="icon">➕</div>
                    <h3>Agregar Producto</h3>
                    <p>Añadir nuevos productos al catálogo</p>
                </a>
            </c:if>
            
            <a href="${pageContext.request.contextPath}/logout" class="menu-card">
                <div class="icon">🚪</div>
                <h3>Cerrar Sesión</h3>
                <p>Salir de tu cuenta de forma segura</p>
            </a>
        </div>
        
        <%-- Chatbot --%>
        <div class="chat-container">
            <div class="chat-header">💬 OtakuShop — Asistente Virtual</div>
            <div id="chat-messages" class="chat-messages"></div>
            <div class="chat-input-area">
                <input type="text" id="chat-input" placeholder="Escribe tu pregunta..." 
                       onkeypress="if(event.key==='Enter') enviarMensaje()">
                <button onclick="enviarMensaje()">Enviar</button>
            </div>
        </div>
    </div>

    <script>
        const messagesEl = document.getElementById('chat-messages');
        const inputEl = document.getElementById('chat-input');

        function agregarMensaje(texto, tipo) {
            const div = document.createElement('div');
            div.className = 'chat-message chat-' + tipo;
            div.textContent = texto;
            messagesEl.appendChild(div);
            messagesEl.scrollTop = messagesEl.scrollHeight;
        }

        const respuestas = [
            {palabras: ['productos','producto','catalogo','figuras','mangas','funkos'], respuesta: 'En OtakuShop tenemos figuras, mangas, funkos y más. Haz clic en "Productos" en el menú.'},
            {palabras: ['pedido','comprar','compra','orden'], respuesta: 'Para comprar, agrega productos al carrito y finaliza en "Mis Pedidos".'},
            {palabras: ['pago','pagos','metodos'], respuesta: 'Aceptamos pagos simulados y contra entrega.'},
            {palabras: ['carrito'], respuesta: 'Tu carrito muestra los productos que has agregado. Puedes verlo en el menú.'},
            {palabras: ['hola','buenos dias','buenas'], respuesta: '¡Hola! Soy el asistente de OtakuShop. ¿En qué puedo ayudarte?'},
            {palabras: ['gracias'], respuesta: '¡De nada! Estoy aquí para ayudarte 😊'},
            {palabras: ['ayuda','help'], respuesta: 'Puedo ayudarte con: productos, pedidos, carrito, pagos. ¿Qué necesitas?'}
        ];

        function obtenerRespuesta(texto) {
            const t = texto.toLowerCase();
            for (const item of respuestas) {
                for (const palabra of item.palabras) {
                    if (t.includes(palabra)) return item.respuesta;
                }
            }
            return 'No tengo respuesta para eso 😅. Pregunta sobre: productos, pedidos, carrito o pagos.';
        }

        function enviarMensaje() {
            const texto = inputEl.value.trim();
            if (!texto) return;
            
            agregarMensaje(texto, 'user');
            inputEl.value = '';
            
            setTimeout(() => {
                agregarMensaje(obtenerRespuesta(texto), 'bot');
            }, 500);
        }

        // Mensaje de bienvenida
        agregarMensaje('👋 ¡Hola! Soy el asistente de OtakuShop. Pregúntame sobre productos, pedidos o pagos.', 'bot');
    </script>
</body>
</html>
