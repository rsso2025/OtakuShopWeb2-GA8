# 📊 DIAGRAMAS DE ARQUITECTURA - OtakuShopWeb2

## 1. ARQUITECTURA GENERAL DEL SISTEMA

```
┌─────────────────────────────────────────────────────────────┐
│                      CLIENTE WEB                            │
│                  (Navegador - Chrome/Firefox)              │
└───────────────────────────┬─────────────────────────────────┘
                            │ HTTP/HTTPS
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    APACHE TOMCAT 9.0                        │
│              (Servidor Web + Contenedor Servlets)          │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │              OtakuShopWeb2.war                      │  │
│  │                                                      │  │
│  │  ┌──────────────┐  ┌──────────────┐               │  │
│  │  │   Servlets   │  │     JSPs     │               │  │
│  │  │ (Controlador)│  │   (Vista)    │               │  │
│  │  └──────┬───────┘  └──────┬───────┘               │  │
│  │         │                  │                       │  │
│  │  ┌──────▼──────────────────▼───────┐              │  │
│  │  │         DAOs (Modelo)            │              │  │
│  │  │  - UsuarioDAO                   │              │  │
│  │  │  - ProductoDAO                  │              │  │
│  │  │  - CarritoDAO                   │              │  │
│  │  │  - PedidoDAO                    │              │  │
│  │  └──────────────┬──────────────────┘              │  │
│  └─────────────────┼──────────────────────────────────┘  │
└─────────────────────┼──────────────────────────────────────┘
                      │ JDBC
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    MYSQL 8.0                                │
│              Base de Datos: otakushop                       │
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │ usuarios│  │productos │  │ carrito  │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │ pedidos  │  │detalle_  │  │ compras  │                  │
│  │          │  │pedido    │  │          │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. FLUJO DE PETICIÓN HTTP

```
┌─────────┐
│ Cliente │
└────┬────┘
     │ 1. GET /OtakuShopWeb2/productos
     ▼
┌─────────────────┐
│  Apache Tomcat  │
│  (Puerto 8080)  │
└────┬────────────┘
     │ 2. Busca en web.xml
     ▼
┌─────────────────┐
│    web.xml      │
│  Mapea URL      │
│  /productos →   │
│  ProductoServlet│
└────┬────────────┘
     │ 3. Instancia Servlet
     ▼
┌─────────────────┐
│ ProductoServlet │
│  doGet()         │
└────┬────────────┘
     │ 4. Valida sesión
     ▼
┌─────────────────┐
│  UsuarioDAO     │
│  (si necesario) │
└────┬────────────┘
     │ 5. Obtiene datos
     ▼
┌─────────────────┐
│  ProductoDAO     │
│  listarProductos│
└────┬────────────┘
     │ 6. Query SQL
     ▼
┌─────────────────┐
│     MySQL        │
│  SELECT * FROM   │
│  productos       │
└────┬────────────┘
     │ 7. ResultSet
     ▼
┌─────────────────┐
│  ProductoServlet │
│  request.setAttr │
│  ("productos",..)│
└────┬────────────┘
     │ 8. Forward
     ▼
┌─────────────────┐
│ listarProductos  │
│     .jsp        │
│  Renderiza HTML │
└────┬────────────┘
     │ 9. HTML Response
     ▼
┌─────────┐
│ Cliente │
│ (HTML)  │
└─────────┘
```

---

## 3. ARQUITECTURA MVC

```
┌─────────────────────────────────────────────────────────┐
│                      CAPA VISTA                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │login.jsp │  │productos │  │carrito.jsp│              │
│  │          │  │   .jsp   │  │           │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │inicio.jsp│  │pedidos   │  │navbar.jsp│              │
│  │          │  │   .jsp   │  │(include) │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│                                                         │
│  Tecnología: JSP + JSTL + EL + HTML5 + CSS3           │
└───────────────────────┬───────────────────────────────┘
                        │ request/response
                        ▼
