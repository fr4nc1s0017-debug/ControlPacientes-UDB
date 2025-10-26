<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema Médico - Iniciar Sesión</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html {font-family: 'Inter', sans-serif;}
        body {background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);}
    </style>
</head>
<body class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
<div class="max-w-md w-full space-y-8">
    <!-- Card de Login -->
    <div class="bg-white rounded-2xl shadow-2xl p-8">
        <!-- Header -->
        <div class="text-center">
            <div class="mx-auto h-16 w-16 bg-indigo-600 rounded-full flex items-center justify-center">
                <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                </svg>
            </div>
            <h2 class="mt-6 text-3xl font-extrabold text-gray-900">
                Sistema Médico
            </h2>
            <p class="mt-2 text-sm text-gray-600">
                Ingrese sus credenciales para acceder al sistema
            </p>
        </div>

        <!-- Formulario de Login -->
        <form class="mt-8 space-y-6" action="login" method="post">
            <!-- Mensajes de Error -->
            <% if (error != null && !error.isEmpty()) { %>
            <div class="bg-red-50 border border-red-200 rounded-lg p-4">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-red-700"><%= error %></p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Campos del Formulario -->
            <div class="space-y-4">
                <!-- Usuario -->
                <div>
                    <label for="username" class="block text-sm font-medium text-gray-700 mb-1">
                        Usuario
                    </label>
                    <input id="username" name="username" type="text" required
                           class="appearance-none relative block w-full px-3 py-3 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 transition duration-200"
                           placeholder="Ingrese su usuario"
                           value="admin">
                </div>

                <!-- Contraseña -->
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">
                        Contraseña
                    </label>
                    <input id="password" name="password" type="password" required
                           class="appearance-none relative block w-full px-3 py-3 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 transition duration-200"
                           placeholder="Ingrese su contraseña"
                           value="1234">
                </div>
            </div>

            <!-- Botón de Login -->
            <div>
                <button type="submit"
                        class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-lg text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition duration-200 transform hover:scale-105">
                        <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                            <svg class="h-5 w-5 text-indigo-500 group-hover:text-indigo-400" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/>
                            </svg>
                        </span>
                    Iniciar Sesión
                </button>
            </div>

            <!-- Información de Credenciales -->
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <h3 class="text-sm font-medium text-blue-800 mb-2">🔐 Credenciales de Prueba</h3>
                <div class="text-sm text-blue-700 space-y-1">
                    <div><strong>Usuario:</strong> admin</div>
                    <div><strong>Contraseña:</strong> 1234</div>
                </div>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <div class="text-center">
        <p class="text-white text-sm">
            Sistema de Gestión Médica &copy; 2024
        </p>
    </div>
</div>

<!-- JavaScript para mejor UX -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const username = document.getElementById('username');
        const password = document.getElementById('password');

        // Auto-focus en el campo de usuario
        username.focus();

        // Validación en tiempo real
        form.addEventListener('submit', function(e) {
            if (!username.value.trim() || !password.value.trim()) {
                e.preventDefault();
                alert('Por favor complete todos los campos.');
                return false;
            }
        });

        // Limpiar errores al escribir
        [username, password].forEach(input => {
            input.addEventListener('input', function() {
                const errorDiv = document.querySelector('.bg-red-50');
                if (errorDiv) {
                    errorDiv.style.display = 'none';
                }
            });
        });
    });
</script>
</body>
</html>