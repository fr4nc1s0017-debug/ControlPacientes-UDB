<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLINICA - Sistema de Gestión Médica</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html {font-family: 'Inter', sans-serif;}
    </style>
</head>
<body class="bg-gray-100 min-h-screen">

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

<div class="bg-white p-6 rounded-xl shadow-lg mb-8">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Bienvenido, <%= session.getAttribute("username") %>! 👋</h1>
            <p class="text-gray-600 mt-1">Sistema integral de gestión de pacientes y citas médicas</p>
        </div>
        <div class="text-right">
            <p class="text-sm text-gray-500">Sesión activa</p>
            <p class="text-sm font-medium text-indigo-600">Administrador</p>
        </div>
    </div>
</div>

<!-- Contenido Principal del Dashboard -->
<main class="container mx-auto p-6">
    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Dashboard Principal</h1>
    <p class="text-gray-600 mb-8">Sistema integral de gestión de citas y pacientes</p>

    <!-- Grilla de Indicadores (KPIs) -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-10">
        <!-- Tarjeta 1: Citas del Día -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-blue-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Citas Hoy</p>
            <p class="text-4xl font-bold text-gray-900 mt-1">8</p>
            <span class="text-blue-500 text-xs font-medium">+2 vs Ayer</span>
        </div>

        <!-- Tarjeta 2: Citas Pendientes -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-yellow-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Citas Pendientes</p>
            <p class="text-4xl font-bold text-gray-900 mt-1">12</p>
            <span class="text-yellow-500 text-xs font-medium">Por confirmar</span>
        </div>

        <!-- Tarjeta 3: Pacientes Atendidos -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-green-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Pacientes Atendidos</p>
            <p class="text-4xl font-bold text-gray-900 mt-1">24</p>
            <span class="text-green-500 text-xs font-medium">Este mes</span>
        </div>

        <!-- Tarjeta 4: Médicos Activos -->
        <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-purple-500 hover:shadow-xl transition duration-300">
            <p class="text-sm font-medium text-gray-500">Médicos Activos</p>
            <p class="text-4xl font-bold text-gray-900 mt-1">5</p>
            <span class="text-purple-500 text-xs font-medium">En turno</span>
        </div>
    </div>

    <!-- Acciones Rápidas -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-10">
        <div class="bg-white p-6 rounded-xl shadow-lg">
            <h3 class="text-xl font-semibold text-gray-700 mb-4">Acciones Rápidas</h3>
            <div class="space-y-3">
                <a href="citas-medicas?action=nueva" class="block w-full bg-indigo-600 text-white text-center py-3 px-4 rounded-lg hover:bg-indigo-700 transition duration-300">
                    📅 Agendar Nueva Cita
                </a>
                <a href="citas-medicas" class="block w-full bg-green-600 text-white text-center py-3 px-4 rounded-lg hover:bg-green-700 transition duration-300">
                    👥 Ver Todas las Citas
                </a>
                <a href="reporte-visitas" class="block w-full bg-blue-600 text-white text-center py-3 px-4 rounded-lg hover:bg-blue-700 transition duration-300">
                    📊 Reportes de Visitas
                </a>
            </div>
        </div>

        <!-- Próximas Citas -->
        <div class="bg-white p-6 rounded-xl shadow-lg">
            <h3 class="text-xl font-semibold text-gray-700 mb-4">Próximas Citas</h3>
            <div class="space-y-3">
                <div class="flex justify-between items-center p-3 bg-blue-50 rounded-lg">
                    <div>
                        <p class="font-medium">Dr. Juan Pérez</p>
                        <p class="text-sm text-gray-600">10:00 AM - María López</p>
                    </div>
                    <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Confirmada</span>
                </div>
                <div class="flex justify-between items-center p-3 bg-yellow-50 rounded-lg">
                    <div>
                        <p class="font-medium">Dra. Ana Gómez</p>
                        <p class="text-sm text-gray-600">11:30 AM - Carlos Ruiz</p>
                    </div>
                    <span class="px-2 py-1 bg-yellow-100 text-yellow-800 text-xs rounded-full">Pendiente</span>
                </div>
                <div class="flex justify-between items-center p-3 bg-blue-50 rounded-lg">
                    <div>
                        <p class="font-medium">Dr. Carlos Rodríguez</p>
                        <p class="text-sm text-gray-600">02:15 PM - Laura Martínez</p>
                    </div>
                    <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Confirmada</span>
                </div>
            </div>
        </div>
    </div>
</main>

</body>
</html>