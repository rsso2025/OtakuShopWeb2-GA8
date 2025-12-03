package com.otakushop.model;

public class Producto {

    private int id;
    private String nombre;
    private double precio;
    private int stock;

    // 👉 Atributo necesario para manejar productos en el carrito
    private int cantidad;

    public Producto() {}

    // ======================
    // Getters y Setters
    // ======================

    public int getId() { 
        return id; 
    }

    public void setId(int id) { 
        this.id = id; 
    }

    public String getNombre() { 
        return nombre; 
    }

    public void setNombre(String nombre) { 
        this.nombre = nombre; 
    }

    public double getPrecio() { 
        return precio; 
    }

    public void setPrecio(double precio) { 
        this.precio = precio; 
    }

    public int getStock() { 
        return stock; 
    }

    public void setStock(int stock) { 
        this.stock = stock; 
    }

    // ======================
    // ✔ Cantidad (nuevo)
    // ======================
    public int getCantidad() { 
        return cantidad; 
    }

    public void setCantidad(int cantidad) { 
        this.cantidad = cantidad; 
    }
}
