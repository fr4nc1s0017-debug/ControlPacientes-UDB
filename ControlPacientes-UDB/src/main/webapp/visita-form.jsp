<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Visita - Clínica</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Barra de Navegacion -->
<nav class="bg-indigo-700 p-4 text-white shadow-lg">
    <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-2x1 font-bold">Control de Pacientes</h1>
        <div class="space-x-4">
            <a href="dashboard.jsp" class="hover:text-indigo-200 font-semibold">Dashboard</a>
            <a href="reporteVisitas.jsp" class="hover:text-indigo-200">Reporte de Visitas</a>
            <a href="#" class="hover:text-indigo-200">Agenda Médica</a>
            <a href="#" class="hover:text-indigo-200">Recepción</a>
        </div>
    </div>
</nav>
<!-- Contenido Principal -->
<main class="container mx-auto p-6">
    <div class="bg-white rounded-xl shadow-lg p-6">

        <!-- Título -->
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800">Nueva Visita Médica</h1>
            <a href="visitas?accion=listar"
               class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-lg transition duration-300">
                ← Volver a Lista
            </a>
        </div>

        <!-- Formulario -->
        <form action="visitas" method="post" class="space-y-6">
            <input type="hidden" name="accion" value="guardar">

            <!-- Sección 1: Selección de Paciente y Médico -->
            <div class="border-l-4 border-indigo-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Información de la Visita</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Selector de Expediente -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Paciente *</label>
                        <select name="idExpediente"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                                required>
                            <option value="">Seleccionar paciente...</option>
                            <c:forEach var="expediente" items="${expedientes}">
                                <option value="${expediente.idExpediente}">
                                        ${expediente.nombre} - ${expediente.numeroDocumento}
                                </option>
                            </c:forEach>
                        </select>
                        <p class="text-xs text-gray-500 mt-1">Busque al paciente por nombre o documento</p>
                    </div>

                    <!-- Selector de Médico -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Médico Asignado *</label>
                        <select name="idMedico"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                                required>
                            <option value="">Seleccionar médico...</option>
                            <c:forEach var="medico" items="${medicos}">
                                <option value="${medico.idMedico}">
                                        ${medico.nombre}
                                </option>
                            </c:forEach>
                        </select>
                        <p class="text-xs text-gray-500 mt-1">Seleccione el médico que atenderá</p>
                    </div>
                </div>
            </div>

            <!-- Sección 2: Información de la Visita -->
            <div class="border-l-4 border-blue-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Detalles de la Visita</h2>

                <!-- Circunstancia -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Circunstancia o Motivo de la Visita *
                    </label>
                    <textarea name="circunstancia"
                              rows="4"
                              placeholder="Describa el motivo de la visita, síntomas, observaciones iniciales..."
                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                              required></textarea>
                    <p class="text-xs text-gray-500 mt-1">
                        Ej: "Paciente presenta fiebre alta y dolor de cabeza", "Control de rutina", etc.
                    </p>
                </div>

                <!-- Información de Triage -->
                <div class="mt-4 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 text-yellow-600 mr-2" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                        </svg>
                        <span class="text-sm font-medium text-yellow-800">Información sobre Triage</span>
                    </div>
                    <p class="text-sm text-yellow-700 mt-1">
                        El triage se asignará posteriormente por el personal de enfermería.
                        Esta visita aparecerá como "Pendiente" en la lista de triages.
                    </p>
                </div>
            </div>

            <!-- Sección 3: Información Adicional -->
            <div class="border-l-4 border-green-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Información del Sistema</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                    <div class="flex items-center space-x-2">
                        <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        <span class="text-gray-600">Fecha de registro:</span>
                        <span class="font-medium" id="fechaActual"></span>
                    </div>

                    <div class="flex items-center space-x-2">
                        <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <span class="text-gray-600">Hora de registro:</span>
                        <span class="font-medium" id="horaActual"></span>
                    </div>
                </div>
            </div>

            <!-- Botones de Acción -->
            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                <a href="visitas?accion=listar"
                   class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg transition duration-300">
                    Cancelar
                </a>
                <button type="submit"
                        class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2 rounded-lg transition duration-300 flex items-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    Registrar Visita
                </button>
            </div>
        </form>
    </div>
</main>

<!-- Script para mostrar fecha y hora actual -->
<script>
    function actualizarFechaHora() {
        const ahora = new Date();
        const fecha = ahora.toLocaleDateString('es-ES');
        const hora = ahora.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });

        document.getElementById('fechaActual').textContent = fecha;
        document.getElementById('horaActual').textContent = hora;
    }

    // Actualizar al cargar y cada minuto
    actualizarFechaHora();
    setInterval(actualizarFechaHora, 60000);
</script>

</body>
</html>