┌─────────────────────────────────────────────────────────┐
│                   CAPA CONTROLADOR                       │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │LoginServlet  │  │ProductoServlet│                    │
│  └──────────────┘  └──────────────┘                     │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │CarritoServlet│  │PedidoServlet │                     │
│  └──────────────┘  └──────────────┘                     │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │AgregarCarrito│  │FinalizarCompra│                    │
│  │   Servlet    │  │   Servlet    │                     │
│  └──────────────┘  └──────────────┘                     │
│                                                         │
│  Tecnología: Java Servlets 3.1                         │
│  Responsabilidad: Validación, lógica de negocio       │
└───────────────────────┬───────────────────────────────┘
                        │ llamadas
                        ▼
┌─────────────────────────────────────────────────────────┐
│                      CAPA MODELO                         │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │ UsuarioDAO   │  │ ProductoDAO  │                     │
│  └──────────────┘  └──────────────┘                     │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │ CarritoDAO   │  │ PedidoDAO    │                     │
│  └──────────────┘  └──────────────┘                     │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │   Usuario    │  │  Producto    │                     │
│  │   (Model)    │  │   (Model)    │                     │
│  └──────────────┘  └──────────────┘                     │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │   Carrito    │  │   Pedido     │                     │
│  │   (Model)    │  │   (Model)    │                     │
│  └──────────────┘  └──────────────┘                     │
│                                                         │
│  Tecnología: Java + JDBC                               │
│  Responsabilidad: Acceso a datos, CRUD                  │
└───────────────────────┬───────────────────────────────┘
                        │ SQL
                        ▼
┌─────────────────────────────────────────────────────────┐
│                   BASE DE DATOS                          │
│                    MySQL 8.0                             │
│                  (otakushop)                             │
└─────────────────────────────────────────────────────────┘
```

---

## 4. DIAGRAMA DE SECUENCIA - PROCESO DE COMPRA

```
Cliente          JSP          Servlet          DAO          MySQL
  │              │              │              │             │
  │──GET────────>│              │              │             │
  │              │──GET────────>│              │             │
  │              │              │──listar()───>│             │
  │              │              │              │──SELECT────>│
  │              │              │              │<──ResultSet─│
  │              │              │<──List───────│             │
  │              │<──forward───│              │             │
  │<──HTML───────│              │              │             │
  │              │              │              │             │
  │──POST───────>│              │              │             │
  │(agregar)     │──POST────────>│              │             │
  │              │              │──agregar()──>│             │
  │              │              │              │──INSERT────>│
  │              │              │              │<──OK────────│
  │              │<──redirect───│              │             │
  │<──redirect───│              │              │             │
  │              │              │              │             │
  │──GET────────>│              │              │             │
  │(carrito)     │──GET────────>│              │             │
  │              │              │──obtener()──>│             │
  │              │              │              │──SELECT────>│
  │              │              │              │<──ResultSet──│
  │              │              │<──List───────│             │
  │              │<──forward───│              │             │
  │<──HTML───────│              │              │             │
  │              │              │              │             │
  │──POST───────>│              │              │             │
  │(finalizar)   │──POST────────>│              │             │
  │              │              │──finalizar()>│             │
  │              │              │              │──BEGIN─────>│
  │              │              │              │──INSERT─────>│
  │              │              │              │──UPDATE─────>│
  │              │              │              │──DELETE─────>│
  │              │              │              │──COMMIT──────>│
  │              │<──redirect───│              │             │
  │<──redirect───│              │              │             │
```

---

## 5. DIAGRAMA DE CLASES (Simplificado)

```
┌─────────────────────┐
│      Usuario        │
├─────────────────────┤
│ - id: int           │
│ - nombre: String    │
│ - apellido: String  │
│ - email: String     │
│ - password: String │
│ - username: String │
│ - rol: String       │
└─────────────────────┘
         ▲
         │
         │
