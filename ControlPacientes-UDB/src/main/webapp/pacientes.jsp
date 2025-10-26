<%--
  Created by IntelliJ IDEA.
  User: kazut
  Date: 25/10/2025
  Time: 21:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.Paciente" %>
<%@ page import="java.util.ArrayList" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
    if (listaPacientes == null) listaPacientes = new ArrayList<>();

    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Pacientes</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Barra de Navegacion Actualizada -->
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
    <!-- Header -->
    <div class="flex justify-between items-center mb-6">
        <div>
            <h1 class="text-3xl font-extrabold text-gray-800">Gestión de Pacientes</h1>
            <p class="text-gray-600">Administre el registro de pacientes del sistema</p>
        </div>
        <a href="pacientes?action=nuevo"
           class="bg-indigo-600 text-white px-6 py-3 rounded-lg hover:bg-indigo-700 transition duration-300 font-medium">
            👥 Registrar Nuevo Paciente
        </a>
    </div>

    <!-- Mensajes -->
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
        ✅ <%= successMessage %>
    </div>
    <% } %>

    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
        ❌ <%= errorMessage %>
    </div>
    <% } %>

    <!-- Tabla de Pacientes -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre Completo</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Edad</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Sexo</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Teléfono</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <% if (!listaPacientes.isEmpty()) {
                    for (Paciente paciente : listaPacientes) { %>
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#<%= paciente.getIdPaciente() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium"><%= paciente.getNombreCompleto() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= paciente.getEdad() %> años</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                                    <%= "Masculino".equals(paciente.getSexo()) ? "bg-blue-100 text-blue-800" : "bg-pink-100 text-pink-800" %>">
                                    <%= paciente.getSexo() %>
                                </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= paciente.getTelefono() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= paciente.getEmail() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <a href="pacientes?action=editar&id=<%= paciente.getIdPaciente() %>"
                           class="text-indigo-600 hover:text-indigo-900 mr-3">✏️ Editar</a>
                        <a href="pacientes?action=eliminar&id=<%= paciente.getIdPaciente() %>"
                           class="text-red-600 hover:text-red-900"
                           onclick="return confirm('¿Está seguro de eliminar este paciente?')">🗑️ Eliminar</a>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="7" class="px-6 py-8 text-center">
                        <div class="text-gray-500">
                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
                            </svg>
                            <h3 class="mt-2 text-sm font-medium text-gray-900">No hay pacientes registrados</h3>
                            <p class="mt-1 text-sm text-gray-500">Comience registrando un nuevo paciente.</p>
                            <div class="mt-6">
                                <a href="pacientes?action=nuevo" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700">
                                    👥 Registrar primer paciente
                                </a>
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