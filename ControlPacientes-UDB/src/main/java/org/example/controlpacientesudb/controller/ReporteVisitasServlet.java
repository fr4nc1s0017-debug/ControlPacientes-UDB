package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.VisitaDAO;
import org.example.controlpacientesudb.modelo.entidades.Visita;
import jakarta.servlet.*;
        import jakarta.servlet.http.*;
        import jakarta.servlet.annotation.*;
        import java.io.IOException;
import java.util.List;

@WebServlet("/reporte-visitas")
public class ReporteVisitasServlet extends HttpServlet {

    private VisitaDAO visitaDAO;

    @Override
    public void init() throws ServletException {
        visitaDAO = new VisitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Visita> listaVisitas = visitaDAO.SeleccionarTodasVisitas();
            request.setAttribute("listaVisitas", listaVisitas);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/reporteVisitas.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error al cargar el reporte de visitas", e);
        }
    }
}