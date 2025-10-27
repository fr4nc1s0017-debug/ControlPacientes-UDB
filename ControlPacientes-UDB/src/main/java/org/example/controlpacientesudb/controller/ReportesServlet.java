package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.PacienteMemoryDAO;
import org.example.controlpacientesudb.dao.CitaMedicaMemoryDAO;
import org.example.controlpacientesudb.dao.VisitaMemoryDAO;
import org.example.controlpacientesudb.modelo.entidades.Paciente;
import org.example.controlpacientesudb.modelo.entidades.CitaMedica;
import org.example.controlpacientesudb.modelo.entidades.Visita;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Importaciones de JasperReports
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.util.JRLoader;

@WebServlet("/reportes")
public class ReportesServlet extends HttpServlet {

    private PacienteMemoryDAO pacienteDAO;
    private CitaMedicaMemoryDAO citaDAO;
    private VisitaMemoryDAO visitaDAO;

    @Override
    public void init() throws ServletException {
        pacienteDAO = new PacienteMemoryDAO();
        citaDAO = new CitaMedicaMemoryDAO();
        visitaDAO = new VisitaMemoryDAO();
        System.out.println("=== SERVLET DE REPORTES JASPER INICIALIZADO ===");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String tipo = request.getParameter("tipo");
        String formato = request.getParameter("formato");

        System.out.println("Solicitud de reporte - Action: " + action + ", Tipo: " + tipo + ", Formato: " + formato);

        try {
            if (action == null) {
                mostrarPanelReportes(request, response);
            } else if ("generar".equals(action)) {
                generarReporteJasper(request, response, tipo, formato);
            } else {
                mostrarPanelReportes(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error generando reporte: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("reportes?error=Error+al+generar+el+reporte");
        }
    }

    private void mostrarPanelReportes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Paciente> pacientes = pacienteDAO.obtenerTodosPacientes();
        List<CitaMedica> citas = citaDAO.obtenerTodasCitas();
        List<Visita> visitas = visitaDAO.obtenerTodasVisitas();

        request.setAttribute("totalPacientes", pacientes.size());
        request.setAttribute("totalCitas", citas.size());
        request.setAttribute("totalVisitas", visitas.size());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/reportes.jsp");
        dispatcher.forward(request, response);
    }

    private void generarReporteJasper(HttpServletRequest request, HttpServletResponse response, String tipo, String formato)
            throws ServletException, IOException {

        try {
            // Configurar respuesta según el formato
            if ("pdf".equalsIgnoreCase(formato)) {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"reporte_" + tipo + ".pdf\"");
            } else if ("html".equalsIgnoreCase(formato)) {
                response.setContentType("text/html");
                response.setHeader("Content-Disposition", "inline; filename=\"reporte_" + tipo + ".html\"");
            } else if ("xlsx".equalsIgnoreCase(formato)) {
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment; filename=\"reporte_" + tipo + ".xlsx\"");
            }

            // Generar reporte según el tipo
            switch (tipo) {
                case "pacientes":
                    generarReportePacientesJasper(response, formato);
                    break;
                case "citas":
                    generarReporteCitasJasper(response, formato);
                    break;
                case "visitas":
                    generarReporteVisitasJasper(response, formato);
                    break;
                case "estadisticas":
                    generarReporteEstadisticasJasper(response, formato);
                    break;
                default:
                    response.sendRedirect("reportes?error=Tipo+de+reporte+no+válido");
                    return;
            }

        } catch (Exception e) {
            throw new ServletException("Error generando reporte Jasper: " + e.getMessage(), e);
        }
    }

    private void generarReportePacientesJasper(HttpServletResponse response, String formato) throws Exception {
        List<Paciente> pacientes = pacienteDAO.obtenerTodosPacientes();

        // Cargar el archivo .jrxml compilado (.jasper)
        InputStream reportStream = getServletContext().getResourceAsStream("/WEB-INF/reports/pacientes.jrxml");
        if (reportStream == null) {
            throw new ServletException("No se pudo encontrar el archivo de reporte pacientes.jrxml");
        }

        // Compilar el reporte (en producción, usar .jasper precompilado)
        JasperReport jasperReport = JasperCompileManager.compileReport(reportStream);
        reportStream.close();

        // Preparar parámetros
        Map<String, Object> parametros = new HashMap<>();
        parametros.put("TITULO", "Listado Completo de Pacientes Registrados");
        parametros.put("FECHA_GENERACION", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        parametros.put("TOTAL_PACIENTES", pacientes.size());

        // Crear datasource
        JRDataSource dataSource = new JRBeanCollectionDataSource(pacientes);

        // Llenar el reporte
        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parametros, dataSource);

        // Exportar según el formato
        exportarReporte(response, jasperPrint, formato);
    }

    private void generarReporteCitasJasper(HttpServletResponse response, String formato) throws Exception {
        List<CitaMedica> citas = citaDAO.obtenerTodasCitas();
        List<Paciente> pacientes = pacienteDAO.obtenerTodosPacientes();

        // Para citas, necesitamos un DTO especial que combine datos
        // Por simplicidad, usaremos el método HTML por ahora
        generarReporteCitasHTML(response, citas, pacientes);
    }

    private void generarReporteVisitasJasper(HttpServletResponse response, String formato) throws Exception {
        List<Visita> visitas = visitaDAO.obtenerTodasVisitas();

        // Similar a citas, necesitaríamos un DTO
        generarReporteVisitasHTML(response, visitas);
    }

    private void generarReporteEstadisticasJasper(HttpServletResponse response, String formato) throws Exception {
        List<Paciente> pacientes = pacienteDAO.obtenerTodosPacientes();
        List<CitaMedica> citas = citaDAO.obtenerTodasCitas();
        List<Visita> visitas = visitaDAO.obtenerTodasVisitas();

        generarReporteEstadisticasHTML(response, pacientes, citas, visitas);
    }

    private void exportarReporte(HttpServletResponse response, JasperPrint jasperPrint, String formato) throws Exception {
        OutputStream outputStream = response.getOutputStream();

        switch (formato.toLowerCase()) {
            case "pdf":
                JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);
                break;
            case "html":
                JasperExportManager.exportReportToHtmlFile(jasperPrint, "reporte_temp.html");
                // Para HTML necesitarías una solución más elaborada
                generarReportePacientesHTML(response, pacienteDAO.obtenerTodosPacientes());
                return;
            case "xlsx":
                // Para Excel necesitarías jasperreports-exporters
                generarReportePacientesHTML(response, pacienteDAO.obtenerTodosPacientes());
                return;
            default:
                JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);
                break;
        }

        outputStream.flush();
        outputStream.close();
    }

    // Mantener los métodos HTML como fallback
    private void generarReportePacientesHTML(HttpServletResponse response, List<Paciente> pacientes) throws IOException {
        String htmlContent = generarHTMLReportePacientes(pacientes);
        response.getWriter().write(htmlContent);
    }

    private void generarReporteCitasHTML(HttpServletResponse response, List<CitaMedica> citas, List<Paciente> pacientes) throws IOException {
        String htmlContent = generarHTMLReporteCitas(citas, pacientes);
        response.getWriter().write(htmlContent);
    }

    private void generarReporteVisitasHTML(HttpServletResponse response, List<Visita> visitas) throws IOException {
        String htmlContent = generarHTMLReporteVisitas(visitas);
        response.getWriter().write(htmlContent);
    }

    private void generarReporteEstadisticasHTML(HttpServletResponse response, List<Paciente> pacientes, List<CitaMedica> citas, List<Visita> visitas) throws IOException {
        String htmlContent = generarHTMLReporteEstadisticas(pacientes, citas, visitas);
        response.getWriter().write(htmlContent);
    }

    // Mantener los métodos de generación HTML del código anterior...
    private String generarHTMLReportePacientes(List<Paciente> pacientes) {
        // ... (el mismo código HTML que teníamos antes)
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Reporte de Pacientes</title>");
        html.append("<style>body { font-family: Arial, sans-serif; margin: 20px; }");
        html.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        html.append("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
        html.append("th { background-color: #4f46e5; color: white; }");
        html.append(".header { text-align: center; margin-bottom: 30px; }");
        html.append(".footer { margin-top: 30px; text-align: center; color: #666; }");
        html.append("</style></head><body>");

        html.append("<div class='header'>");
        html.append("<h1>Reporte de Pacientes</h1>");
        html.append("<p>Sistema de Gestión Médica - Generado: ").append(LocalDateTime.now()).append("</p>");
        html.append("<p>Total de pacientes: ").append(pacientes.size()).append("</p>");
        html.append("</div>");

        html.append("<table>");
        html.append("<tr><th>ID</th><th>Nombre Completo</th><th>Edad</th><th>Sexo</th><th>Teléfono</th><th>Email</th></tr>");

        for (Paciente paciente : pacientes) {
            html.append("<tr>");
            html.append("<td>").append(paciente.getIdPaciente()).append("</td>");
            html.append("<td>").append(paciente.getNombreCompleto()).append("</td>");
            html.append("<td>").append(paciente.getEdad()).append(" años</td>");
            html.append("<td>").append(paciente.getSexo()).append("</td>");
            html.append("<td>").append(paciente.getTelefono()).append("</td>");
            html.append("<td>").append(paciente.getEmail()).append("</td>");
            html.append("</tr>");
        }

        html.append("</table>");

        html.append("<div class='footer'>");
        html.append("<p>Reporte generado automáticamente por el Sistema de Gestión Médica</p>");
        html.append("</div>");

        html.append("</body></html>");
        return html.toString();
    }

    // ... (mantener los demás métodos HTML)
    private String generarHTMLReporteCitas(List<CitaMedica> citas, List<Paciente> pacientes) {
        // ... (código existente)
        return ""; // Simplificado para este ejemplo
    }

    private String generarHTMLReporteVisitas(List<Visita> visitas) {
        // ... (código existente)
        return ""; // Simplificado para este ejemplo
    }

    private String generarHTMLReporteEstadisticas(List<Paciente> pacientes, List<CitaMedica> citas, List<Visita> visitas) {
        // ... (código existente)
        return ""; // Simplificado para este ejemplo
    }
}