package com.otakushop.model;

import java.sql.Timestamp;
import java.util.List;

public class Pedido {

    private int id;
    private int idUsuario;           // usuario_id en BD
    private Timestamp fecha;         // fecha del pedido
    private double total;            // total del pedido
    private String estado;           // estado: 'pendiente', 'pagado', etc.
    private List<Carrito> productos; // lista de productos del pedido

    public Pedido() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public Timestamp getFecha() { return fecha; }
    public void setFecha(Timestamp fecha) { this.fecha = fecha; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public List<Carrito> getProductos() { return productos; }
    public void setProductos(List<Carrito> productos) { this.productos = productos; }
}
