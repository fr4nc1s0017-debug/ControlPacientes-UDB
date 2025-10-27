package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.VisitaMemoryDAO;
import org.example.controlpacientesudb.dao.PacienteMemoryDAO;
import org.example.controlpacientesudb.modelo.entidades.Visita;
import org.example.controlpacientesudb.modelo.entidades.Paciente;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/reporte-visitas")
public class ReporteVisitasServlet extends HttpServlet {

    private VisitaMemoryDAO visitaDAO;
    private PacienteMemoryDAO pacienteDAO;

    @Override
    public void init() throws ServletException {
        visitaDAO = new VisitaMemoryDAO();
        pacienteDAO = new PacienteMemoryDAO();
        System.out.println("=== SERVLET DE REPORTE VISITAS INICIALIZADO ===");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        String formato = request.getParameter("formato");

        try {
            if ("descargar".equals(action)) {
                descargarReporte(request, response, formato);
            } else {
                mostrarReporteConFiltros(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error en ReporteVisitasServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard?error=Error+al+cargar+reporte+de+visitas");
        }
    }

    private void mostrarReporteConFiltros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener parámetros de filtro
        String idPacienteStr = request.getParameter("idPaciente");
        String fechaDesdeStr = request.getParameter("fechaDesde");
        String fechaHastaStr = request.getParameter("fechaHasta");
        String triage = request.getParameter("triage");

        Integer idPaciente = null;
        LocalDateTime fechaDesde = null;
        LocalDateTime fechaHasta = null;

        // Parsear paciente
        if (idPacienteStr != null && !idPacienteStr.isEmpty()) {
            try {
                idPaciente = Integer.parseInt(idPacienteStr);
            } catch (NumberFormatException e) {
                System.out.println("Paciente inválido: " + idPacienteStr);
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
                fechaHasta = fecha.atTime(23, 59, 59);
            } catch (Exception e) {
                System.out.println("Fecha hasta inválida: " + fechaHastaStr);
            }
        }

        // Obtener visitas filtradas
        List<Visita> listaVisitas = visitaDAO.buscarVisitasConFiltros(idPaciente, fechaDesde, fechaHasta, triage);
        List<Paciente> listaPacientes = pacienteDAO.obtenerTodosPacientes();

        // Obtener mapa de médicos
        Map<Integer, String> medicos = visitaDAO.obtenerMedicos();

        // Pasar datos a la vista
        request.setAttribute("listaVisitas", listaVisitas);
        request.setAttribute("listaPacientes", listaPacientes);
        request.setAttribute("medicos", medicos);

        boolean filtrosAplicados = idPacienteStr != null || fechaDesdeStr != null ||
                fechaHastaStr != null || (triage != null && !"Todos".equals(triage));

        request.setAttribute("filtrosAplicados", filtrosAplicados);
        request.setAttribute("idPacienteFiltro", idPacienteStr);
        request.setAttribute("fechaDesdeFiltro", fechaDesdeStr);
        request.setAttribute("fechaHastaFiltro", fechaHastaStr);
        request.setAttribute("triageFiltro", triage != null ? triage : "Todos");

        System.out.println("Enviando " + listaVisitas.size() + " visitas a la vista");
        System.out.println("Filtros aplicados: " + filtrosAplicados);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/reporteVisitas.jsp");
        dispatcher.forward(request, response);
    }

    private void descargarReporte(HttpServletRequest request, HttpServletResponse response, String formato)
            throws ServletException, IOException {

        try {
            // Obtener los mismos filtros aplicados
            String idPacienteStr = request.getParameter("idPaciente");
            String fechaDesdeStr = request.getParameter("fechaDesde");
            String fechaHastaStr = request.getParameter("fechaHasta");
            String triage = request.getParameter("triage");

            Integer idPaciente = null;
            LocalDateTime fechaDesde = null;
            LocalDateTime fechaHasta = null;

            // Aplicar los mismos filtros que en la vista
            if (idPacienteStr != null && !idPacienteStr.isEmpty()) {
                idPaciente = Integer.parseInt(idPacienteStr);
            }

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            if (fechaDesdeStr != null && !fechaDesdeStr.isEmpty()) {
                LocalDate fecha = LocalDate.parse(fechaDesdeStr, dateFormatter);
                fechaDesde = fecha.atStartOfDay();
            }

            if (fechaHastaStr != null && !fechaHastaStr.isEmpty()) {
                LocalDate fecha = LocalDate.parse(fechaHastaStr, dateFormatter);
                fechaHasta = fecha.atTime(23, 59, 59);
            }

            List<Visita> listaVisitas = visitaDAO.buscarVisitasConFiltros(idPaciente, fechaDesde, fechaHasta, triage);
            List<Paciente> listaPacientes = pacienteDAO.obtenerTodosPacientes();
            Map<Integer, String> medicos = obtenerMedicos();

            // Configurar respuesta según el formato
            if ("pdf".equalsIgnoreCase(formato)) {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"reporte_visitas.pdf\"");
                generarReportePDF(response, listaVisitas, listaPacientes, medicos);
            } else if ("excel".equalsIgnoreCase(formato)) {
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment; filename=\"reporte_visitas.xlsx\"");
                generarReporteExcel(response, listaVisitas, listaPacientes, medicos);
            } else {
                response.setContentType("text/html");
                generarReporteHTML(response, listaVisitas, listaPacientes, medicos);
            }

        } catch (Exception e) {
            System.out.println("Error generando reporte: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("reporte-visitas?error=Error+al+generar+el+reporte");
        }
    }

