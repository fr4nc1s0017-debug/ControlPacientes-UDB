<%--
  Created by IntelliJ IDEA.
  User: kazut
  Date: 25/10/2025
  Time: 21:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.example.controlpacientesudb.modelo.entidades.Paciente" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    Paciente paciente = (Paciente) request.getAttribute("paciente");
    boolean esEdicion = paciente != null;
    String titulo = esEdicion ? "Editar Paciente" : "Registrar Nuevo Paciente";
    String actionUrl = esEdicion ? "pacientes?action=actualizar" : "pacientes?action=guardar";
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
            <p class="text-gray-600 mt-2">Complete la información del paciente</p>
        </div>

        <!-- Formulario -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <form action="<%= actionUrl %>" method="post" id="formPaciente">

                <% if (esEdicion) { %>
                <input type="hidden" name="idPaciente" value="<%= paciente.getIdPaciente() %>">
                <% } %>

                <!-- Información Personal -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- Nombre Completo -->
                    <div class="md:col-span-2">
                        <label for="nombreCompleto" class="block text-sm font-medium text-gray-700 mb-2">
                            Nombre Completo *
                        </label>
                        <input type="text" id="nombreCompleto" name="nombreCompleto" required
                               value="<%= esEdicion ? paciente.getNombreCompleto() : "" %>"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                               placeholder="Ej: María López García">
                    </div>

                    <!-- Fecha de Nacimiento -->
                    <div>
                        <label for="fechaNacimiento" class="block text-sm font-medium text-gray-700 mb-2">
                            Fecha de Nacimiento *
                        </label>
                        <input type="date" id="fechaNacimiento" name="fechaNacimiento" required
                               value="<%= esEdicion && paciente.getFechaNacimiento() != null ? paciente.getFechaNacimiento().toString() : "" %>"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                    </div>

                    <!-- Sexo -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Sexo *
                        </label>
                        <div class="flex space-x-6">
                            <label class="inline-flex items-center">
                                <input type="radio" name="sexo" value="Masculino" required
                                    <%= esEdicion && "Masculino".equals(paciente.getSexo()) ? "checked" : "" %>
                                       class="text-indigo-600 focus:ring-indigo-500">
                                <span class="ml-2">Masculino</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="radio" name="sexo" value="Femenino"
                                    <%= esEdicion && "Femenino".equals(paciente.getSexo()) ? "checked" : "" %>
                                       class="text-indigo-600 focus:ring-indigo-500">
                                <span class="ml-2">Femenino</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Información de Contacto -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- Teléfono -->
                    <div>
                        <label for="telefono" class="block text-sm font-medium text-gray-700 mb-2">
                            Teléfono
                        </label>
                        <input type="tel" id="telefono" name="telefono"
                               value="<%= esEdicion ? paciente.getTelefono() : "" %>"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                               placeholder="Ej: 7777-8888">
                    </div>

                    <!-- Email -->
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                            Email
                        </label>
                        <input type="email" id="email" name="email"
                               value="<%= esEdicion ? paciente.getEmail() : "" %>"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                               placeholder="Ej: paciente@email.com">
                    </div>
                </div>

                <!-- Dirección -->
                <div class="mb-8">
                    <label for="direccion" class="block text-sm font-medium text-gray-700 mb-2">
                        Dirección
                    </label>
                    <textarea id="direccion" name="direccion" rows="3"
                              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 resize-none"
                              placeholder="Ej: San Salvador, Colonia Escalón"><%= esEdicion ? paciente.getDireccion() : "" %></textarea>
                </div>

                <!-- Botones de Acción -->
                <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                    <a href="pacientes"
                       class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition duration-300 font-medium">
                        Cancelar
                    </a>
                    <button type="submit"
                            class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition duration-300 font-medium">
                        <%= esEdicion ? "Actualizar Paciente" : "Registrar Paciente" %>
                    </button>
                </div>
            </form>
        </div>

        <!-- Información Adicional -->
        <div class="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h3 class="text-sm font-medium text-blue-800 mb-2">📋 Información Importante</h3>
            <ul class="text-sm text-blue-700 space-y-1">
                <li>• Los campos marcados con * son obligatorios</li>
                <li>• La información del paciente se utilizará para el registro de citas médicas</li>
                <li>• Asegúrese de que los datos sean correctos antes de guardar</li>
            </ul>
        </div>
    </div>
</main>

<!-- JavaScript para Validación -->
<script>
    document.getElementById('formPaciente').addEventListener('submit', function(e) {
        const nombre = document.getElementById('nombreCompleto').value;
        const fechaNac = document.getElementById('fechaNacimiento').value;
        const sexo = document.querySelector('input[name="sexo"]:checked');

        // Validar campos requeridos
        if (!nombre.trim() || !fechaNac || !sexo) {
            e.preventDefault();
            alert('Por favor complete todos los campos obligatorios.');
            return false;
        }

        // Validar que la fecha no sea futura
        const fechaNacimiento = new Date(fechaNac);
        const hoy = new Date();
        if (fechaNacimiento > hoy) {
            e.preventDefault();
            alert('La fecha de nacimiento no puede ser futura.');
            return false;
        }

        return true;
    });
</script>

</body>
</html>