┌─────────────────────┐
│    UsuarioDAO       │
├─────────────────────┤
│ + login(): Usuario  │
└─────────────────────┘
         │
         │ usa
         ▼
┌─────────────────────┐
│     Conexion        │
├─────────────────────┤
│ + getConnection()   │
└─────────────────────┘

┌─────────────────────┐
│     Producto        │
├─────────────────────┤
│ - id: int           │
│ - nombre: String    │
│ - precio: double    │
│ - stock: int        │
└─────────────────────┘
         ▲
         │
┌─────────────────────┐
│    ProductoDAO      │
├─────────────────────┤
│ + listar(): List    │
│ + agregar(): boolean│
│ + actualizar(): bool│
│ + eliminar(): bool  │
└─────────────────────┘

┌─────────────────────┐
│      Carrito        │
├─────────────────────┤
│ - id: int           │
│ - idUsuario: int    │
│ - idProducto: int   │
│ - cantidad: int     │
│ - subtotal: double  │
└─────────────────────┘
         ▲
         │
┌─────────────────────┐
│     CarritoDAO      │
├─────────────────────┤
│ + agregar()         │
│ + actualizar()      │
│ + eliminar()        │
│ + listar(): List    │
└─────────────────────┘
```

---

## 6. DIAGRAMA DE COMPONENTES

```
┌──────────────────────────────────────────────────┐
│           APLICACIÓN WEB (WAR)                   │
│                                                   │
│  ┌──────────────┐      ┌──────────────┐        │
│  │   Servlets   │──────▶│     JSPs     │        │
│  │              │       │              │        │
│  └──────┬───────┘       └──────┬───────┘        │
│         │                      │                 │
│         │                      │                 │
│  ┌──────▼──────────────────────▼───────┐       │
│  │            DAOs                      │       │
│  │  - UsuarioDAO                       │       │
│  │  - ProductoDAO                      │       │
│  │  - CarritoDAO                       │       │
│  │  - PedidoDAO                        │       │
│  └──────┬──────────────────────────────┘       │
│         │                                        │
│  ┌──────▼──────────┐                           │
│  │   Conexion.java │                           │
│  │   (Utilidad)    │                           │
│  └──────┬──────────┘                           │
└─────────┼──────────────────────────────────────┘
          │ JDBC
          ▼
┌──────────────────────────────────────────────────┐
│         MySQL Connector JAR                      │
│      (mysql-connector-java-5.1.49.jar)          │
└─────────────────────┬────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────────┐
│              MySQL Server                        │
│            (Base de datos)                       │
└──────────────────────────────────────────────────┘
```

---

## 7. FLUJO DE AUTENTICACIÓN

```
┌─────────┐
│ Cliente │
└────┬────┘
     │ 1. GET /login.jsp
     ▼
┌─────────────┐
│  login.jsp  │
│ (Formulario)│
└────┬────────┘
     │ 2. POST /login
     │    usuario=admin@...
     │    clave=admin123
     ▼
┌─────────────┐
│LoginServlet │
└────┬────────┘
     │ 3. UsuarioDAO.login()
     ▼
┌─────────────┐
│ UsuarioDAO  │
└────┬────────┘
     │ 4. SELECT * FROM usuarios
     │    WHERE email=? AND password=?
     ▼
┌─────────────┐
│   MySQL     │
└────┬────────┘
     │ 5. ResultSet (Usuario encontrado)
     ▼
┌─────────────┐
│LoginServlet │
│             │
│ session.set │
│ Attribute   │
│ ("usuario") │
└────┬────────┘
     │ 6. redirect /inicio.jsp
     ▼
┌─────────────┐
│ inicio.jsp  │
│ (Dashboard) │
└────┬────────┘
     │ 7. HTML Response
     ▼
┌─────────┐
│ Cliente │
│(Logueado)│
└─────────┘
```

---

## 8. DIAGRAMA DE BASE DE DATOS (ER Simplificado)

```
┌─────────────┐
│  usuarios   │
├─────────────┤
│ PK id       │
│    nombre   │
│    apellido │
│    email    │
│    password │
│    username │
│    rol      │
└──────┬──────┘
       │
       │ 1:N
       │
