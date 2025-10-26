<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.CitaMedica" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.Paciente" %>
<%@ page import="java.util.ArrayList" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    List<CitaMedica> listaCitas = (List<CitaMedica>) request.getAttribute("listaCitas");
    List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
    if (listaCitas == null) listaCitas = new ArrayList<>();
    if (listaPacientes == null) listaPacientes = new ArrayList<>();

    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
    String fuenteDatos = (String) request.getAttribute("fuenteDatos");
    if (fuenteDatos == null) fuenteDatos = "memoria temporal";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Citas Médicas</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Barra de Navegacion -->
<nav class="bg-indigo-700 p-4 text-white shadow-lg">
    <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-2xl font-bold">Sistema de Gestión Médica</h1>
        <div class="space-x-4">
            <a href="dashboard" class="hover:text-indigo-200">Inicio</a>
            <a href="pacientes" class="hover:text-indigo-200">Pacientes</a>
            <a href="citas-medicas" class="hover:text-indigo-200 font-semibold">Citas Médicas</a>
            <a href="reporte-visitas" class="hover:text-indigo-200">Reportes</a>
        </div>
    </div>
</nav>

<!-- Contenido Principal -->
<main class="container mx-auto p-6">
    <!-- Alerta de Sistema Temporal -->
    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-6">
        <div class="flex">
            <div class="flex-shrink-0">
                <svg class="h-5 w-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                </svg>
            </div>
            <div class="ml-3">
                <h3 class="text-sm font-medium text-yellow-800">
                    Sistema de Almacenamiento Temporal
                </h3>
                <div class="mt-2 text-sm text-yellow-700">
                    <p>
                        Los datos se almacenan en memoria y se perderán cuando se reinicie la aplicación.
                        <strong>Esta es una versión de prueba.</strong>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Header con Botón -->
    <div class="flex justify-between items-center mb-6">
        <div>
            <h1 class="text-3xl font-extrabold text-gray-800">Gestión de Citas Médicas</h1>
            <p class="text-gray-600">Administre las citas médicas del sistema</p>
        </div>
        <a href="citas-medicas?action=nueva"
           class="bg-indigo-600 text-white px-6 py-3 rounded-lg hover:bg-indigo-700 transition duration-300 font-medium">
            ➕ Agendar Nueva Cita
        </a>
    </div>

    <!-- Mensajes de éxito -->
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
        ✅ <%= successMessage %>
    </div>
    <% } %>

    <!-- Mensajes de error -->
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
        ❌ <%= errorMessage %>
    </div>
    <% } %>

    <!-- Información del sistema -->
    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
        <div class="flex items-center">
            <div class="flex-shrink-0">
                <svg class="h-5 w-5 text-blue-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
                </svg>
            </div>
            <div class="ml-3">
                <p class="text-sm text-blue-700">
                    Sistema funcionando con: <strong><%= fuenteDatos %></strong> |
                    Total de citas: <strong><%= listaCitas.size() %></strong> |
                    Pacientes registrados: <strong><%= listaPacientes.size() %></strong>
                </p>
            </div>
        </div>
    </div>

    <!-- Tabla de Citas -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Paciente</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Médico</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha y Hora</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tipo</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <% if (!listaCitas.isEmpty()) {
                    for (CitaMedica cita : listaCitas) {
                        // Buscar el paciente correspondiente
                        String nombrePaciente = "Paciente no encontrado";
                        for (Paciente paciente : listaPacientes) {
                            if (paciente.getIdPaciente() == cita.getIdExpediente()) {
                                nombrePaciente = paciente.getNombreCompleto();
                                break;
                            }
                        }

                        String nombreMedico = "Médico " + cita.getIdMedico();
                        String fechaFormateada = cita.getFechaHoraCita() != null ?
                                cita.getFechaHoraCita().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "";

                        // Determinar clase CSS para el estado
                        String badgeClass = "bg-gray-100 text-gray-800";
                        if ("Pendiente".equals(cita.getEstado())) {
                            badgeClass = "bg-yellow-100 text-yellow-800";
                        } else if ("Confirmada".equals(cita.getEstado())) {
                            badgeClass = "bg-green-100 text-green-800";
                        } else if ("Cancelada".equals(cita.getEstado())) {
                            badgeClass = "bg-red-100 text-red-800";
                        } else if ("Completada".equals(cita.getEstado())) {
                            badgeClass = "bg-blue-100 text-blue-800";
                        }
                %>
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#<%= cita.getIdCita() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        <div>
                            <div class="font-medium"><%= nombrePaciente %></div>
                            <div class="text-xs text-gray-500">ID: <%= cita.getIdExpediente() %></div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= nombreMedico %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= fechaFormateada %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= cita.getTipoCita() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= badgeClass %>">
                                    <%= cita.getEstado() %>
                                </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <a href="citas-medicas?action=editar&id=<%= cita.getIdCita() %>"
                           class="text-indigo-600 hover:text-indigo-900 mr-3">✏️ Editar</a>
                        <a href="citas-medicas?action=eliminar&id=<%= cita.getIdCita() %>"
                           class="text-red-600 hover:text-red-900"
                           onclick="return confirm('¿Está seguro de eliminar esta cita?')">🗑️ Eliminar</a>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="7" class="px-6 py-8 text-center">
                        <div class="text-gray-500">
                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                            <h3 class="mt-2 text-sm font-medium text-gray-900">No hay citas médicas registradas</h3>
                            <p class="mt-1 text-sm text-gray-500">
                                <% if (listaPacientes.isEmpty()) { %>
                                Primero debe registrar pacientes en el sistema.
                                <% } else { %>
                                Comience agendando una nueva cita médica.
                                <% } %>
                            </p>
                            <div class="mt-6">
                                <% if (listaPacientes.isEmpty()) { %>
                                <a href="pacientes?action=nuevo" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700">
                                    👥 Registrar primer paciente
                                </a>
                                <% } else { %>
                                <a href="citas-medicas?action=nueva" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700">
                                    ➕ Agendar primera cita
                                </a>
                                <% } %>
                            </div>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

</body>
</html>