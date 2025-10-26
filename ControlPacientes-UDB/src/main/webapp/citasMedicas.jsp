<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.CitaMedica" %>
<%
    List<CitaMedica> listaCitas = (List<CitaMedica>) request.getAttribute("listaCitas");
    String successMessage = request.getParameter("success");
%>
<html>
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
            <a href="citas-medicas" class="hover:text-indigo-200 font-semibold">Citas Médicas</a>
            <a href="reporte-visitas" class="hover:text-indigo-200">Reporte de Visitas</a>
            <a href="#" class="hover:text-indigo-200">Pacientes</a>
        </div>
    </div>
</nav>

<!-- Contenido Principal -->
<main class="container mx-auto p-6">
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
        <%= successMessage %>
    </div>
    <% } %>

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
                <% if (listaCitas != null && !listaCitas.isEmpty()) {
                    for (CitaMedica cita : listaCitas) { %>
                <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= cita.getIdCita() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">Exp. <%= cita.getIdExpediente() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">Médico <%= cita.getIdMedico() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= cita.getFechaHoraCita() != null ? cita.getFechaHoraCita().toString() : "" %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= cita.getTipoCita() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                        <%
                            String estado = cita.getEstado();
                            String badgeClass = "bg-gray-100 text-gray-800";
                            if ("Pendiente".equals(estado)) {
                                badgeClass = "bg-yellow-100 text-yellow-800";
                            } else if ("Confirmada".equals(estado)) {
                                badgeClass = "bg-green-100 text-green-800";
                            } else if ("Cancelada".equals(estado)) {
                                badgeClass = "bg-red-100 text-red-800";
                            } else if ("Completada".equals(estado)) {
                                badgeClass = "bg-blue-100 text-blue-800";
                            }
                        %>
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= badgeClass %>">
                                    <%= estado %>
                                </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <a href="citas-medicas?action=editar&id=<%= cita.getIdCita() %>" class="text-indigo-600 hover:text-indigo-900 mr-3">Editar</a>
                        <a href="citas-medicas?action=eliminar&id=<%= cita.getIdCita() %>"
                           class="text-red-600 hover:text-red-900"
                           onclick="return confirm('¿Está seguro de eliminar esta cita?')">Eliminar</a>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">
                        No hay citas médicas registradas.
                        <a href="citas-medicas?action=nueva" class="text-indigo-600 hover:text-indigo-800 ml-2">
                            Agregar la primera cita
                        </a>
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