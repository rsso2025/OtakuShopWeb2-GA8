package com.otakushop.servlets;

import com.otakushop.dao.UsuarioDAO; // Importar el DAO
import com.otakushop.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
// ⚠️ ELIMINAMOS la línea de import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// ⚠️ ELIMINAMOS @WebServlet("/login")

public class LoginServlet extends HttpServlet {
    
    // Instanciamos el DAO para usar la lógica de la BD
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recibir los parámetros del formulario de login.jsp
        String credencial = request.getParameter("usuario"); // Puede ser email o username
        String password = request.getParameter("clave"); 

        // 1. Usar el DAO para validar y obtener el objeto Usuario
        Usuario u = usuarioDAO.login(credencial, password);

        if (u != null) {
            // 2. Autenticación exitosa
            HttpSession session = request.getSession();
            session.setAttribute("usuario", u);
            session.setAttribute("rol", u.getRol()); // Guardar el rol en sesión para control de acceso

            // Redirigir al dashboard
            response.sendRedirect(request.getContextPath() + "/inicio.jsp");

        } else {
            // 3. Usuario o contraseña incorrectos
            request.setAttribute("error", "Credenciales incorrectas. Intenta de nuevo.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
        
        // ⚠️ Eliminamos todo el bloque de try/catch/finally de la conexión de JDBC, 
        // ya que el DAO se encarga ahora de eso.
    }
}