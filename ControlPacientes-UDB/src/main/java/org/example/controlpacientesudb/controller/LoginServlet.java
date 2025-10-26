package org.example.controlpacientesudb.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Credenciales hardcodeadas (en un sistema real esto estaría en base de datos)
    private static final String USERNAME = "admin";
    private static final String PASSWORD = "1234";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Si ya está logueado, redirigir al dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            response.sendRedirect("dashboard");
            return;
        }

        // Mostrar formulario de login
        RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Intento de login: " + username);

        if (USERNAME.equals(username) && PASSWORD.equals(password)) {
            // Login exitoso
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", true);
            session.setAttribute("username", username);
            session.setMaxInactiveInterval(30 * 60); // 30 minutos de sesión

            System.out.println("Login exitoso para: " + username);
            response.sendRedirect("dashboard");
        } else {
            // Login fallido
            System.out.println("Login fallido para: " + username);
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
        }
    }
}