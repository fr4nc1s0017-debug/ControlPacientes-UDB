package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.VisitaMemoryDAO;
import org.example.controlpacientesudb.modelo.entidades.Visita;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/reporte-visitas")
public class ReporteVisitasServlet extends HttpServlet {

    private VisitaMemoryDAO visitaDAO;

    @Override
    public void init() throws ServletException {
        visitaDAO = new VisitaMemoryDAO();
        System.out.println("=== SERVLET DE REPORTE VISITAS INICIALIZADO ===");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar codificación
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // Obtener parámetros de filtro
            String idExpedienteStr = request.getParameter("idExpediente");
            String fechaDesdeStr = request.getParameter("fechaDesde");
            String fechaHastaStr = request.getParameter("fechaHasta");
            String triage = request.getParameter("triage");

            Integer idExpediente = null;
            LocalDateTime fechaDesde = null;
            LocalDateTime fechaHasta = null;

            // Parsear expediente
            if (idExpedienteStr != null && !idExpedienteStr.isEmpty()) {
                try {
                    idExpediente = Integer.parseInt(idExpedienteStr);
                } catch (NumberFormatException e) {
                    System.out.println("Expediente inválido: " + idExpedienteStr);
                }
            }

            // Parsear fechas
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            if (fechaDesdeStr != null && !fechaDesdeStr.isEmpty()) {
                try {
                    LocalDate fecha = LocalDate.parse(fechaDesdeStr, dateFormatter);
                    fechaDesde = fecha.atStartOfDay();
                } catch (Exception e) {
                    System.out.println("Fecha desde inválida: " + fechaDesdeStr);
                }
            }

            if (fechaHastaStr != null && !fechaHastaStr.isEmpty()) {
                try {
                    LocalDate fecha = LocalDate.parse(fechaHastaStr, dateFormatter);
                    fechaHasta = fecha.atTime(23, 59, 59); // Fin del día
                } catch (Exception e) {
                    System.out.println("Fecha hasta inválida: " + fechaHastaStr);
                }
            }

            // Obtener visitas filtradas
            List<Visita> listaVisitas = visitaDAO.buscarVisitasConFiltros(idExpediente, fechaDesde, fechaHasta, triage);

            // Pasar datos a la vista
            request.setAttribute("listaVisitas", listaVisitas);
            request.setAttribute("expedientesUnicos", visitaDAO.obtenerExpedientesUnicos());
            request.setAttribute("filtrosAplicados", idExpedienteStr != null || fechaDesdeStr != null || fechaHastaStr != null || (triage != null && !"Todos".equals(triage)));
            request.setAttribute("idExpedienteFiltro", idExpedienteStr);
            request.setAttribute("fechaDesdeFiltro", fechaDesdeStr);
            request.setAttribute("fechaHastaFiltro", fechaHastaStr);
            request.setAttribute("triageFiltro", triage != null ? triage : "Todos");

            System.out.println("Enviando " + listaVisitas.size() + " visitas a la vista");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/reporteVisitas.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("Error en ReporteVisitasServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard?error=Error+al+cargar+reporte+de+visitas");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir a GET para procesar filtros
        doGet(request, response);
    }
}