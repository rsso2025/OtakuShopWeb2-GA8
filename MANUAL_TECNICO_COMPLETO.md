# 📘 MANUAL TÉCNICO COMPLETO - OtakuShopWeb2

**Versión:** 2.0  
**Fecha:** Noviembre 2025  
**Proyecto:** Sistema de E-commerce para productos Otaku  
**Evidencia SENA:** GA8/GA9  
**Estado:** ✅ Producción

---

## 📑 ÍNDICE

1. [Información General del Proyecto](#1-información-general-del-proyecto)
2. [Tecnologías y Lenguajes](#2-tecnologías-y-lenguajes)
3. [Ambiente de Desarrollo](#3-ambiente-de-desarrollo)
4. [Arquitectura del Sistema](#4-arquitectura-del-sistema)
5. [Estructura del Proyecto](#5-estructura-del-proyecto)
6. [Base de Datos](#6-base-de-datos)
7. [APIs REST](#7-apis-rest)
8. [Servlets y Controladores](#8-servlets-y-controladores)
9. [Vistas (JSPs)](#9-vistas-jsps)
10. [Configuración](#10-configuración)
11. [Seguridad y Roles](#11-seguridad-y-roles)
12. [Despliegue](#12-despliegue)
13. [Troubleshooting](#13-troubleshooting)

---

## 1. INFORMACIÓN GENERAL DEL PROYECTO

### 1.1 Descripción
**OtakuShopWeb2** es una aplicación web de comercio electrónico desarrollada en Java EE para la venta de productos relacionados con la cultura otaku (figuras, mangas, funkos, etc.).

### 1.2 Objetivos
- Gestionar catálogo de productos
- Permitir compras en línea con carrito de compras
- Administrar usuarios con roles (administrador/cliente)
- Procesar pedidos y compras
- Proporcionar APIs REST para integración

### 1.3 Características Principales
- ✅ Sistema de autenticación con roles
- ✅ Gestión CRUD de productos
- ✅ Carrito de compras funcional
- ✅ Procesamiento de pedidos
- ✅ APIs REST para productos, usuarios, carrito y pedidos
- ✅ Interfaz responsive con diseño moderno
- ✅ Chatbot integrado

---

## 2. TECNOLOGÍAS Y LENGUAJES

### 2.1 Backend

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Java** | 24 (JDK 24) | Lenguaje principal |
| **Java EE / Jakarta EE** | 8.0 | Plataforma empresarial |
| **Java Servlets** | 3.1 | Controladores web |
| **JSP (JavaServer Pages)** | 2.3 | Vistas dinámicas |
| **JSTL (JSP Standard Tag Library)** | 1.2 | Etiquetas estándar para JSP |
| **EL (Expression Language)** | 3.0 | Expresiones en JSP |

### 2.2 Frontend

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **HTML5** | 5.0 | Estructura |
| **CSS3** | 3.0 | Estilos y diseño responsive |
| **JavaScript (Vanilla)** | ES6+ | Interactividad y chatbot |
| **Bootstrap** | - | (Opcional, no incluido) |

### 2.3 Base de Datos

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **MySQL** | 8.0.43+ | Sistema gestor de base de datos |
| **JDBC** | 5.1.49 | Conector Java-MySQL |
| **InnoDB** | - | Motor de almacenamiento |

### 2.4 Servidor de Aplicaciones

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Apache Tomcat** | 9.0.108 | Servidor web y contenedor de servlets |

### 2.5 Librerías y Dependencias

| Librería | Versión | Ubicación | Propósito |
|----------|---------|-----------|-----------|
| **gson** | 2.13.1 | `web/WEB-INF/lib/` | Serialización JSON para APIs |
| **jstl** | 1.2 | `web/WEB-INF/lib/` | Tag Library para JSP |
| **mysql-connector-java** | 5.1.49 | `web/WEB-INF/lib/` | Driver JDBC para MySQL |
| **javaee-web-api** | 8.0 | `web/WEB-INF/lib/` | API Java EE (Servlets, JSP) |

### 2.6 Herramientas de Desarrollo

| Herramienta | Versión | Propósito |
|-------------|---------|-----------|
| **Apache NetBeans** | 20+ | IDE principal |
| **Apache Ant** | - | Sistema de build |
| **MySQL Workbench** | 8.0+ | Administración de BD |
| **Git** | - | Control de versiones (opcional) |

---

## 3. AMBIENTE DE DESARROLLO

### 3.1 Requisitos del Sistema

#### Hardware Mínimo:
- **Procesador:** Intel Core i3 o equivalente
- **RAM:** 4 GB (8 GB recomendado)
- **Disco:** 2 GB libres
- **Sistema Operativo:** Windows 10/11, Linux, macOS

#### Software Requerido:
1. **JDK (Java Development Kit)**
   - Versión: JDK 24
   - Descarga: Oracle JDK o OpenJDK
   - Variable de entorno: `JAVA_HOME`

2. **Apache Tomcat**
   - Versión: 9.0.108
   - Ruta de instalación: `C:\apache-tomcat-9.0.108\`
   - Puerto: 8080 (por defecto)

3. **MySQL Server**
   - Versión: 8.0.43 o superior
   - Puerto: 3306 (por defecto)
   - Usuario: `root`
   - Contraseña: `16321548xD` (configurable)

4. **Apache NetBeans**
   - Versión: 20 o superior
   - Plugin: Java EE Bundle

### 3.2 Configuración del Entorno

#### Variables de Entorno:
```bash
JAVA_HOME=C:\Program Files\Java\jdk-24
CATALINA_HOME=C:\apache-tomcat-9.0.108
PATH=%JAVA_HOME%\bin;%CATALINA_HOME%\bin;%PATH%
```

#### Configuración de NetBeans:
- **Java Platform:** JDK 24
- **Server:** Apache Tomcat 9.0.108
- **Encoding:** UTF-8
- **Java EE Version:** 8.0

---

## 4. ARQUITECTURA DEL SISTEMA

### 4.1 Patrón Arquitectónico: **MVC (Modelo-Vista-Controlador)**

```
┌─────────────────────────────────────────────────┐
│                    CLIENTE                      │
│              (Navegador Web)                    │
└──────────────────┬──────────────────────────────┘
                   │ HTTP Request
                   ▼
┌─────────────────────────────────────────────────┐
│                    VISTA                        │
│              (JSP + JSTL/EL)                    │
│  - login.jsp, productos.jsp, carrito.jsp, etc.  │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│                 CONTROLADOR                     │
│              (Servlets)                         │
│  - LoginServlet, ProductoServlet, etc.           │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│                   MODELO                        │
│         (DAOs + Modelos Java)                  │
│  - UsuarioDAO, ProductoDAO, CarritoDAO, etc.    │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              BASE DE DATOS                      │
│              MySQL (otakushop)                  │
└─────────────────────────────────────────────────┘
```

### 4.2 Flujo de Datos

1. **Cliente** → Solicita recurso (URL)
2. **Tomcat** → Recibe petición HTTP
3. **web.xml** → Mapea URL a Servlet
4. **Servlet** → Procesa lógica de negocio
5. **DAO** → Accede a base de datos
6. **Modelo** → Representa datos
7. **JSP** → Renderiza vista HTML
8. **Cliente** → Recibe respuesta HTML

### 4.3 Capas de la Aplicación

#### Capa de Presentación (Vista)
- **Archivos:** JSPs en `web/`
- **Tecnología:** JSP + JSTL + EL
- **Responsabilidad:** Renderizar HTML, mostrar datos

#### Capa de Control (Controlador)
- **Archivos:** Servlets en `src/java/com/otakushop/servlets/`
- **Tecnología:** Java Servlets
- **Responsabilidad:** Procesar peticiones, validar datos, redirigir

#### Capa de Negocio (Modelo)
- **Archivos:** DAOs en `src/java/com/otakushop/dao/`
- **Tecnología:** Java + JDBC
- **Responsabilidad:** Lógica de acceso a datos, operaciones CRUD

#### Capa de Datos
- **Archivos:** Base de datos MySQL
- **Tecnología:** MySQL 8.0
- **Responsabilidad:** Almacenamiento persistente

---

## 5. ESTRUCTURA DEL PROYECTO

### 5.1 Estructura de Directorios

```
OtakuShopWeb2/
│
├── 📁 BaseDatos/                          # Scripts SQL
│   ├── datos_prueba.sql                  # Script completo de BD
│   └── otakushop_full.sql                # Backup completo
│
├── 📁 build/                              # Archivos compilados
│   └── web/                               # Webapp compilada
│       ├── WEB-INF/
│       │   ├── classes/                   # .class compilados
│       │   ├── lib/                       # JARs
│       │   └── web.xml
│       └── *.jsp                          # JSPs copiados
│
├── 📁 dist/                               # Distribución
│   └── OtakuShopWeb2.war                 # Archivo WAR
│
├── 📁 libs/                               # Librerías externas
│   ├── gson-2.13.1.jar
│   └── jstl-1.2.jar
│
├── 📁 nbproject/                          # Configuración NetBeans
│   ├── project.properties
│   └── build-impl.xml
│
├── 📁 src/                                # Código fuente
│   └── java/
│       └── com/
│           └── otakushop/
│               ├── 📁 api/                # Servlets REST API
│               │   ├── CarritoApiServlet.java
│               │   ├── PedidosApiServlet.java
│               │   ├── ProductoApiServlet.java
│               │   └── UsuariosApiServlet.java
│               │
│               ├── 📁 dao/                # Data Access Objects
│               │   ├── CarritoDAO.java
│               │   ├── PedidoDAO.java
│               │   ├── ProductoDAO.java
│               │   └── UsuarioDAO.java
│               │
│               ├── 📁 model/              # Modelos/Entidades
│               │   ├── Carrito.java
│               │   ├── Pedido.java
│               │   ├── Producto.java
│               │   └── Usuario.java
│               │
│               ├── 📁 servlets/           # Servlets de control
│               │   ├── ActualizarCarritoServlet.java
│               │   ├── AgregarCarritoServlet.java
│               │   ├── AgregarProductoServlet.java
│               │   ├── CarritoServlet.java
│               │   ├── CerrarSesionServlet.java
│               │   ├── EditarProductoServlet.java
│               │   ├── EliminarCarritoServlet.java
│               │   ├── EliminarProductoServlet.java
│               │   ├── FinalizarCompraServlet.java
│               │   ├── LoginServlet.java
│               │   ├── LogoutServlet.java
│               │   ├── PedidoServlet.java
│               │   └── ProductoServlet.java
│               │
│               └── 📁 util/              # Utilidades
│                   ├── Conexion.java
│                   └── Main.java
│
├── 📁 web/                                # Recursos web
│   ├── 📁 css/                           # Estilos
│   │   └── styles.css
│   │
│   ├── 📁 META-INF/                      # Metadatos
│   │   └── context.xml
│   │
│   ├── 📁 WEB-INF/                       # Configuración web
│   │   ├── lib/                          # Librerías JAR
│   │   │   ├── gson-2.13.1.jar
│   │   │   ├── javaee-web-api-8.0.jar
│   │   │   ├── jstl-1.2.jar
│   │   │   └── mysql-connector-java-5.1.49-bin.jar
│   │   └── web.xml                       # Descriptor de despliegue
│   │
│   └── *.jsp                             # Páginas JSP
│       ├── agregarProducto.jsp
│       ├── bienvenida.jsp
│       ├── carrito.jsp
│       ├── confirmacion.jsp
│       ├── editarProducto.jsp
│       ├── error.jsp
│       ├── home.jsp
│       ├── index.jsp
│       ├── inicio.jsp
│       ├── listarProductos.jsp
│       ├── login.jsp
│       ├── logout.jsp
│       ├── navbar.jsp
│       ├── pedidos.jsp
│       └── productos.jsp
│
├── build.xml                              # Script Ant
├── MANUAL_TECNICO_COMPLETO.md            # Este documento
└── AUDITORIA_REPORTE.md                  # Reporte de auditoría
```

### 5.2 Paquetes Java

```
com.otakushop
├── api          → Servlets REST API
├── dao          → Data Access Objects
├── model        → Entidades/Modelos
├── servlets     → Controladores web
└── util         → Utilidades (Conexión BD)
```

---

## 6. BASE DE DATOS

### 6.1 Información de Conexión

| Parámetro | Valor |
|-----------|-------|
| **SGBD** | MySQL 8.0.43+ |
| **Host** | localhost |
| **Puerto** | 3306 |
| **Base de Datos** | `otakushop` |
| **Usuario** | `root` |
| **Contraseña** | `16321548xD` |
| **Driver JDBC** | `com.mysql.jdbc.Driver` |
| **URL JDBC** | `jdbc:mysql://localhost:3306/otakushop?useSSL=false&useUnicode=true&characterEncoding=UTF-8` |
| **Charset** | utf8mb4 |
| **Collation** | utf8mb4_unicode_ci |

### 6.2 Esquema de Base de Datos

#### Tabla: `usuarios`
```sql
CREATE TABLE usuarios (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) DEFAULT '',
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE,
    rol VARCHAR(30) DEFAULT 'cliente',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Campos:**
- `id`: Identificador único (AUTO_INCREMENT)
- `nombre`: Nombre del usuario
- `apellido`: Apellido del usuario
- `email`: Email único
- `password`: Contraseña (sin hash por ahora)
- `username`: Nombre de usuario único
- `rol`: Rol del usuario ('admin' o 'cliente')

#### Tabla: `productos`
```sql
CREATE TABLE productos (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Campos:**
- `id`: Identificador único
- `nombre`: Nombre del producto
- `precio`: Precio (DECIMAL 10,2)
- `stock`: Cantidad disponible

#### Tabla: `carrito`
```sql
CREATE TABLE carrito (
    id INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Campos:**
- `id`: Identificador único
- `id_usuario`: FK a usuarios
- `id_producto`: FK a productos
- `cantidad`: Cantidad del producto
- `subtotal`: Precio × cantidad

#### Tabla: `pedidos`
```sql
CREATE TABLE pedidos (
    id INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(50) DEFAULT 'pendiente',
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Campos:**
- `id`: Identificador único
- `id_usuario`: FK a usuarios
- `fecha`: Fecha del pedido (TIMESTAMP)
- `total`: Monto total
- `estado`: Estado ('pendiente', 'pagado', 'enviado')

#### Tabla: `detalle_pedido`
```sql
CREATE TABLE detalle_pedido (
    id INT NOT NULL AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### Tabla: `compras`
```sql
CREATE TABLE compras (
    id INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### Tabla: `detalle_compra`
```sql
CREATE TABLE detalle_compra (
    id INT NOT NULL AUTO_INCREMENT,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_compra) REFERENCES compras(id) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 6.3 Relaciones (Diagrama ER)

```
usuarios (1) ────< (N) carrito
usuarios (1) ────< (N) pedidos
usuarios (1) ────< (N) compras

productos (1) ────< (N) carrito
productos (1) ────< (N) detalle_pedido
productos (1) ────< (N) detalle_compra

pedidos (1) ────< (N) detalle_pedido
compras (1) ────< (N) detalle_compra
```

### 6.4 Datos de Prueba

#### Usuarios:
| ID | Nombre | Email | Password | Username | Rol |
|----|--------|-------|----------|----------|-----|
| 1 | Administrador | admin@otakushop.com | admin123 | admin | administrador |
| 2 | Usuario | user1@otakushop.com | user123 | user1 | cliente |

#### Productos (10 productos de ejemplo):
- Figura Goku Super Saiyan ($120.50)
- Manga Naruto Vol.1 ($25.00)
- Película Studio Ghibli Blu-ray ($40.00)
- Funko Pop Luffy ($15.00)
- Y 6 más...

---

## 7. APIs REST

### 7.1 Endpoints Disponibles

#### 7.1.1 API de Productos
**Base URL:** `/OtakuShopWeb2/api/productos`

| Método | Endpoint | Descripción | Autenticación |
|--------|----------|-------------|---------------|
| GET | `/api/productos` | Lista todos los productos | No |
| POST | `/api/productos` | Crea un nuevo producto | No |

**Ejemplo GET:**
```bash
GET http://localhost:8080/OtakuShopWeb2/api/productos
```

**Respuesta:**
```json
[
  {
    "id": 1,
    "nombre": "Figura Goku Super Saiyan",
    "precio": 120.50,
    "stock": 10
  }
]
```

**Ejemplo POST:**
```bash
POST http://localhost:8080/OtakuShopWeb2/api/productos
Content-Type: application/json

{
  "nombre": "Nuevo Producto",
  "precio": 50.00,
  "stock": 20
}
```

#### 7.1.2 API de Usuarios
**Base URL:** `/OtakuShopWeb2/api/usuarios`

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/usuarios` | Lista todos los usuarios |
| POST | `/api/usuarios` | Registra nuevo usuario |
| POST | `/api/usuarios/login` | Login de usuario |

**Ejemplo Login:**
```bash
POST http://localhost:8080/OtakuShopWeb2/api/usuarios/login
Content-Type: application/json

{
  "email": "admin@otakushop.com",
  "password": "admin123"
}
```

#### 7.1.3 API de Carrito
**Base URL:** `/OtakuShopWeb2/api/carrito`

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/carrito` | Lista todos los items del carrito |
| POST | `/api/carrito` | Agrega item al carrito |

#### 7.1.4 API de Pedidos
**Base URL:** `/OtakuShopWeb2/api/pedidos`

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/pedidos` | Crea un nuevo pedido |

**Ejemplo:**
```json
{
  "idUsuario": 1,
  "productos": [
    {
      "idProducto": 1,
      "cantidad": 2,
      "subtotal": 241.00
    }
  ],
  "total": 241.00,
  "estado": "pendiente"
}
```

### 7.2 Formato de Respuesta

**Éxito:**
```json
{
  "status": "ok",
  "mensaje": "Operación exitosa",
  "data": {...}
}
```

**Error:**
```json
{
  "status": "error",
  "mensaje": "Descripción del error"
}
```

### 7.3 Códigos HTTP

| Código | Significado |
|--------|-------------|
| 200 | OK - Operación exitosa |
| 201 | Created - Recurso creado |
| 400 | Bad Request - Datos inválidos |
| 401 | Unauthorized - No autenticado |
| 404 | Not Found - Recurso no encontrado |
| 500 | Internal Server Error - Error del servidor |

---

## 8. SERVLETS Y CONTROLADORES

### 8.1 Servlets de Autenticación

#### LoginServlet
- **Ruta:** `/login`
- **Método:** POST
- **Parámetros:** `usuario` (email/username), `clave` (password)
- **Funcionalidad:** Valida credenciales, crea sesión, redirige a inicio.jsp

#### LogoutServlet
- **Ruta:** `/logout`
- **Método:** GET/POST
- **Funcionalidad:** Invalida sesión, redirige a login.jsp

#### CerrarSesionServlet
- **Ruta:** `/cerrar-sesion`
- **Método:** GET/POST
- **Funcionalidad:** Alternativa para cerrar sesión

### 8.2 Servlets de Productos

#### ProductoServlet (Centralizado)
- **Ruta:** `/productos`
- **Métodos:** GET, POST
- **Parámetros:** `accion` (listar, editar, eliminar, nuevo)
- **Funcionalidad:** Gestiona todas las operaciones de productos

**Acciones:**
- `GET /productos` → Lista productos
- `GET /productos?accion=editar&id=X` → Muestra formulario edición
- `GET /productos?accion=eliminar&id=X` → Elimina producto
- `GET /productos?accion=nuevo` → Muestra formulario agregar
- `POST /productos?accion=agregar` → Crea producto
- `POST /productos?accion=actualizar` → Actualiza producto

#### AgregarProductoServlet
- **Ruta:** `/AgregarProductoServlet`
- **Método:** POST
- **Parámetros:** `nombre`, `precio`, `stock`
- **Validación:** Solo administradores

#### EditarProductoServlet
- **Ruta:** `/EditarProductoServlet`
- **Métodos:** GET (formulario), POST (actualizar)
- **Parámetros:** `id`, `nombre`, `precio`, `stock`
- **Validación:** Solo administradores

#### EliminarProductoServlet
- **Ruta:** `/EliminarProductoServlet`
- **Métodos:** GET/POST
- **Parámetros:** `id`
- **Validación:** Solo administradores

### 8.3 Servlets de Carrito

#### CarritoServlet
- **Ruta:** `/CarritoServlet`
- **Método:** POST
- **Funcionalidad:** Agrega productos al carrito

#### AgregarCarritoServlet
- **Ruta:** `/AgregarCarritoServlet` o `/agregar-carrito`
- **Método:** POST
- **Parámetros:** `idProducto`, `cantidad`
- **Funcionalidad:** Agrega/actualiza item en carrito

#### ActualizarCarritoServlet
- **Ruta:** `/ActualizarCarritoServlet`
- **Método:** POST
- **Parámetros:** `idProducto`, `cantidad`
- **Funcionalidad:** Actualiza cantidad de un item

#### EliminarCarritoServlet
- **Ruta:** `/EliminarCarritoServlet`
- **Método:** GET
- **Parámetros:** `idProducto`
- **Funcionalidad:** Elimina item del carrito

### 8.4 Servlets de Pedidos/Compras

#### PedidoServlet
- **Ruta:** `/PedidoServlet`
- **Método:** POST
- **Parámetros:** `total`
- **Respuesta:** JSON con ID del pedido creado

#### FinalizarCompraServlet
- **Ruta:** `/FinalizarCompraServlet` o `/finalizar-compra`
- **Método:** POST
- **Funcionalidad:** 
  - Crea pedido
  - Inserta detalles
  - Actualiza stock
  - Vacía carrito
  - Usa transacciones SQL

---

## 9. VISTAS (JSPs)

### 9.1 Páginas Principales

#### login.jsp
- **Propósito:** Página de inicio de sesión
- **Formulario:** POST a `/login`
- **Campos:** `usuario` (email/username), `clave` (password)
- **Tecnología:** JSP + JSTL

#### inicio.jsp
- **Propósito:** Dashboard principal después del login
- **Incluye:** navbar.jsp
- **Características:** Chatbot integrado, menú de navegación
- **Validación:** Redirige a login si no hay sesión

#### productos.jsp
- **Propósito:** Lista de productos disponibles
- **Funcionalidad:** 
  - Muestra catálogo
  - Botones según rol (admin: editar/eliminar, cliente: agregar al carrito)
  - Alertas de stock bajo (solo admin)
- **Tecnología:** JSP + JSTL + EL

#### listarProductos.jsp
- **Propósito:** Vista alternativa de productos (desde Servlet)
- **Atributo:** `${productos}` (List<Producto>)
- **Modal:** Formulario para agregar producto (solo admin)

#### carrito.jsp
- **Propósito:** Muestra items del carrito del usuario
- **Funcionalidad:** 
  - Lista productos en carrito
  - Actualizar cantidades
  - Eliminar items
  - Calcular total
  - Botón "Finalizar Compra"

#### pedidos.jsp
- **Propósito:** Historial de pedidos del usuario
- **Funcionalidad:** Lista pedidos con estado y total

#### confirmacion.jsp
- **Propósito:** Confirmación de compra exitosa
- **Muestra:** Mensaje de éxito, detalles del pedido

#### error.jsp
- **Propósito:** Página de error personalizada
- **Maneja:** Errores 404, 500, excepciones

### 9.2 Páginas de Administración

#### agregarProducto.jsp
- **Acceso:** Solo administradores
- **Formulario:** POST a `/AgregarProductoServlet`
- **Campos:** nombre, precio, stock

#### editarProducto.jsp
- **Acceso:** Solo administradores
- **Formulario:** POST a `/EditarProductoServlet`
- **Atributo:** `${producto}` (Producto)

### 9.3 Componentes Reutilizables

#### navbar.jsp
- **Propósito:** Barra de navegación global
- **Tecnología:** 100% JSTL/EL (sin scriptlets)
- **Características:** 
  - Muestra nombre de usuario
  - Badge de rol (Admin/Cliente)
  - Enlaces según rol
  - Botón de logout

### 9.4 Tecnologías en JSPs

**JSTL Core:**
```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${condicion}">...</c:if>
<c:forEach var="item" items="${lista}">...</c:forEach>
<c:choose>...</c:choose>
```

**JSTL Format:**
```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:formatNumber value="${precio}" pattern="#,##0.00"/>
```

**Expression Language (EL):**
```jsp
${sessionScope.usuario.nombre}
${param.error}
${productos}
```

---

## 10. CONFIGURACIÓN

### 10.1 web.xml (Descriptor de Despliegue)

**Ubicación:** `web/WEB-INF/web.xml`

**Configuraciones Clave:**

#### Página de Inicio:
```xml
<welcome-file-list>
    <welcome-file>login.jsp</welcome-file>
</welcome-file-list>
```

#### Timeout de Sesión:
```xml
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```

#### Mapeo de Servlets:
- Todos los servlets están mapeados en `web.xml`
- No se usa `@WebServlet` (excepto en APIs REST)

#### Páginas de Error:
```xml
<error-page>
    <error-code>404</error-code>
    <location>/login.jsp</location>
</error-page>
<error-page>
    <error-code>500</error-code>
    <location>/error.jsp</location>
</error-page>
```

### 10.2 context.xml

**Ubicación:** `web/META-INF/context.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context path="/OtakuShopWeb2"/>
```

**Propósito:** Define el contexto de la aplicación en Tomcat

### 10.3 Conexion.java

**Ubicación:** `src/java/com/otakushop/util/Conexion.java`

**Configuración:**
```java
private static final String DRIVER = "com.mysql.jdbc.Driver";
private static final String URL = "jdbc:mysql://localhost:3306/otakushop?useSSL=false&useUnicode=true&characterEncoding=UTF-8";
private static final String USER = "root";
private static final String PASSWORD = "16321548xD";
```

**Método Principal:**
```java
public static Connection getConnection() throws SQLException
```

**Uso:**
```java
try (Connection con = Conexion.getConnection()) {
    // Operaciones con BD
}
```

### 10.4 build.xml (Apache Ant)

**Propósito:** Script de compilación y empaquetado

**Targets Principales:**
- `clean` - Limpia archivos compilados
- `compile` - Compila código Java
- `dist` - Genera archivo WAR

---

## 11. SEGURIDAD Y ROLES

### 11.1 Sistema de Roles

**Roles Disponibles:**
- `administrador` o `admin` - Acceso completo
- `cliente` - Acceso limitado

### 11.2 Validación de Roles

**En Servlets:**
```java
private boolean esAdmin(Usuario usuario) {
    if (usuario == null || usuario.getRol() == null) {
        return false;
    }
    String rol = usuario.getRol().toLowerCase();
    return rol.equals("admin") || rol.equals("administrador");
}
```

**En JSPs:**
```jsp
<c:set var="esAdmin" value="${sessionScope.usuario.rol == 'admin' || sessionScope.usuario.rol == 'administrador'}"/>

<c:if test="${esAdmin}">
    <!-- Contenido solo para admin -->
</c:if>
```

### 11.3 Permisos por Rol

| Funcionalidad | Admin | Cliente |
|--------------|-------|---------|
| Ver productos | ✅ | ✅ |
| Agregar al carrito | ✅ | ✅ |
| Ver carrito | ✅ | ✅ |
| Realizar compra | ✅ | ✅ |
| Ver pedidos | ✅ | ✅ |
| **Agregar productos** | ✅ | ❌ |
| **Editar productos** | ✅ | ❌ |
| **Eliminar productos** | ✅ | ❌ |
| **Ver alertas de stock** | ✅ | ❌ |

### 11.3.1 Validación de Sesión

**Patrón en Servlets:**
```java
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("usuario") == null) {
    response.sendRedirect("login.jsp");
    return;
}
```

**Patrón en JSPs:**
```jsp
<c:if test="${empty sessionScope.usuario}">
    <c:redirect url="login.jsp"/>
</c:if>
```

### 11.4 Gestión de Sesiones

**Almacenamiento:**
```java
session.setAttribute("usuario", usuario);
session.setAttribute("rol", usuario.getRol());
```

**Recuperación:**
```java
Usuario usuario = (Usuario) session.getAttribute("usuario");
```

**Invalidación:**
```java
session.invalidate();
```

---

## 12. DESPLIEGUE

### 12.1 Preparación

#### Paso 1: Base de Datos
```sql
-- Ejecutar script
mysql -u root -p < BaseDatos/datos_prueba.sql
```

#### Paso 2: Verificar Conexión
- Editar `Conexion.java` si es necesario
- Verificar credenciales de MySQL

#### Paso 3: Compilar
```bash
# En NetBeans
Click derecho → Clean and Build
```

### 12.2 Despliegue en NetBeans

1. **Configurar Servidor:**
   - Services → Servers → Apache Tomcat
   - Configurar ruta: `C:\apache-tomcat-9.0.108`

2. **Ejecutar:**
   - Click derecho en proyecto → Run
   - NetBeans despliega automáticamente

3. **Acceder:**
   - URL: `http://localhost:8080/OtakuShopWeb2/`

### 12.3 Despliegue Manual

#### Opción A: Copiar a webapps
```bash
# Copiar carpeta build/web a webapps
cp -r build/web C:\apache-tomcat-9.0.108\webapps\OtakuShopWeb2
```

#### Opción B: Archivo WAR
```bash
# Generar WAR
ant dist

# Copiar WAR a webapps
cp dist/OtakuShopWeb2.war C:\apache-tomcat-9.0.108\webapps\
```

### 12.4 Verificación Post-Despliegue

1. ✅ Tomcat inicia sin errores
2. ✅ Aplicación aparece en Manager
3. ✅ Login funciona
4. ✅ Productos se listan
5. ✅ Carrito funciona
6. ✅ APIs responden

---

## 13. TROUBLESHOOTING

### 13.1 Errores Comunes

#### Error: "Driver JDBC no encontrado"
**Causa:** JAR de MySQL no está en `WEB-INF/lib/`  
**Solución:** Copiar `mysql-connector-java-5.1.49-bin.jar` a `web/WEB-INF/lib/`

#### Error: "JSTL no puede resolverse"
**Causa:** Falta `jstl-1.2.jar`  
**Solución:** Descargar y agregar a `web/WEB-INF/lib/`

#### Error: "404 - login.jsp no encontrado"
**Causa:** Archivo no copiado a `build/web/`  
**Solución:** Clean and Build en NetBeans

#### Error: "SQLException: Access denied"
**Causa:** Credenciales incorrectas en `Conexion.java`  
**Solución:** Verificar usuario y contraseña de MySQL

#### Error: "Duplicate local variable"
**Causa:** Scriptlets Java duplicados en JSPs  
**Solución:** Usar JSTL/EL en lugar de scriptlets

### 13.2 Logs y Depuración

**Logs de Tomcat:**
- Ubicación: `C:\apache-tomcat-9.0.108\logs\`
- Archivo: `catalina.out` o `localhost.YYYY-MM-DD.log`

**Logs de Aplicación:**
- `System.out.println()` → Aparece en logs de Tomcat
- `System.err.println()` → Errores en logs

**Depuración en NetBeans:**
- Click derecho → Debug
- Puntos de quiebre (breakpoints) en código Java

### 13.3 Optimizaciones Recomendadas

1. **Connection Pooling:** Implementar pool de conexiones (HikariCP)
2. **BCrypt:** Hash de contraseñas con BCrypt
3. **Filtros:** Crear Filter para validación automática de sesión
4. **Caché:** Implementar caché para productos frecuentes
5. **Validación:** Validación de formularios en cliente (JavaScript)

---

## 14. CREDENCIALES Y DATOS DE PRUEBA

### 14.1 Usuarios de Prueba

| Email | Password | Username | Rol |
|-------|----------|----------|-----|
| admin@otakushop.com | admin123 | admin | administrador |
| user1@otakushop.com | user123 | user1 | cliente |
| usuario@otakushop.com | usuario123 | usuario | cliente |
| usuario2@otakushop.com | user456 | usuario2 | cliente |

### 14.2 Productos de Prueba

10 productos pre-cargados con precios y stock variados.

---

## 15. CONTACTO Y SOPORTE

**Proyecto:** OtakuShopWeb2  
**Evidencia SENA:** GA8/GA9  
**Versión:** 2.0  
**Última Actualización:** Noviembre 2025

---

**FIN DEL MANUAL TÉCNICO**

