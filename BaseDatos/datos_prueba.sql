-- ==========================================================
-- SCRIPT COMPLETO - OtakuShopWeb2
-- ==========================================================

CREATE DATABASE IF NOT EXISTS otakushop 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE otakushop;

-- Eliminar tablas si existen (para recrear limpio)
DROP TABLE IF EXISTS detalle_compra;
DROP TABLE IF EXISTS detalle_pedido;
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS carrito;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS usuarios;

-- TABLA: usuarios
CREATE TABLE usuarios (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) DEFAULT '',
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE,
    rol VARCHAR(30) DEFAULT 'cliente',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Usuarios de prueba
INSERT INTO usuarios (nombre, apellido, email, password, username, rol) VALUES
('Administrador', 'Sistema', 'admin@otakushop.com', 'admin123', 'admin', 'administrador'),
('Usuario', 'Prueba', 'user1@otakushop.com', 'user123', 'user1', 'cliente'),
('Carlos', 'Extra', 'usuario@otakushop.com', 'usuario123', 'usuario', 'cliente'),
('Maria', 'Lopez', 'usuario2@otakushop.com', 'user456', 'usuario2', 'cliente');

-- TABLA: productos
CREATE TABLE productos (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Productos de prueba
INSERT INTO productos (nombre, precio, stock) VALUES
('Figura Goku Super Saiyan', 120.50, 10),
('Manga Naruto Vol.1', 25.00, 50),
('Película Studio Ghibli Blu-ray', 40.00, 20),
('Funko Pop Luffy', 15.00, 30),
('Figura Sailor Moon', 50.00, 15),
('Manga One Piece Vol.1', 30.00, 40),
('Poster Attack on Titan', 12.00, 100),
('Camiseta Dragon Ball Z', 35.00, 25),
('Llavero Naruto', 8.00, 200),
('Figura Demon Slayer Tanjiro', 85.00, 12);

-- TABLA: carrito
CREATE TABLE carrito (
    id INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: pedidos
CREATE TABLE pedidos (
    id INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(50) DEFAULT 'pendiente',
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: detalle_pedido
CREATE TABLE detalle_pedido (
    id INT NOT NULL AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: compras
CREATE TABLE compras (
    id INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TABLA: detalle_compra
CREATE TABLE detalle_compra (
    id INT NOT NULL AUTO_INCREMENT,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_compra) REFERENCES compras(id) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pedido de ejemplo
INSERT INTO pedidos (id_usuario, total, estado) VALUES (1, 241.00, 'pendiente');
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES (1, 1, 2, 241.00);

-- Verificación
SELECT '✅ BASE DE DATOS CREADA CORRECTAMENTE' AS RESULTADO;

