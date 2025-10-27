<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    Integer totalPacientes = (Integer) request.getAttribute("totalPacientes");
    Integer totalCitas = (Integer) request.getAttribute("totalCitas");
    Integer totalVisitas = (Integer) request.getAttribute("totalVisitas");
    if (totalPacientes == null) totalPacientes = 0;
    if (totalCitas == null) totalCitas = 0;
    if (totalVisitas == null) totalVisitas = 0;

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes del Sistema</title>
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
            <a href="reportes" class="hover:text-indigo-200 font-semibold">Reportes</a>
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
    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-extrabold text-gray-800">📊 Reportes del Sistema</h1>
        <p class="text-gray-600 mt-2">Genere reportes detallados en diferentes formatos</p>
    </div>

    <!-- Mensajes -->
    <% if (error != null && !error.isEmpty()) { %>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
        ❌ <%= error %>
    </div>
    <% } %>

    <% if (success != null && !success.isEmpty()) { %>
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
        ✅ <%= success %>
    </div>
    <% } %>

    <!-- Estadísticas Rápidas -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-blue-500">
            <div class="flex items-center">
                <div class="bg-blue-100 p-3 rounded-lg">
                    <span class="text-2xl">👥</span>
                </div>
                <div class="ml-4">
                    <p class="text-sm font-medium text-gray-500">Pacientes Registrados</p>
                    <p class="text-3xl font-bold text-gray-900"><%= totalPacientes %></p>
                </div>
            </div>
        </div>

        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-green-500">
            <div class="flex items-center">
                <div class="bg-green-100 p-3 rounded-lg">
                    <span class="text-2xl">📅</span>
                </div>
                <div class="ml-4">
                    <p class="text-sm font-medium text-gray-500">Citas Médicas</p>
                    <p class="text-3xl font-bold text-gray-900"><%= totalCitas %></p>
                </div>
            </div>
        </div>

        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-red-500">
            <div class="flex items-center">
                <div class="bg-red-100 p-3 rounded-lg">
                    <span class="text-2xl">🏥</span>
                </div>
                <div class="ml-4">
                    <p class="text-sm font-medium text-gray-500">Visitas Registradas</p>
                    <p class="text-3xl font-bold text-gray-900"><%= totalVisitas %></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Panel de Generación de Reportes -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
        <h2 class="text-2xl font-bold text-gray-800 mb-6">🔄 Generar Reportes</h2>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- Reporte de Pacientes -->
            <div class="border border-gray-200 rounded-lg p-6 text-center hover:shadow-md transition duration-200">
                <div class="text-4xl mb-4">👥</div>
                <h3 class="text-lg font-semibold text-gray-800 mb-2">Reporte de Pacientes</h3>
                <p class="text-sm text-gray-600 mb-4">Listado completo de pacientes registrados</p>
                <div class="space-y-2">
                    <a href="reportes?action=generar&tipo=pacientes&formato=html"
                       class="block w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition duration-200 text-sm">
                        📄 Ver HTML
                    </a>
                    <a href="reportes?action=generar&tipo=pacientes&formato=pdf"
                       class="block w-full bg-red-600 text-white py-2 px-4 rounded hover:bg-red-700 transition duration-200 text-sm">
                        📊 Descargar PDF
                    </a>
                </div>
            </div>

            <!-- Reporte de Citas -->
            <div class="border border-gray-200 rounded-lg p-6 text-center hover:shadow-md transition duration-200">
                <div class="text-4xl mb-4">📅</div>
                <h3 class="text-lg font-semibold text-gray-800 mb-2">Reporte de Citas</h3>
                <p class="text-sm text-gray-600 mb-4">Citas médicas programadas y su estado</p>
                <div class="space-y-2">
                    <a href="reportes?action=generar&tipo=citas&formato=html"
                       class="block w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition duration-200 text-sm">
                        📄 Ver HTML
                    </a>
                    <a href="reportes?action=generar&tipo=citas&formato=pdf"
                       class="block w-full bg-red-600 text-white py-2 px-4 rounded hover:bg-red-700 transition duration-200 text-sm">
                        📊 Descargar PDF
                    </a>
                </div>
            </div>

            <!-- Reporte de Visitas -->
            <div class="border border-gray-200 rounded-lg p-6 text-center hover:shadow-md transition duration-200">
                <div class="text-4xl mb-4">🏥</div>
                <h3 class="text-lg font-semibold text-gray-800 mb-2">Reporte de Visitas</h3>
                <p class="text-sm text-gray-600 mb-4">Visitas médicas realizadas con triage</p>
                <div class="space-y-2">
                    <a href="reportes?action=generar&tipo=visitas&formato=html"
                       class="block w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition duration-200 text-sm">
                        📄 Ver HTML
                    </a>
                    <a href="reportes?action=generar&tipo=visitas&formato=pdf"
                       class="block w-full bg-red-600 text-white py-2 px-4 rounded hover:bg-red-700 transition duration-200 text-sm">
                        📊 Descargar PDF
                    </a>
                </div>
            </div>

            <!-- Reporte Estadístico -->
            <div class="border border-gray-200 rounded-lg p-6 text-center hover:shadow-md transition duration-200">
                <div class="text-4xl mb-4">📈</div>
                <h3 class="text-lg font-semibold text-gray-800 mb-2">Reporte Estadístico</h3>
                <p class="text-sm text-gray-600 mb-4">Estadísticas generales del sistema</p>
                <div class="space-y-2">
                    <a href="reportes?action=generar&tipo=estadisticas&formato=html"
                       class="block w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition duration-200 text-sm">
                        📄 Ver HTML
                    </a>
                    <a href="reportes?action=generar&tipo=estadisticas&formato=pdf"
                       class="block w-full bg-red-600 text-white py-2 px-4 rounded hover:bg-red-700 transition duration-200 text-sm">
                        📊 Descargar PDF
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Información sobre Reportes -->
    <div class="bg-blue-50 border border-blue-200 rounded-lg p-6">
        <h3 class="text-lg font-semibold text-blue-800 mb-3">ℹ️ Acerca de los Reportes</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-blue-700">
            <div>
                <h4 class="font-medium mb-1">📄 Formato HTML</h4>
                <p>Visualización rápida en el navegador, ideal para previsualización.</p>
            </div>
            <div>
                <h4 class="font-medium mb-1">📊 Formato PDF</h4>
                <p>Documento listo para imprimir o compartir, con formato profesional.</p>
            </div>
        </div>
    </div>
</main>

</body>
</html>