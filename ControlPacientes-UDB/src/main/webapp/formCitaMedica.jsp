<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.CitaMedica" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.Paciente" %>
<%@ page import="java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    CitaMedica cita = (CitaMedica) request.getAttribute("cita");
    List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
    if (listaPacientes == null) listaPacientes = new java.util.ArrayList<>();

    boolean esEdicion = cita != null;
    String titulo = esEdicion ? "Editar Cita Médica" : "Agendar Nueva Cita Médica";
    String actionUrl = esEdicion ? "citas-medicas?action=actualizar" : "citas-medicas?action=guardar";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= titulo %></title>
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
        <div class="flex items-center space-x-4">
            <a href="dashboard" class="hover:text-indigo-200">Inicio</a>
            <a href="pacientes" class="hover:text-indigo-200">Pacientes</a>
            <a href="citas-medicas" class="hover:text-indigo-200">Citas Médicas</a>
            <a href="reporte-visitas" class="hover:text-indigo-200">Reportes</a>
            <span class="text-indigo-200">|</span>
            <span class="text-sm text-indigo-200">
                👤 <%= session.getAttribute("username") %>
            </span>
            <a href="logout" class="text-sm bg-red-600 hover:bg-red-700 px-3 py-1 rounded transition duration-200">
                🚪 Salir
            </a>
        </div>
    </div>
</nav>

