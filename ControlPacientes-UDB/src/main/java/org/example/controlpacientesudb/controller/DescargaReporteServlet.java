package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.VisitaMemoryDAO;
import org.example.controlpacientesudb.dao.PacienteMemoryDAO;
import org.example.controlpacientesudb.modelo.entidades.Visita;
import org.example.controlpacientesudb.modelo.entidades.Paciente;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/descargar-reporte")
public class DescargaReporteServlet extends HttpServlet {

    private VisitaMemoryDAO visitaDAO;
    private PacienteMemoryDAO pacienteDAO;

    @Override
    public void init() throws ServletException {
        visitaDAO = new VisitaMemoryDAO();
        pacienteDAO = new PacienteMemoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formato = request.getParameter("formato");
        String idPacienteStr = request.getParameter("idPaciente");
        String fechaDesdeStr = request.getParameter("fechaDesde");
        String fechaHastaStr = request.getParameter("fechaHasta");
        String triage = request.getParameter("triage");

        System.out.println("Descargando reporte en formato: " + formato);

        try {
            // Aplicar los mismos filtros
            Integer idPaciente = null;
            LocalDateTime fechaDesde = null;
            LocalDateTime fechaHasta = null;

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

            List<Visita> visitas = visitaDAO.buscarVisitasConFiltros(idPaciente, fechaDesde, fechaHasta, triage);
            List<Paciente> pacientes = pacienteDAO.obtenerTodosPacientes();

            // Configurar respuesta para evitar caché
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // Generar reporte según el formato
            switch (formato.toLowerCase()) {
                case "pdf":
                    generarPDF(response, visitas, pacientes);
                    break;
                case "excel":
                    generarExcel(response, visitas, pacientes);
                    break;
                case "html":
                default:
                    generarHTML(response, visitas, pacientes);
                    break;
            }

        } catch (Exception e) {
            System.out.println("Error generando reporte: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("reporte-visitas?error=Error+al+generar+el+reporte");
        }
    }

    private void generarPDF(HttpServletResponse response, List<Visita> visitas, List<Paciente> pacientes) throws IOException {
        // Para PDF, necesitamos forzar la descarga con Content-Disposition
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"reporte_visitas.pdf\"");

        // En una implementación real usarías una librería como iText o JasperReports
        // Por ahora generamos un HTML que se puede imprimir como PDF
        PrintWriter out = response.getWriter();
        String htmlContent = generarContenidoHTML(visitas, pacientes, "PDF");
        out.write(htmlContent);
        out.flush();
    }

    private void generarExcel(HttpServletResponse response, List<Visita> visitas, List<Paciente> pacientes) throws IOException {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=\"reporte_visitas.xls\"");

        PrintWriter out = response.getWriter();
        StringBuilder excel = new StringBuilder();
        excel.append("ID\tPaciente\tFecha\tHora\tMédico\tTriage\tCircunstancia\n");

        for (Visita visita : visitas) {
            String nombrePaciente = "Paciente no encontrado";
            for (Paciente paciente : pacientes) {
                if (paciente.getIdPaciente() == visita.getIdExpediente()) {
                    nombrePaciente = paciente.getNombreCompleto();
                    break;
                }
            }

            excel.append(visita.getIdVisita()).append("\t")
                    .append(nombrePaciente).append("\t")
                    .append(visita.getSoloFecha()).append("\t")
                    .append(visita.getSoloHora()).append("\t")
                    .append("Médico ").append(visita.getIdMedico()).append("\t")
                    .append(visita.getTriage()).append("\t")
                    .append(visita.getCircumstancia()).append("\n");
        }

