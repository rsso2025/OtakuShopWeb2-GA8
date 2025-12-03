<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.otakushop.model.Producto" %>
<%@ page import="com.otakushop.model.Usuario" %>
<%@ page import="com.otakushop.dao.ProductoDAO" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    ProductoDAO dao = new ProductoDAO();
    List<Producto> productos = dao.listarProductos(); // Método correcto del DAO
%>
<%@ include file="../navbar.jsp" %>
<link rel="stylesheet" href="../css/styles.css"/>

<style>
    .container {
        max-width: 1200px;
        margin: 30px auto;
        padding: 30px;
    }
    
    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
    }
    
    .productos-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 25px;
    }
    
    .producto {
        background: white;
        padding: 25px;
        border-radius: 15px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        transition: transform 0.3s, box-shadow 0.3s;
    }
    
    .producto:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 40px rgba(0,0,0,0.15);
    }
    
    .producto h3 {
        color: #333;
        margin-bottom: 10px;
        font-size: 18px;
    }
    
    .producto p {
        color: #666;
        margin-bottom: 8px;
    }
    
    .producto .precio {
        font-size: 22px;
        font-weight: bold;
        color: #667eea;
        margin: 15px 0;
    }
    
    .producto .stock {
        font-size: 13px;
        color: #888;
    }
    
    .btn {
        display: inline-block;
        padding: 12px 24px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        transition: transform 0.3s;
        text-decoration: none;
        margin-top: 15px;
    }
    
    .btn:hover {
        transform: translateY(-2px);
    }
    
    .no-productos {
        text-align: center;
        padding: 60px;
        color: #666;
    }
</style>

<div class="container">
    <h2>🎌 Catálogo de Productos</h2>
    
    <div class="productos-grid">
        <% if (productos.isEmpty()) { %>
            <div class="no-productos">
                <p>No hay productos disponibles en este momento.</p>
            </div>
        <% } else { 
            for (Producto p : productos) { %>
            <div class="producto">
                <h3><%= p.getNombre() %></h3>
                <p class="precio">$<%= String.format("%.2f", p.getPrecio()) %></p>
                <p class="stock">Stock: <%= p.getStock() %> unidades</p>
                
                <form action="../agregar-carrito" method="post">
                    <input type="hidden" name="idProducto" value="<%= p.getId() %>">
                    <input type="hidden" name="cantidad" value="1">
                    <button type="submit" class="btn">🛒 Agregar al carrito</button>
                </form>
            </div>
        <% } } %>
    </div>
</div>
</body>
</html>
