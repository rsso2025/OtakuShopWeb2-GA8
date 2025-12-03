# 🗺️ RUTAS Y URLs DEL SISTEMA - OtakuShopWeb2

## 📍 BASE URL
```
http://localhost:8080/OtakuShopWeb2
```

---

## 🔐 AUTENTICACIÓN

| URL | Método | Descripción | Acceso |
|-----|--------|-------------|--------|
| `/` | GET | Redirige a login.jsp | Público |
| `/login.jsp` | GET | Página de login | Público |
| `/login` | POST | Procesa login | Público |
| `/logout` | GET/POST | Cierra sesión | Autenticado |
| `/cerrar-sesion` | GET/POST | Cierra sesión (alternativa) | Autenticado |

---

## 🏠 PÁGINAS PRINCIPALES

| URL | Descripción | Acceso |
|-----|-------------|--------|
| `/inicio.jsp` | Dashboard principal | Autenticado |
| `/index.jsp` | Redirección automática | Público |
| `/index.html` | Fallback de redirección | Público |

---

## 📦 PRODUCTOS

| URL | Método | Descripción | Acceso |
|-----|--------|-------------|--------|
| `/productos` | GET | Lista productos (Servlet) | Autenticado |
| `/productos.jsp` | GET | Lista productos (directo) | Autenticado |
| `/listarProductos.jsp` | GET | Vista desde Servlet | Autenticado |
| `/productos?accion=listar` | GET | Lista productos | Autenticado |
| `/productos?accion=nuevo` | GET | Formulario agregar | Admin |
| `/productos?accion=editar&id=X` | GET | Formulario editar | Admin |
| `/productos?accion=eliminar&id=X` | GET | Elimina producto | Admin |
| `/AgregarProductoServlet` | POST | Crea producto | Admin |
| `/EditarProductoServlet` | GET/POST | Edita producto | Admin |
| `/EliminarProductoServlet` | GET/POST | Elimina producto | Admin |
| `/agregarProducto.jsp` | GET | Formulario agregar | Admin |
| `/editarProducto.jsp` | GET | Formulario editar | Admin |

---

## 🛒 CARRITO

| URL | Método | Descripción | Acceso |
|-----|--------|-------------|--------|
| `/carrito.jsp` | GET | Muestra carrito | Autenticado |
| `/CarritoServlet` | POST | Agrega al carrito | Autenticado |
| `/AgregarCarritoServlet` | POST | Agrega producto | Autenticado |
| `/agregar-carrito` | POST | Agrega producto (alias) | Autenticado |
| `/ActualizarCarritoServlet` | POST | Actualiza cantidad | Autenticado |
| `/EliminarCarritoServlet` | GET | Elimina del carrito | Autenticado |

---

## 📋 PEDIDOS Y COMPRAS

| URL | Método | Descripción | Acceso |
|-----|--------|-------------|--------|
| `/pedidos.jsp` | GET | Historial de pedidos | Autenticado |
| `/PedidoServlet` | POST | Crea pedido (JSON) | Autenticado |
| `/FinalizarCompraServlet` | POST | Finaliza compra | Autenticado |
| `/finalizar-compra` | POST | Finaliza compra (alias) | Autenticado |
| `/confirmacion.jsp` | GET | Confirmación de compra | Autenticado |

---

## 🔌 APIs REST

| Endpoint | Método | Descripción | Formato |
|----------|--------|-------------|---------|
| `/api/productos` | GET | Lista productos | JSON |
| `/api/productos` | POST | Crea producto | JSON |
| `/api/usuarios` | GET | Lista usuarios | JSON |
| `/api/usuarios` | POST | Registra usuario | JSON |
| `/api/usuarios/login` | POST | Login usuario | JSON |
| `/api/carrito` | GET | Lista carrito | JSON |
| `/api/carrito` | POST | Agrega al carrito | JSON |
| `/api/pedidos` | POST | Crea pedido | JSON |

---

## ⚠️ ERRORES

| URL | Descripción |
|-----|-------------|
| `/error.jsp` | Página de error personalizada |

---

## 📝 PARÁMETROS COMUNES

### Productos
- `id` - ID del producto
- `nombre` - Nombre del producto
- `precio` - Precio (decimal)
- `stock` - Cantidad en stock
- `accion` - Acción a realizar (listar, nuevo, editar, eliminar)

### Carrito
- `idProducto` - ID del producto
- `cantidad` - Cantidad a agregar/actualizar
- `subtotal` - Subtotal calculado

### Autenticación
- `usuario` - Email o username
- `clave` - Contraseña

### Mensajes
- `status` - Estado (success, actualizado, eliminado)
- `error` - Mensaje de error
- `mensaje` - Mensaje informativo

---

## 🔄 FLUJOS DE NAVEGACIÓN

### Flujo de Login
```
/ → login.jsp → POST /login → inicio.jsp
```

### Flujo de Compra
```
productos.jsp → POST /AgregarCarritoServlet → carrito.jsp 
→ POST /FinalizarCompraServlet → confirmacion.jsp
```

### Flujo de Administración
```
inicio.jsp → productos?accion=nuevo → agregarProducto.jsp 
→ POST /AgregarProductoServlet → productos.jsp?status=success
```

---

## 🎯 EJEMPLOS DE USO

### Agregar Producto al Carrito
```html
<form action="AgregarCarritoServlet" method="post">
    <input type="hidden" name="idProducto" value="1">
    <input type="number" name="cantidad" value="1">
    <button type="submit">Agregar</button>
</form>
```

### Editar Producto (Admin)
```html
<a href="productos?accion=editar&id=1">Editar</a>
```

### Eliminar Producto (Admin)
```html
<a href="productos?accion=eliminar&id=1" 
   onclick="return confirm('¿Eliminar?')">Eliminar</a>
```

### Llamada API REST
```javascript
fetch('/OtakuShopWeb2/api/productos')
    .then(response => response.json())
    .then(data => console.log(data));
```

---

**Última actualización:** Noviembre 2025

