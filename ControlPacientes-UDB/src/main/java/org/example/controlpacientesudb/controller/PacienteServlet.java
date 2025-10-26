package org.example.controlpacientesudb.controller;

import org.example.controlpacientesudb.dao.PacienteMemoryDAO;
import org.example.controlpacientesudb.modelo.entidades.Paciente;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/pacientes")
public class PacienteServlet extends HttpServlet {

    private PacienteMemoryDAO pacienteDAO;

    @Override
    public void init() throws ServletException {
        pacienteDAO = new PacienteMemoryDAO();
        System.out.println("=== SERVLET DE PACIENTES INICIALIZADO ===");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");

        try {
            if (action == null) {
                listarPacientes(request, response);
            } else {
                switch (action) {
                    case "nuevo":
                        mostrarFormularioNuevoPaciente(request, response);
                        break;
                    case "editar":
                        mostrarFormularioEditarPaciente(request, response);
                        break;
                    case "eliminar":
                        eliminarPaciente(request, response);
                        break;
                    default:
                        listarPacientes(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            System.out.println("Error en PacienteServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("pacientes?error=Error+en+el+sistema");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("guardar".equals(action)) {
                guardarPaciente(request, response);
            } else if ("actualizar".equals(action)) {
                actualizarPaciente(request, response);
            } else {
                listarPacientes(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error procesando formulario: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("pacientes?error=Error+al+procesar+el+paciente");
        }
    }

    private void listarPacientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Paciente> listaPacientes = pacienteDAO.obtenerTodosPacientes();
        request.setAttribute("listaPacientes", listaPacientes);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/pacientes.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFormularioNuevoPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/formPaciente.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFormularioEditarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idPaciente = Integer.parseInt(request.getParameter("id"));
        Paciente paciente = pacienteDAO.obtenerPacientePorId(idPaciente);

        if (paciente != null) {
            request.setAttribute("paciente", paciente);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/formPaciente.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("pacientes?error=Paciente+no+encontrado");
        }
    }

    private void guardarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Paciente paciente = extraerPacienteDeRequest(request);
            boolean exito = pacienteDAO.insertarPaciente(paciente);

            if (exito) {
                response.sendRedirect("pacientes?success=Paciente+registrado+exitosamente");
            } else {
                response.sendRedirect("pacientes?error=Error+al+registrar+el+paciente");
            }
        } catch (Exception e) {
            response.sendRedirect("pacientes?error=Error+grave+al+registrar+el+paciente");
        }
    }

    private void actualizarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            Paciente paciente = extraerPacienteDeRequest(request);
            paciente.setIdPaciente(idPaciente);

            boolean exito = pacienteDAO.actualizarPaciente(paciente);

            if (exito) {
                response.sendRedirect("pacientes?success=Paciente+actualizado+exitosamente");
            } else {
                response.sendRedirect("pacientes?error=Error+al+actualizar+el+paciente");
            }
        } catch (Exception e) {
            response.sendRedirect("pacientes?error=Error+grave+al+actualizar+el+paciente");
        }
    }

    private void eliminarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idPaciente = Integer.parseInt(request.getParameter("id"));
            boolean exito = pacienteDAO.eliminarPaciente(idPaciente);

            if (exito) {
                response.sendRedirect("pacientes?success=Paciente+eliminado+exitosamente");
            } else {
                response.sendRedirect("pacientes?error=Error+al+eliminar+el+paciente");
            }
        } catch (Exception e) {
            response.sendRedirect("pacientes?error=Error+grave+al+eliminar+el+paciente");
        }
    }

    private Paciente extraerPacienteDeRequest(HttpServletRequest request) {
        Paciente paciente = new Paciente();

        paciente.setNombreCompleto(request.getParameter("nombreCompleto"));

        // Convertir fecha de nacimiento
        String fechaNacStr = request.getParameter("fechaNacimiento");
        if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            paciente.setFechaNacimiento(LocalDate.parse(fechaNacStr, formatter));
        }

        paciente.setSexo(request.getParameter("sexo"));
        paciente.setTelefono(request.getParameter("telefono"));
        paciente.setEmail(request.getParameter("email"));
        paciente.setDireccion(request.getParameter("direccion"));

        return paciente;
    }
}