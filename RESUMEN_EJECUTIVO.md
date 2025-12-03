# 📋 RESUMEN EJECUTIVO - OtakuShopWeb2

## 🎯 INFORMACIÓN RÁPIDA

| Aspecto | Detalle |
|---------|---------|
| **Nombre del Proyecto** | OtakuShopWeb2 |
| **Tipo de Aplicación** | E-commerce Web |
| **Lenguaje Principal** | Java 24 |
| **Plataforma** | Java EE 8.0 |
| **Servidor** | Apache Tomcat 9.0.108 |
| **Base de Datos** | MySQL 8.0.43 |
| **Arquitectura** | MVC (Modelo-Vista-Controlador) |
| **IDE** | Apache NetBeans 20+ |

---

## 🛠️ STACK TECNOLÓGICO

### Backend
- **Java 24** - Lenguaje de programación
- **Java Servlets 3.1** - Controladores web
- **JSP 2.3** - Vistas dinámicas
- **JSTL 1.2** - Tag Library
- **JDBC** - Conexión a base de datos

### Frontend
- **HTML5** - Estructura
- **CSS3** - Estilos responsive
- **JavaScript ES6+** - Interactividad
- **JSTL/EL** - Lógica en vistas

### Base de Datos
- **MySQL 8.0** - SGBD
- **InnoDB** - Motor de almacenamiento
- **UTF-8** - Codificación

### Servidor
- **Apache Tomcat 9.0.108** - Contenedor de servlets

### Librerías
- **Gson 2.13.1** - JSON para APIs REST
- **JSTL 1.2** - Tags estándar
- **MySQL Connector 5.1.49** - Driver JDBC

---

## 📁 ESTRUCTURA DEL PROYECTO

```
OtakuShopWeb2/
├── src/java/com/otakushop/
│   ├── api/          → Servlets REST API
│   ├── dao/          → Data Access Objects
│   ├── model/         → Entidades Java
│   ├── servlets/     → Controladores web
│   └── util/         → Utilidades (Conexion)
├── web/
│   ├── *.jsp         → Vistas
│   ├── css/          → Estilos
│   └── WEB-INF/
│       ├── lib/      → Librerías JAR
│       └── web.xml   → Configuración
└── BaseDatos/
    └── datos_prueba.sql → Script SQL
```

---

## 🗄️ BASE DE DATOS

**Nombre:** `otakushop`  
**Tablas:** 7
- usuarios
- productos
- carrito
- pedidos
- detalle_pedido
- compras
- detalle_compra

**Conexión:**
- Host: localhost:3306
- Usuario: root
- Driver: com.mysql.jdbc.Driver

---

## 🔌 APIs REST

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/api/productos` | GET, POST | Gestión de productos |
| `/api/usuarios` | GET, POST | Gestión de usuarios |
| `/api/carrito` | GET, POST | Gestión de carrito |
| `/api/pedidos` | POST | Creación de pedidos |

**Formato:** JSON  
**Autenticación:** No requerida (mejorable)

---

## 🔐 SEGURIDAD

**Roles:**
- `administrador` / `admin` - Acceso completo
- `cliente` - Acceso limitado

**Validaciones:**
- Sesión requerida en todas las páginas protegidas
- Validación de rol en servlets de administración
- Control de acceso en JSPs con JSTL

---

## 📄 ARCHIVOS CLAVE

| Archivo | Propósito |
|---------|-----------|
| `web.xml` | Configuración de servlets y páginas |
| `Conexion.java` | Gestión de conexión a BD |
| `ProductoServlet.java` | Controlador centralizado de productos |
| `navbar.jsp` | Barra de navegación global |
| `login.jsp` | Página de inicio de sesión |

---

## 🚀 DESPLIEGUE

**Método 1 - NetBeans:**
1. Clean and Build
2. Run

**Método 2 - Manual:**
1. Ejecutar script SQL
2. Copiar `build/web` a `webapps/OtakuShopWeb2`
3. Iniciar Tomcat

**URL:** `http://localhost:8080/OtakuShopWeb2/`

---

## 📊 ESTADÍSTICAS DEL PROYECTO

- **Servlets:** 17
- **DAOs:** 4
- **Modelos:** 4
- **JSPs:** 15+
- **APIs REST:** 4
- **Tablas BD:** 7
- **Líneas de código:** ~5,000+

---

## ✅ FUNCIONALIDADES

- ✅ Login/Logout con roles
- ✅ CRUD de productos (admin)
- ✅ Carrito de compras
- ✅ Procesamiento de pedidos
- ✅ Historial de compras
- ✅ APIs REST
- ✅ Chatbot integrado
- ✅ Diseño responsive

---

**Para más detalles, consulta:** `MANUAL_TECNICO_COMPLETO.md`