<!-- Contenido Principal -->
<main class="container mx-auto p-6">
    <div class="max-w-4xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-extrabold text-gray-800"><%= titulo %></h1>
            <p class="text-gray-600 mt-2">Complete la información requerida para <%= esEdicion ? "actualizar" : "agendar" %> la cita médica</p>
        </div>

        <!-- Formulario -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <form action="<%= actionUrl %>" method="post" id="formCita">

                <% if (esEdicion) { %>
                <input type="hidden" name="idCita" value="<%= cita.getIdCita() %>">
                <% } %>

                <!-- Datos Básicos -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- Paciente -->
                    <div>
                        <label for="idExpediente" class="block text-sm font-medium text-gray-700 mb-2">
                            Paciente *
                        </label>
                        <select id="idExpediente" name="idExpediente" required
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                            <option value="">Seleccione un paciente</option>
                            <% for (Paciente paciente : listaPacientes) {
                                String selected = (esEdicion && cita.getIdExpediente() == paciente.getIdPaciente()) ? "selected" : "";
                            %>
                            <option value="<%= paciente.getIdPaciente() %>" <%= selected %>>
                                #<%= paciente.getIdPaciente() %> - <%= paciente.getNombreCompleto() %> (<%= paciente.getEdad() %> años)
                            </option>
                            <% } %>
                        </select>
                        <% if (listaPacientes.isEmpty()) { %>
                        <p class="text-red-500 text-sm mt-1">
                            No hay pacientes registrados.
                            <a href="pacientes?action=nuevo" class="text-indigo-600 hover:text-indigo-800">Registre un paciente primero</a>
                        </p>
                        <% } %>
                    </div>

                    <!-- Médico -->
                    <div>
                        <label for="idMedico" class="block text-sm font-medium text-gray-700 mb-2">
                            Médico Asignado *
                        </label>
                        <select id="idMedico" name="idMedico" required
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                            <option value="">Seleccione un médico</option>
                            <option value="1" <%= (esEdicion && cita.getIdMedico() == 1) ? "selected" : "" %>>Dr. Juan Pérez - Medicina General</option>
                            <option value="2" <%= (esEdicion && cita.getIdMedico() == 2) ? "selected" : "" %>>Dra. Ana Gómez - Pediatría</option>
                            <option value="3" <%= (esEdicion && cita.getIdMedico() == 3) ? "selected" : "" %>>Dr. Carlos Rodríguez - Cardiología</option>
                            <option value="4" <%= (esEdicion && cita.getIdMedico() == 4) ? "selected" : "" %>>Dra. Marta Hernández - Ginecología</option>
                        </select>
                    </div>
                </div>

                <!-- Fecha y Hora -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- Fecha y Hora -->
                    <div>
                        <label for="fechaHoraCita" class="block text-sm font-medium text-gray-700 mb-2">
                            Fecha y Hora de la Cita *
                        </label>
                        <input type="datetime-local" id="fechaHoraCita" name="fechaHoraCita" required
                               value="<%= esEdicion && cita.getFechaHoraCita() != null ?
                                       cita.getFechaHoraCita().toString().substring(0, 16) : "" %>"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                               min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(new java.util.Date()) %>">
                    </div>

                    <!-- Tipo de Cita -->
                    <div>
                        <label for="tipoCita" class="block text-sm font-medium text-gray-700 mb-2">
                            Tipo de Cita *
                        </label>
                        <select id="tipoCita" name="tipoCita" required
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                            <option value="">Seleccione el tipo</option>
                            <option value="Consulta General" <%= (esEdicion && "Consulta General".equals(cita.getTipoCita())) ? "selected" : "" %>>Consulta General</option>
                            <option value="Control" <%= (esEdicion && "Control".equals(cita.getTipoCita())) ? "selected" : "" %>>Control</option>
                            <option value="Emergencia" <%= (esEdicion && "Emergencia".equals(cita.getTipoCita())) ? "selected" : "" %>>Emergencia</option>
                            <option value="Examen Médico" <%= (esEdicion && "Examen Médico".equals(cita.getTipoCita())) ? "selected" : "" %>>Examen Médico</option>
                            <option value="Vacunación" <%= (esEdicion && "Vacunación".equals(cita.getTipoCita())) ? "selected" : "" %>>Vacunación</option>
                            <option value="Cirugía Menor" <%= (esEdicion && "Cirugía Menor".equals(cita.getTipoCita())) ? "selected" : "" %>>Cirugía Menor</option>
                        </select>
                    </div>
                </div>

                <!-- Estado -->
                <div class="mb-6">
                    <label for="estado" class="block text-sm font-medium text-gray-700 mb-2">
                        Estado de la Cita *
                    </label>
                    <select id="estado" name="estado" required
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                        <option value="">Seleccione el estado</option>
                        <option value="Pendiente" <%= (esEdicion && "Pendiente".equals(cita.getEstado())) ? "selected" : "" %>>Pendiente</option>
                        <option value="Confirmada" <%= (esEdicion && "Confirmada".equals(cita.getEstado())) ? "selected" : "" %>>Confirmada</option>
                        <option value="Cancelada" <%= (esEdicion && "Cancelada".equals(cita.getEstado())) ? "selected" : "" %>>Cancelada</option>
                        <option value="Completada" <%= (esEdicion && "Completada".equals(cita.getEstado())) ? "selected" : "" %>>Completada</option>
                    </select>
                </div>

                <!-- Síntomas -->
                <div class="mb-6">
                    <label for="sintomas" class="block text-sm font-medium text-gray-700 mb-2">
                        Síntomas o Motivo de Consulta
                    </label>
                    <textarea id="sintomas" name="sintomas" rows="3"
                              placeholder="Describa los síntomas o motivo de la consulta..."
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 resize-none"><%= esEdicion && cita.getSintomas() != null ? cita.getSintomas() : "" %></textarea>
                </div>

                <!-- Observaciones -->
                <div class="mb-8">
                    <label for="observaciones" class="block text-sm font-medium text-gray-700 mb-2">
                        Observaciones Adicionales
                    </label>
                    <textarea id="observaciones" name="observaciones" rows="3"
                              placeholder="Observaciones adicionales o notas importantes..."
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 resize-none"><%= esEdicion && cita.getObservaciones() != null ? cita.getObservaciones() : "" %></textarea>
                </div>

                <!-- Botones de Acción -->
                <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                    <a href="citas-medicas"
                       class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition duration-300 font-medium">
                        Cancelar
                    </a>
                    <button type="submit"
                            class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition duration-300 font-medium">
                        <%= esEdicion ? "Actualizar Cita" : "Agendar Cita" %>
                    </button>
                </div>
            </form>
        </div>

        <!-- Información Adicional -->
        <div class="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h3 class="text-sm font-medium text-blue-800 mb-2">📋 Información Importante</h3>
            <ul class="text-sm text-blue-700 space-y-1">
                <li>• Los campos marcados con * son obligatorios</li>
                <li>• Las citas deben agendarse con al menos 1 hora de anticipación</li>
                <li>• El paciente debe presentarse 15 minutos antes de la cita</li>
                <li>• Para cancelaciones, contactar con al menos 2 horas de anticipación</li>
            </ul>
        </div>
    </div>
</main>

<!-- JavaScript para Validación -->
<script>
    document.getElementById('formCita').addEventListener('submit', function(e) {
        const fechaHora = document.getElementById('fechaHoraCita').value;
        const ahora = new Date();
        const fechaCita = new Date(fechaHora);

        if (fechaCita <= ahora) {
            e.preventDefault();
            alert('La fecha y hora de la cita debe ser futura.');
            return false;
        }

        // Validar que todos los campos requeridos estén llenos
        const camposRequeridos = this.querySelectorAll('[required]');
        let valido = true;

        camposRequeridos.forEach(campo => {
            if (!campo.value.trim()) {
                valido = false;
                campo.classList.add('border-red-500');
            } else {
                campo.classList.remove('border-red-500');
            }
        });

        if (!valido) {
            e.preventDefault();
            alert('Por favor complete todos los campos obligatorios.');
            return false;
        }
    });

    // Remover clase de error cuando el usuario empiece a escribir
    document.querySelectorAll('input, select, textarea').forEach(element => {
        element.addEventListener('input', function() {
            this.classList.remove('border-red-500');
        });
    });
</script>

</body>
</html>