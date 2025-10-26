package org.example.controlpacientesudb.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // URLs que no requieren autenticación
        boolean isLoginPage = requestURI.equals(contextPath + "/login") ||
                requestURI.equals(contextPath + "/login.jsp");
        boolean isLoginAction = requestURI.equals(contextPath + "/login") &&
                "POST".equalsIgnoreCase(httpRequest.getMethod());
        boolean isStaticResource = requestURI.matches(".*(\\.css|\\.js|\\.png|\\.jpg|\\.ico)");

        boolean isLoggedIn = (session != null && session.getAttribute("usuarioLogueado") != null);

        if (isLoggedIn || isLoginPage || isLoginAction || isStaticResource) {
            // Usuario logueado o página pública, continuar
            chain.doFilter(request, response);
        } else {
            // Usuario no logueado, redirigir al login
            System.out.println("Acceso no autorizado a: " + requestURI + " - Redirigiendo al login");
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }
}