        out.write(excel.toString());
        out.flush();
    }

    private void generarHTML(HttpServletResponse response, List<Visita> visitas, List<Paciente> pacientes) throws IOException {
        response.setContentType("text/html");
        response.setHeader("Content-Disposition", "inline; filename=\"reporte_visitas.html\"");

        PrintWriter out = response.getWriter();
        String htmlContent = generarContenidoHTML(visitas, pacientes, "HTML");
        out.write(htmlContent);
        out.flush();
    }

    private String generarContenidoHTML(List<Visita> visitas, List<Paciente> pacientes, String formato) {
        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>");
        html.append("<html lang='es'>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>Reporte de Visitas Médicas</title>");

        if ("PDF".equals(formato)) {
            html.append("<style>");
            html.append("body { font-family: Arial, sans-serif; margin: 20px; font-size: 12px; }");
            html.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
            html.append("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            html.append("th { background-color: #4f46e5; color: white; }");
            html.append(".header { text-align: center; margin-bottom: 20px; }");
            html.append(".footer { margin-top: 20px; text-align: center; color: #666; font-size: 10px; }");
            html.append(".badge { padding: 2px 6px; border-radius: 10px; font-size: 10px; font-weight: bold; }");
            html.append(".badge-verde { background-color: #d1fae5; color: #065f46; }");
            html.append(".badge-amarillo { background-color: #fef3c7; color: #92400e; }");
            html.append(".badge-rojo { background-color: #fee2e2; color: #991b1b; }");
            html.append(".badge-negro { background-color: #000; color: white; }");
            html.append("</style>");
        } else {
            html.append("<style>");
            html.append("body { font-family: Arial, sans-serif; margin: 20px; }");
            html.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
            html.append("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
            html.append("th { background-color: #4f46e5; color: white; }");
            html.append(".header { text-align: center; margin-bottom: 30px; }");
            html.append(".footer { margin-top: 30px; text-align: center; color: #666; }");
            html.append(".badge { padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: bold; }");
            html.append(".badge-verde { background-color: #d1fae5; color: #065f46; }");
            html.append(".badge-amarillo { background-color: #fef3c7; color: #92400e; }");
            html.append(".badge-rojo { background-color: #fee2e2; color: #991b1b; }");
            html.append(".badge-negro { background-color: #000; color: white; }");
            html.append("</style>");
        }

        html.append("</head>");
        html.append("<body>");

        // Header
        html.append("<div class='header'>");
        html.append("<h1>Reporte de Visitas Médicas</h1>");
        html.append("<p><strong>Generado:</strong> ").append(LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))).append("</p>");
        html.append("<p><strong>Total de visitas:</strong> ").append(visitas.size()).append("</p>");
        html.append("</div>");

        // Tabla
        html.append("<table>");
        html.append("<thead>");
        html.append("<tr>");
        html.append("<th>ID</th>");
        html.append("<th>Paciente</th>");
        html.append("<th>Fecha</th>");
        html.append("<th>Hora</th>");
        html.append("<th>Médico</th>");
        html.append("<th>Triage</th>");
        html.append("<th>Circunstancia</th>");
        html.append("</tr>");
        html.append("</thead>");
        html.append("<tbody>");

        for (Visita visita : visitas) {
            String nombrePaciente = "Paciente no encontrado";
            for (Paciente paciente : pacientes) {
                if (paciente.getIdPaciente() == visita.getIdExpediente()) {
                    nombrePaciente = paciente.getNombreCompleto();
                    break;
                }
            }

            String badgeClass = "badge badge-verde";
            if ("Rojo".equals(visita.getTriage())) {
                badgeClass = "badge badge-rojo";
            } else if ("Amarillo".equals(visita.getTriage())) {
                badgeClass = "badge badge-amarillo";
            } else if ("Negro".equals(visita.getTriage())) {
                badgeClass = "badge badge-negro";
            }

            html.append("<tr>");
            html.append("<td>").append(visita.getIdVisita()).append("</td>");
            html.append("<td>").append(nombrePaciente).append("</td>");
            html.append("<td>").append(visita.getSoloFecha()).append("</td>");
            html.append("<td>").append(visita.getSoloHora()).append("</td>");
            html.append("<td>Médico ").append(visita.getIdMedico()).append("</td>");
            html.append("<td><span class='").append(badgeClass).append("'>").append(visita.getTriage()).append("</span></td>");
            html.append("<td>").append(visita.getCircumstancia()).append("</td>");
            html.append("</tr>");
        }

        html.append("</tbody>");
        html.append("</table>");

        // Footer
        html.append("<div class='footer'>");
        html.append("<p>Reporte generado automáticamente por el Sistema de Gestión Médica</p>");
        html.append("</div>");

        html.append("</body>");
        html.append("</html>");

        return html.toString();
    }
}