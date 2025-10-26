package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.CitaMedicaMemoryDAO;
import org.example.controlpacientesudb.dao.PacienteMemoryDAO;
import org.example.controlpacientesudb.modelo.entidades.CitaMedica;
import org.example.controlpacientesudb.modelo.entidades.Paciente;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/citas-medicas")
public class CitaMedicaServlet extends HttpServlet {

    private CitaMedicaMemoryDAO memoryDAO;
    private PacienteMemoryDAO pacienteDAO;

    @Override
    public void init() throws ServletException {
        memoryDAO = new CitaMedicaMemoryDAO();
        pacienteDAO = new PacienteMemoryDAO();
        System.out.println("=== SERVLET DE CITAS INICIALIZADO ===");
        System.out.println("Sistema usando ALMACENAMIENTO EN MEMORIA TEMPORAL");
        System.out.println("Los datos se perderán al reiniciar la aplicación");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        System.out.println("=== PETICIÓN GET RECIBIDA ===");
        System.out.println("Action: " + (action != null ? action : "listar"));

        try {
            if (action == null) {
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
            System.out.println("ERROR en doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("citas-medicas?error=Error+en+el+sistema");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        System.out.println("=== PETICIÓN POST RECIBIDA ===");
        System.out.println("Action: " + action);

        try {
            if ("guardar".equals(action)) {
                guardarCita(request, response);
            } else if ("actualizar".equals(action)) {
                actualizarCita(request, response);
            } else {
                listarCitas(request, response);
            }
        } catch (Exception e) {
            System.out.println("ERROR en doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("citas-medicas?error=Error+al+procesar+la+cita");
        }
    }

    private void listarCitas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<CitaMedica> listaCitas = memoryDAO.obtenerTodasCitas();
        List<Paciente> listaPacientes = pacienteDAO.obtenerTodosPacientes();

        request.setAttribute("listaCitas", listaCitas);
        request.setAttribute("listaPacientes", listaPacientes);
        request.setAttribute("fuenteDatos", "memoria temporal");

        System.out.println("Enviando " + listaCitas.size() + " citas a la vista");
        System.out.println("Enviando " + listaPacientes.size() + " pacientes a la vista");

        RequestDispatcher dispatcher = request.getRequestDispatcher("/citasMedicas.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFormularioNuevaCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Mostrando formulario para NUEVA cita");

        // Obtener lista de pacientes para el combobox
        List<Paciente> listaPacientes = pacienteDAO.obtenerTodosPacientes();
        request.setAttribute("listaPacientes", listaPacientes);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/formCitaMedica.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFormularioEditarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idCita = Integer.parseInt(request.getParameter("id"));
        System.out.println("Mostrando formulario para EDITAR cita ID: " + idCita);

        CitaMedica cita = memoryDAO.obtenerCitaPorId(idCita);
        List<Paciente> listaPacientes = pacienteDAO.obtenerTodosPacientes();

        if (cita != null) {
            request.setAttribute("cita", cita);
            request.setAttribute("listaPacientes", listaPacientes);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/formCitaMedica.jsp");
            dispatcher.forward(request, response);
        } else {
            System.out.println("Cita no encontrada para edición: " + idCita);
            response.sendRedirect("citas-medicas?error=Cita+no+encontrada");
        }
    }

    private void guardarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            CitaMedica cita = extraerCitaDeRequest(request);
            boolean exito = memoryDAO.insertarCita(cita);

            if (exito) {
                System.out.println("Cita guardada exitosamente, redirigiendo...");
                response.sendRedirect("citas-medicas?success=Cita+agendada+exitosamente");
            } else {
                System.out.println("Error al guardar cita");
                response.sendRedirect("citas-medicas?error=Error+al+agendar+la+cita");
            }

        } catch (Exception e) {
            System.out.println("ERROR grave al guardar cita: " + e.getMessage());
            response.sendRedirect("citas-medicas?error=Error+grave+al+agendar+la+cita");
        }
    }

    private void actualizarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("idCita"));
            CitaMedica cita = extraerCitaDeRequest(request);
            cita.setIdCita(idCita);

            boolean exito = memoryDAO.actualizarCita(cita);

            if (exito) {
                System.out.println("Cita actualizada exitosamente");
                response.sendRedirect("citas-medicas?success=Cita+actualizada+exitosamente");
            } else {
                System.out.println("Error al actualizar cita");
                response.sendRedirect("citas-medicas?error=Error+al+actualizar+la+cita");
            }

        } catch (Exception e) {
            System.out.println("ERROR grave al actualizar cita: " + e.getMessage());
            response.sendRedirect("citas-medicas?error=Error+grave+al+actualizar+la+cita");
        }
    }

    private void eliminarCita(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idCita = Integer.parseInt(request.getParameter("id"));
            boolean exito = memoryDAO.eliminarCita(idCita);

            if (exito) {
                System.out.println("Cita eliminada exitosamente");
                response.sendRedirect("citas-medicas?success=Cita+eliminada+exitosamente");
            } else {
                System.out.println("Error al eliminar cita");
                response.sendRedirect("citas-medicas?error=Error+al+eliminar+la+cita");
            }

        } catch (Exception e) {
            System.out.println("ERROR grave al eliminar cita: " + e.getMessage());
            response.sendRedirect("citas-medicas?error=Error+grave+al+eliminar+la+cita");
        }
    }

    private CitaMedica extraerCitaDeRequest(HttpServletRequest request) {
        CitaMedica cita = new CitaMedica();

        cita.setIdExpediente(Integer.parseInt(request.getParameter("idExpediente")));
        cita.setIdMedico(Integer.parseInt(request.getParameter("idMedico")));

        // Convertir fecha y hora del formulario
        String fechaHoraStr = request.getParameter("fechaHoraCita");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        cita.setFechaHoraCita(LocalDateTime.parse(fechaHoraStr, formatter));

        cita.setTipoCita(request.getParameter("tipoCita"));
        cita.setSintomas(request.getParameter("sintomas"));
        cita.setEstado(request.getParameter("estado"));
        cita.setObservaciones(request.getParameter("observaciones"));

        System.out.println("Cita extraída del formulario:");
        System.out.println("- Expediente: " + cita.getIdExpediente());
        System.out.println("- Médico: " + cita.getIdMedico());
        System.out.println("- Fecha: " + cita.getFechaHoraCita());
        System.out.println("- Tipo: " + cita.getTipoCita());
        System.out.println("- Estado: " + cita.getEstado());

        return cita;
    }
}