    private void generarReportePDF(HttpServletResponse response, List<Visita> visitas, List<Paciente> pacientes, Map<Integer, String> medicos)
            throws IOException {
        // Por ahora generamos HTML, en una implementación real usarías JasperReports
        String htmlContent = generarContenidoReporte(visitas, pacientes, medicos, "PDF");
        response.getWriter().write(htmlContent);
    }

    private void generarReporteExcel(HttpServletResponse response, List<Visita> visitas, List<Paciente> pacientes, Map<Integer, String> medicos)
            throws IOException {
        // Por ahora generamos HTML, en una implementación real usarías Apache POI
        String htmlContent = generarContenidoReporte(visitas, pacientes, medicos, "Excel");
        response.getWriter().write(htmlContent);
    }

    private void generarReporteHTML(HttpServletResponse response, List<Visita> visitas, List<Paciente> pacientes, Map<Integer, String> medicos)
            throws IOException {
        String htmlContent = generarContenidoReporte(visitas, pacientes, medicos, "HTML");
        response.getWriter().write(htmlContent);
    }

    private String generarContenidoReporte(List<Visita> visitas, List<Paciente> pacientes, Map<Integer, String> medicos, String formato) {
        StringBuilder html = new StringBuilder();

        // Crear mapa de pacientes para búsqueda rápida
        Map<Integer, String> mapaPacientes = new HashMap<>();
        for (Paciente paciente : pacientes) {
            mapaPacientes.put(paciente.getIdPaciente(), paciente.getNombreCompleto());
        }

        if ("HTML".equals(formato)) {
            html.append("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Reporte de Visitas</title>");
            html.append("<style>body { font-family: Arial, sans-serif; margin: 20px; }");
            html.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
            html.append("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
            html.append("th { background-color: #4f46e5; color: white; }");
            html.append(".header { text-align: center; margin-bottom: 30px; }");
            html.append(".footer { margin-top: 30px; text-align: center; color: #666; }");
            html.append("</style></head><body>");
        } else {
            html.append("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Reporte de Visitas</title>");
            html.append("<style>body { font-family: Arial, sans-serif; margin: 20px; font-size: 12px; }");
            html.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
            html.append("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            html.append("th { background-color: #4f46e5; color: white; }");
            html.append(".header { text-align: center; margin-bottom: 20px; }");
            html.append(".footer { margin-top: 20px; text-align: center; color: #666; font-size: 10px; }");
            html.append("</style></head><body>");
        }

        html.append("<div class='header'>");
        html.append("<h1>Reporte de Visitas Médicas</h1>");
        html.append("<p>Sistema de Gestión Médica - Generado: ").append(LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))).append("</p>");
        html.append("<p>Total de visitas: ").append(visitas.size()).append("</p>");
        html.append("</div>");

        html.append("<table>");
        html.append("<tr><th>ID</th><th>Paciente</th><th>Fecha</th><th>Hora</th><th>Médico</th><th>Triage</th><th>Circunstancia</th></tr>");

        for (Visita visita : visitas) {
            // Buscar nombre del paciente
            String nombrePaciente = mapaPacientes.get(visita.getIdExpediente());
            if (nombrePaciente == null) {
                nombrePaciente = "Paciente ID: " + visita.getIdExpediente();
            }

            // Buscar nombre del médico
            String nombreMedico = medicos.get(visita.getIdMedico());
            if (nombreMedico == null) {
                nombreMedico = "Médico ID: " + visita.getIdMedico();
            }

            html.append("<tr>");
            html.append("<td>").append(visita.getIdVisita()).append("</td>");
            html.append("<td>").append(nombrePaciente).append("</td>");
            html.append("<td>").append(visita.getSoloFecha()).append("</td>");
            html.append("<td>").append(visita.getSoloHora()).append("</td>");
            html.append("<td>").append(nombreMedico).append("</td>");
            html.append("<td>").append(visita.getTriage()).append("</td>");
            html.append("<td>").append(visita.getCircumstancia()).append("</td>");
            html.append("</tr>");
        }

        html.append("</table>");

        html.append("<div class='footer'>");
        html.append("<p>Reporte generado en formato ").append(formato).append("</p>");
        html.append("</div>");

        if ("HTML".equals(formato)) {
            html.append("</body></html>");
        } else {
            html.append("</body></html>");
        }

        return html.toString();
    }

    private Map<Integer, String> obtenerMedicos() {
        Map<Integer, String> medicos = new HashMap<>();
        medicos.put(1, "Dr. Juan Pérez");
        medicos.put(2, "Dra. Ana Gómez");
        medicos.put(3, "Dr. Carlos Rodríguez");
        medicos.put(4, "Dra. María López");
        medicos.put(5, "Dr. Roberto Sánchez");
        return medicos;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}