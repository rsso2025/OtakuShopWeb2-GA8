package com.otakushop.model;

public class Usuario {
    private int id;
    private String nombre;
    private String apellido; // Nuevo campo
    private String email;
    private String password;
    private String username; // Nuevo campo
    private String rol;      // Nuevo campo (ej: "administrador", "cliente")

    public Usuario() {}

    // Constructor actualizado
    public Usuario(int id, String nombre, String apellido, String email, String password, String username, String rol) {
        this.id = id;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.password = password;
        this.username = username;
        this.rol = rol;
    }
    
    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    // Métodos para Apellido
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    // Métodos para Username
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    // Métodos para Rol
    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
}