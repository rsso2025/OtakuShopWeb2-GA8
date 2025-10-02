<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - OtakuShop</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f6fa;
            margin: 0;
            padding: 20px;
        }
        h2 { color: #1f6feb; }
        .menu {
            margin: 20px 0;
            padding: 10px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .menu ul { list-style: none; padding: 0; }
        .menu li { margin: 10px 0; }
        .menu a {
            text-decoration: none;
            color: #1f6feb;
            font-weight: bold;
        }
        /* --- Estilos Chatbot --- */
        .os-chat-container{width:100%;max-width:420px;background:#fff;border-radius:12px;box-shadow:0 6px 18px rgba(0,0,0,.08);display:flex;flex-direction:column;overflow:hidden;font-family:Arial,Helvetica,sans-serif;margin-top:20px}
        .os-chat-header{background:#1f6feb;color:#fff;padding:10px 14px;font-weight:700}
        .os-messages{flex:1;padding:12px;overflow:auto;background:#f7f9fc;min-height:120px}
        .os-message{margin:8px 0;padding:9px;border-radius:10px;max-width:80%;font-size:14px;line-height:1.3}
        .os-bot{background:#eef2ff;align-self:flex-start}
        .os-user{background:#d0e8ff;align-self:flex-end}
        .os-input-area{display:flex;border-top:1px solid #e6eefb;padding:8px}
        .os-input-area input{flex:1;padding:9px;border:1px solid #e2e8f0;border-radius:6px}
        .os-input-area button{margin-left:8px;padding:9px 12px;border:none;background:#1f6feb;color:#fff;border-radius:6px;cursor:pointer}
        @media (max-width:480px){.os-chat-container{max-width:95%}}
    </style>
</head>
<body>
    <h2>Bienvenido <%= usuario.getNombre() %> 👋</h2>
    <p>Email: <%= usuario.getEmail() %></p>

    <div class="menu">
        <h3>Menú principal</h3>
        <ul>
            <li><a href="productos.jsp">Gestión de productos</a></li>
            <li><a href="carrito.jsp">Ver carrito</a></li>
            <li><a href="pedidos.jsp">Mis pedidos</a></li>
            <li><a href="logout.jsp">Cerrar sesión</a></li>
        </ul>
    </div>

    <!-- Chatbot OtakuShop -->
    <div id="os-chat-wrapper" class="os-chat-container" role="region" aria-label="Asistente OtakuShop">
      <div class="os-chat-header">OtakuShop — Asistente</div>
      <div id="os-messages" class="os-messages" role="log" aria-live="polite"></div>
      <div class="os-input-area">
        <input id="os-userInput" placeholder="Escribe tu pregunta..." aria-label="Pregunta">
        <button id="os-sendBtn">Enviar</button>
      </div>
    </div>

    <script>
      const messagesEl = document.getElementById('os-messages');
      const inputEl = document.getElementById('os-userInput');

      function addMessage(text, who){
        const d = document.createElement('div');
        d.className = 'os-message ' + (who === 'user' ? 'os-user' : 'os-bot');
        d.textContent = text;
        messagesEl.appendChild(d);
        messagesEl.scrollTop = messagesEl.scrollHeight;
      }

      // Base de conocimiento personalizada
      const KB = [
        {k:['productos','producto','catálogo','catalogo','figuras','mangas','funkos','peliculas'], r:'En OtakuShop tenemos figuras, mangas, funkos y películas de anime. El catálogo completo está en la sección Productos.'},
        {k:['catalogo','catálogo'], r:'Haz clic en la pestaña “Productos” o ingresa a /productos.jsp.'},
        {k:['pedido','comprar','compra','orden'], r:'Inicia sesión, agrega productos al carrito y confirma la compra en la sección “Pedidos”.'},
        {k:['pago','pagos','metodos'], r:'Aceptamos pagos simulados en línea (demo) y pagos contra entrega.'},
        {k:['login','iniciar','sesion','entrar'], r:'Inicia sesión desde la página login.jsp con tu correo y contraseña.'},
        {k:['registro','registrar','crear cuenta'], r:'Por ahora el registro se hace en la base de datos con usuarios de prueba. Pronto estará disponible un formulario en línea.'},
        {k:['objetivo','proyecto','meta'], r:'OtakuShopWeb2 es un proyecto académico para gestionar una tienda online con Java, JSP, Servlets y MySQL.'},
        {k:['api','endpoint','rest'], r:'Sí, tenemos endpoints REST para usuarios, productos, carrito y pedidos. Ejemplo: /api/productos'},
        {k:['repo','github','repositorio','codigo'], r:'Repositorio oficial: https://github.com/rsso2025/GA7-220501096-AA3-EV01'}
      ];

      function getAnswer(text){
        const t = text.toLowerCase();
        for(const item of KB){
          for(const kw of item.k){
            if(t.includes(kw)) return item.r;
          }
        }
        return 'Lo siento, no tengo respuesta para eso 😅. Pregunta por: productos, pedido, login, API o repositorio.';
      }

      function ask(text){
        addMessage(text, 'user');
        inputEl.value = '';
        const ans = getAnswer(text);
        addMessage(ans, 'bot');
      }

      document.getElementById('os-sendBtn').addEventListener('click', ()=>{
        const t = inputEl.value.trim(); if(t) ask(t);
      });
      inputEl.addEventListener('keypress', (e)=>{ if(e.key==='Enter'){ const t=inputEl.value.trim(); if(t) ask(t); }});

      // Mensaje inicial
      addMessage('👋 Hola — soy el asistente de OtakuShop. Pregunta por productos, pedido, login, API o repositorio.', 'bot');
    </script>
</body>
</html>
