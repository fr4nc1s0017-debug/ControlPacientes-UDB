<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.Visita" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.Paciente" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%
    // Configurar codificación UTF-8
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    List<Visita> listaVisitas = (List<Visita>) request.getAttribute("listaVisitas");
    List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
    Map<Integer, String> medicos = (Map<Integer, String>) request.getAttribute("medicos");

    if (listaVisitas == null) listaVisitas = new ArrayList<>();
    if (listaPacientes == null) listaPacientes = new ArrayList<>();
    if (medicos == null) {
        // Mapa por defecto si no se proporciona
        medicos = new java.util.HashMap<>();
        medicos.put(1, "Dr. Juan Pérez");
        medicos.put(2, "Dra. Ana Gómez");
        medicos.put(3, "Dr. Carlos Rodríguez");
        medicos.put(4, "Dra. María López");
        medicos.put(5, "Dr. Roberto Sánchez");
    }

    boolean filtrosAplicados = request.getAttribute("filtrosAplicados") != null ? (Boolean) request.getAttribute("filtrosAplicados") : false;
    String idPacienteFiltro = (String) request.getAttribute("idPacienteFiltro");
    String fechaDesdeFiltro = (String) request.getAttribute("fechaDesdeFiltro");
    String fechaHastaFiltro = (String) request.getAttribute("fechaHastaFiltro");
    String triageFiltro = (String) request.getAttribute("triageFiltro");
    if (triageFiltro == null) triageFiltro = "Todos";

    // Calcular estadísticas para el dashboard
    long totalVisitas = listaVisitas.size();
    long triageRojoNegro = listaVisitas.stream().filter(v -> "Rojo".equals(v.getTriage()) || "Negro".equals(v.getTriage())).count();
    long triageVerde = listaVisitas.stream().filter(v -> "Verde".equals(v.getTriage())).count();
    long triageAmarillo = listaVisitas.stream().filter(v -> "Amarillo".equals(v.getTriage())).count();

    // Crear mapa de pacientes para búsqueda rápida
    Map<Integer, String> mapaPacientes = new java.util.HashMap<>();
    for (Paciente paciente : listaPacientes) {
        mapaPacientes.put(paciente.getIdPaciente(), paciente.getNombreCompleto());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clínica - Reporte de Visitas</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html {
            font-family: 'Inter', sans-serif;
        }
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
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
            <a href="reporte-visitas" class="hover:text-indigo-200 font-semibold">Reportes</a>
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

<!-- Contenido Principal: Reporte de Visitas -->
<main class="container mx-auto p-6">
    <h2 class="text-3xl font-extrabold text-gray-800 mb-2">Reporte de Visitas Médicas</h2>
    <p class="text-gray-600 mb-8">Sistema de consulta y filtrado de visitas médicas registradas</p>

    <!-- Dashboard de Estadísticas -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <!-- Tarjeta 1: Total de Visitas -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-blue-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Total de Visitas</p>
            <p class="text-4xl font-bold text-gray-900 mt-1"><%= totalVisitas %></p>
            <span class="text-blue-500 text-xs font-medium">Registros encontrados</span>
        </div>

        <!-- Tarjeta 2: Triage Rojo/Negro -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-red-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Triage Rojo/Negro</p>
            <p class="text-4xl font-bold text-gray-900 mt-1"><%= triageRojoNegro %></p>
            <span class="text-red-500 text-xs font-medium">Urgencias críticas</span>
        </div>

        <!-- Tarjeta 3: Triage Verde -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-green-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Triage Verde</p>
            <p class="text-4xl font-bold text-gray-900 mt-1"><%= triageVerde %></p>
            <span class="text-green-500 text-xs font-medium">No urgentes</span>
        </div>

        <!-- Tarjeta 4: Triage Amarillo -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-yellow-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Triage Amarillo</p>
            <p class="text-4xl font-bold text-gray-900 mt-1"><%= triageAmarillo %></p>
            <span class="text-yellow-500 text-xs font-medium">Urgencias moderadas</span>
        </div>
    </div>

    <!-- Panel de Filtros -->
    <div class="bg-white p-6 rounded-xl shadow-lg mb-8">
        <h3 class="text-xl font-semibold text-gray-700 mb-4">🔍 Filtros de Búsqueda</h3>

        <form action="reporte-visitas" method="get" id="formFiltros">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <!-- Filtro por Paciente -->
                <div>
                    <label for="idPaciente" class="block text-sm font-medium text-gray-700 mb-1">
                        Paciente
                    </label>
                    <select id="idPaciente" name="idPaciente"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                        <option value="">Todos los pacientes</option>
                        <% for (Paciente paciente : listaPacientes) {
                            String selected = (idPacienteFiltro != null && idPacienteFiltro.equals(String.valueOf(paciente.getIdPaciente()))) ? "selected" : "";
                        %>
                        <option value="<%= paciente.getIdPaciente() %>" <%= selected %>>
                            <%= paciente.getNombreCompleto() %> (ID: <%= paciente.getIdPaciente() %>)
                        </option>
                        <% } %>
                    </select>
                </div>

                <!-- Filtro por Fecha Desde -->
                <div>
                    <label for="fechaDesde" class="block text-sm font-medium text-gray-700 mb-1">
                        Fecha Desde
                    </label>
                    <input type="date" id="fechaDesde" name="fechaDesde"
                           value="<%= fechaDesdeFiltro != null ? fechaDesdeFiltro : "" %>"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <!-- Filtro por Fecha Hasta -->
                <div>
                    <label for="fechaHasta" class="block text-sm font-medium text-gray-700 mb-1">
                        Fecha Hasta
                    </label>
                    <input type="date" id="fechaHasta" name="fechaHasta"
                           value="<%= fechaHastaFiltro != null ? fechaHastaFiltro : "" %>"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <!-- Filtro por Triage -->
                <div>
                    <label for="triage" class="block text-sm font-medium text-gray-700 mb-1">
                        Nivel de Triage
                    </label>
                    <select id="triage" name="triage"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                        <option value="Todos" <%= "Todos".equals(triageFiltro) ? "selected" : "" %>>Todos los niveles</option>
                        <option value="Verde" <%= "Verde".equals(triageFiltro) ? "selected" : "" %>>Verde</option>
                        <option value="Amarillo" <%= "Amarillo".equals(triageFiltro) ? "selected" : "" %>>Amarillo</option>
                        <option value="Rojo" <%= "Rojo".equals(triageFiltro) ? "selected" : "" %>>Rojo</option>
                        <option value="Negro" <%= "Negro".equals(triageFiltro) ? "selected" : "" %>>Negro</option>
                    </select>
                </div>
            </div>

            <!-- Botones de Filtro -->
            <div class="flex justify-between items-center mt-4 pt-4 border-t border-gray-200">
                <div>
                    <% if (filtrosAplicados && !listaVisitas.isEmpty()) { %>
                    <!-- Opciones de Descarga (solo se muestran cuando hay filtros aplicados y resultados) -->
                    <div class="flex space-x-2">
                        <span class="text-sm text-gray-600 font-medium mr-2">Descargar:</span>
                        <a href="descargar-reporte?formato=html<%= generarParametrosURL(idPacienteFiltro, fechaDesdeFiltro, fechaHastaFiltro, triageFiltro) %>"
                           class="px-3 py-1 bg-blue-600 text-white text-sm rounded hover:bg-blue-700 transition duration-200">
                            📄 HTML
                        </a>
                        <a href="descargar-reporte?formato=pdf<%= generarParametrosURL(idPacienteFiltro, fechaDesdeFiltro, fechaHastaFiltro, triageFiltro) %>"
                           class="px-3 py-1 bg-red-600 text-white text-sm rounded hover:bg-red-700 transition duration-200">
                            📊 PDF
                        </a>
                        <a href="descargar-reporte?formato=excel<%= generarParametrosURL(idPacienteFiltro, fechaDesdeFiltro, fechaHastaFiltro, triageFiltro) %>"
                           class="px-3 py-1 bg-green-600 text-white text-sm rounded hover:bg-green-700 transition duration-200">
                            📈 Excel
                        </a>
                    </div>
                    <% } %>
                </div>

                <div class="flex space-x-3">
                    <% if (filtrosAplicados) { %>
                    <a href="reporte-visitas"
                       class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition duration-300 font-medium">
                        🔄 Limpiar Filtros
                    </a>
                    <% } %>
                    <button type="submit"
                            class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition duration-300 font-medium">
                        🔍 Aplicar Filtros
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Mensaje inicial cuando no hay filtros aplicados -->
    <% if (!filtrosAplicados) { %>
    <div class="bg-white p-12 rounded-xl shadow-lg text-center">
        <div class="max-w-md mx-auto">
            <svg class="mx-auto h-16 w-16 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
            <h3 class="mt-4 text-xl font-semibold text-gray-900">Aplicar Filtros para Ver Resultados</h3>
            <p class="mt-2 text-gray-600">
                Selecciona los criterios de búsqueda en el panel de filtros para mostrar las visitas médicas registradas.
            </p>
            <p class="mt-1 text-sm text-gray-500">
                Puedes filtrar por paciente, fecha y nivel de triage.
            </p>
        </div>
    </div>
    <% } else { %>
    <!-- Tabla de Visitas (solo se muestra cuando hay filtros aplicados) -->
    <div class="bg-white p-6 rounded-xl shadow-lg overflow-x-auto fade-in">
        <div class="flex justify-between items-center mb-4">
            <h3 class="text-xl font-semibold text-gray-700">
                📊 Resultados de la Búsqueda
            </h3>
            <span class="text-sm text-gray-500">
                    Mostrando <%= listaVisitas.size() %> registros
                </span>
        </div>

        <% if (!listaVisitas.isEmpty()) { %>
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Paciente</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Hora</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Médico</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Triage</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Circunstancia</th>
            </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
            <% for (Visita visita : listaVisitas) {
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

                String badgeClass = "bg-gray-100 text-gray-800";
                if ("Rojo".equals(visita.getTriage())) {
                    badgeClass = "bg-red-100 text-red-800";
                } else if ("Amarillo".equals(visita.getTriage())) {
                    badgeClass = "bg-yellow-100 text-yellow-800";
                } else if ("Verde".equals(visita.getTriage())) {
                    badgeClass = "bg-green-100 text-green-800";
                } else if ("Negro".equals(visita.getTriage())) {
                    badgeClass = "bg-black text-white";
                }
            %>
            <tr class="hover:bg-gray-50 transition duration-150">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#<%= visita.getIdVisita() %></td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    <div>
                        <div class="font-medium"><%= nombrePaciente %></div>
                        <div class="text-xs text-gray-500">ID: <%= visita.getIdExpediente() %></div>
                    </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= visita.getSoloFecha() %></td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= visita.getSoloHora() %></td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                    <div class="font-medium"><%= nombreMedico %></div>
                    <div class="text-xs text-gray-500">ID: <%= visita.getIdMedico() %></div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm">
                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full <%= badgeClass %>">
                                <%= visita.getTriage() %>
                            </span>
                </td>
                <td class="px-6 py-4 text-sm text-gray-600 max-w-xs"><%= visita.getCircumstancia() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <!-- Mensaje cuando no hay resultados con los filtros aplicados -->
        <div class="text-center py-12">
            <svg class="mx-auto h-16 w-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <h3 class="mt-4 text-lg font-medium text-gray-900">No se encontraron visitas</h3>
            <p class="mt-2 text-gray-600">No hay registros que coincidan con los filtros aplicados.</p>
            <p class="mt-1 text-sm text-gray-500">Intenta ajustar los criterios de búsqueda.</p>
        </div>
        <% } %>
    </div>
    <% } %>
</main>

<!-- JavaScript para mejorar los filtros -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Validar que fecha hasta no sea menor que fecha desde
        const fechaDesde = document.getElementById('fechaDesde');
        const fechaHasta = document.getElementById('fechaHasta');

        function validarFechas() {
            if (fechaDesde.value && fechaHasta.value) {
                if (fechaHasta.value < fechaDesde.value) {
                    alert('La fecha "Hasta" no puede ser anterior a la fecha "Desde"');
                    fechaHasta.value = '';
                }
            }
        }

        fechaDesde.addEventListener('change', validarFechas);
        fechaHasta.addEventListener('change', validarFechas);

        // Auto-submit al cambiar algunos filtros
        document.getElementById('triage').addEventListener('change', function() {
            if (this.value !== 'Todos') {
                document.getElementById('formFiltros').submit();
            }
        });
    });
</script>

</body>
</html>

<%!
    // Método para generar parámetros URL para los enlaces de descarga
    private String generarParametrosURL(String idPaciente, String fechaDesde, String fechaHasta, String triage) {
        StringBuilder params = new StringBuilder();

        if (idPaciente != null && !idPaciente.isEmpty()) {
            params.append("&idPaciente=").append(idPaciente);
        }
        if (fechaDesde != null && !fechaDesde.isEmpty()) {
            params.append("&fechaDesde=").append(fechaDesde);
        }
        if (fechaHasta != null && !fechaHasta.isEmpty()) {
            params.append("&fechaHasta=").append(fechaHasta);
        }
        if (triage != null && !"Todos".equals(triage)) {
            params.append("&triage=").append(triage);
        }

        return params.toString();
    }
%>