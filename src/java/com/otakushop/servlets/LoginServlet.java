package com.otakushop.servlets;

import com.otakushop.model.Usuario;
import com.otakushop.util.Conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("usuario");  // input del login.jsp
        String password = request.getParameter("clave"); // input del login.jsp

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getConnection();
            String sql = "SELECT * FROM usuarios WHERE email=? AND password=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                // Crear objeto Usuario a partir de la BD
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));          // asegúrate que la columna se llama "id"
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password")); // ⚠️ se guarda, pero no se recomienda mostrar

                // Guardar en sesión
                HttpSession session = request.getSession();
                session.setAttribute("usuario", u);

                // Redirigir al dashboard
                response.sendRedirect("inicio.jsp");

            } else {
                // Usuario o contraseña incorrectos
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en la conexión a la base de datos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (con != null) con.close(); } catch (SQLException ignored) {}
        }
    }
}
