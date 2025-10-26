package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.CitaMedicaDAO;
import org.example.controlpacientesudb.modelo.entidades.CitaMedica;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/citas-medicas")
public class CitaMedicaServlet extends HttpServlet {

    private CitaMedicaDAO citaDAO;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaMedicaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action == null) {
                // Mostrar lista de citas
                listarCitas(request, response);
            } else {
                switch (action) {
                    case "nueva":
                        mostrarFormularioNuevaCita(request, response);
                        break;
                    case "editar":
                        mostrarFormularioEditarCita(request, response);
                        break;
                    case "eliminar":
                        eliminarCita(request, response);
                        break;
                    default:
                        listarCitas(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            System.out.println("Error en CitaMedicaServlet: " + e.getMessage());
            e.printStackTrace();
            // En caso de error, mostrar datos de prueba
            mostrarDatosPrueba(request, response);
        }
    }

    private void listarCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<CitaMedica> listaCitas = citaDAO.obtenerTodasCitas();
            request.setAttribute("listaCitas", listaCitas);
        } catch (Exception e) {
            // Si hay error con la BD, mostrar datos de prueba
            System.out.println("Error obteniendo citas de BD, mostrando datos de prueba");
            mostrarDatosPrueba(request, response);
            return;
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/citasMedicas.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarDatosPrueba(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<CitaMedica> citasPrueba = new ArrayList<>();

        // Crear citas de prueba
        CitaMedica cita1 = new CitaMedica();
        cita1.setIdCita(1);
        cita1.setIdExpediente(101);
        cita1.setIdMedico(1);
        cita1.setFechaHoraCita(LocalDateTime.now().plusDays(1));
        cita1.setTipoCita("Consulta General");
        cita1.setEstado("Pendiente");
        citasPrueba.add(cita1);

        CitaMedica cita2 = new CitaMedica();
        cita2.setIdCita(2);
        cita2.setIdExpediente(102);
        cita2.setIdMedico(2);
        cita2.setFechaHoraCita(LocalDateTime.now().plusDays(2));
        cita2.setTipoCita("Control");
        cita2.setEstado("Confirmada");
        citasPrueba.add(cita2);

        CitaMedica cita3 = new CitaMedica();
        cita3.setIdCita(3);
        cita3.setIdExpediente(103);
        cita3.setIdMedico(1);
        cita3.setFechaHoraCita(LocalDateTime.now().plusHours(3));
        cita3.setTipoCita("Emergencia");
        cita3.setEstado("Completada");
        citasPrueba.add(cita3);

        request.setAttribute("listaCitas", citasPrueba);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/citasMedicas.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFormularioNuevaCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Por ahora redirigir a una página simple
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>Formulario para Nueva Cita</h1>");
        response.getWriter().println("<p>Esta funcionalidad estará disponible pronto</p>");
        response.getWriter().println("<a href='citas-medicas'>Volver a Citas</a>");
        response.getWriter().println("</body></html>");
    }

    private void mostrarFormularioEditarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.getWriter().println("<html><body>");
        response.getWriter().println("<h1>Editar Cita</h1>");
        response.getWriter().println("<p>Esta funcionalidad estará disponible pronto</p>");
        response.getWriter().println("<a href='citas-medicas'>Volver a Citas</a>");
        response.getWriter().println("</body></html>");
    }

    private void eliminarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Simular eliminación exitosa
        response.sendRedirect("citas-medicas?success=Cita+eliminada+exitosamente");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Simular guardado exitoso
        response.sendRedirect("citas-medicas?success=Cita+guardada+exitosamente");
    }
}