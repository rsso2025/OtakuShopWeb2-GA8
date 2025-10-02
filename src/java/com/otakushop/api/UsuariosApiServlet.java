package com.otakushop.api;

import com.otakushop.model.Usuario;  // CORREGIDO
import com.otakushop.util.Conexion;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/usuarios/*")
public class UsuariosApiServlet extends HttpServlet {

    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM usuarios");
             ResultSet rs = ps.executeQuery()) {

            java.util.List<Usuario> usuariosList = new java.util.ArrayList<>();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setPassword(null); // no enviar password en JSON
                usuariosList.add(u);
            }

            String json = gson.toJson(usuariosList);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo(); // /login o null
        Type tipo = new TypeToken<Usuario>() {}.getType();
        Usuario usuario = gson.fromJson(request.getReader(), tipo);

        if ("/login".equals(path)) {
            handleLogin(usuario, response);
        } else {
            handleRegistro(usuario, response);
        }
    }

    private void handleLogin(Usuario usuario, HttpServletResponse response) throws IOException {
        String sql = "SELECT * FROM usuarios WHERE email=? AND password=?";
        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usuario.getEmail());
            ps.setString(2, usuario.getPassword());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNombre(rs.getString("nombre"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(null); // no enviar password

                    String json = gson.toJson(u);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(json);
                } else {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Email o contraseña incorrectos");
                }
            }

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void handleRegistro(Usuario usuario, HttpServletResponse response) throws IOException {
        if (usuario.getNombre() == null || usuario.getEmail() == null || usuario.getPassword() == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan datos para el registro");
            return;
        }

        String sql = "INSERT INTO usuarios(nombre, email, password) VALUES(?,?,?)";
        try (Connection conn = Conexion.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getEmail());
            ps.setString(3, usuario.getPassword());
            ps.executeUpdate();
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write("{\"mensaje\":\"Usuario registrado\"}");

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