┌──────▼──────┐      ┌─────────────┐
│   carrito   │      │  productos  │
├─────────────┤      ├─────────────┤
│ PK id       │      │ PK id       │
│ FK id_usuario│◄────┤    nombre   │
│ FK id_producto│────┤    precio   │
│    cantidad │      │    stock    │
│    subtotal │      └─────────────┘
└─────────────┘
       │
       │ 1:N
       │
┌──────▼──────┐
│   pedidos   │
├─────────────┤
│ PK id       │
│ FK id_usuario│
│    fecha    │
│    total    │
│    estado   │
└──────┬──────┘
       │
       │ 1:N
       │
┌──────▼──────────┐
│ detalle_pedido  │
├─────────────────┤
│ PK id           │
│ FK id_pedido    │
│ FK id_producto  │
│    cantidad     │
│    subtotal     │
└─────────────────┘
```

---

## 9. ARQUITECTURA DE SEGURIDAD

```
┌─────────────────────────────────────────────┐
│          CAPA DE PRESENTACIÓN               │
│                                             │
│  ┌─────────────────────────────────────┐  │
│  │  Validación de Sesión (JSP)         │  │
│  │  <c:if test="${empty sessionScope   │  │
│  │              .usuario}">            │  │
│  │      <c:redirect url="login.jsp"/>   │  │
│  │  </c:if>                            │  │
│  └─────────────────────────────────────┘  │
└───────────────────┬─────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│          CAPA DE CONTROL                    │
│                                             │
│  ┌─────────────────────────────────────┐  │
│  │  Validación de Sesión (Servlet)     │  │
│  │  HttpSession session = request.     │  │
│  │      getSession(false);              │  │
│  │  if (session == null || ...) {      │  │
│  │      response.sendRedirect(...);    │  │
│  │  }                                  │  │
│  └─────────────────────────────────────┘  │
│                                             │
│  ┌─────────────────────────────────────┐  │
│  │  Validación de Rol                   │  │
│  │  if (!esAdmin(usuario)) {            │  │
│  │      response.sendRedirect(...);     │  │
│  │  }                                  │  │
│  └─────────────────────────────────────┘  │
└───────────────────┬─────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│          CAPA DE DATOS                       │
│                                             │
│  ┌─────────────────────────────────────┐  │
│  │  PreparedStatement (SQL Injection)  │  │
│  │  ps.setString(1, parametro);         │  │
│  │  ps.setInt(2, id);                  │  │
│  └─────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

---

## 10. MAPA DE NAVEGACIÓN

```
                    ┌─────────┐
                    │   /     │
                    │(index)  │
                    └────┬────┘
                         │
                         ▼
                    ┌─────────┐
                    │ login   │
                    │  .jsp   │
                    └────┬────┘
                         │ POST /login
                         ▼
                    ┌─────────┐
                    │ inicio  │
                    │  .jsp   │
                    └────┬────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
   ┌─────────┐    ┌──────────┐    ┌──────────┐
   │productos│    │ carrito  │    │ pedidos  │
   │  .jsp   │    │  .jsp    │    │  .jsp    │
   └────┬────┘    └────┬─────┘    └──────────┘
        │              │
        │              │ POST /FinalizarCompraServlet
        │              ▼
        │         ┌──────────────┐
        │         │ confirmacion │
        │         │    .jsp      │
        │         └──────────────┘
        │
        │ (Solo Admin)
        ▼
   ┌──────────────┐
   │agregarProducto│
   │    .jsp      │
   └──────┬───────┘
          │
          │ POST /AgregarProductoServlet
          ▼
     ┌─────────┐
     │productos│
     │  .jsp   │
     └─────────┘
```

---

**Última actualización:** Noviembre 2025

