<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atención Médica - Clínica</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html { font-family: 'Inter', sans-serif; }
        .container { max-width: 1200px; margin: auto; }
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

        <!-- Título e Información del Paciente -->
        <div class="flex justify-between items-start mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Registro de Atención Médica</h1>
                <c:if test="${not empty visita}">
                    <div class="mt-2 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                            <div>
                                <span class="font-medium text-blue-700">Paciente:</span>
                                <span class="text-blue-900">${visita.idExpediente} - [Nombre del Paciente]</span>
                            </div>
                            <div>
                                <span class="font-medium text-blue-700">Fecha Visita:</span>
                                <span class="text-blue-900">${visita.fechaHora}</span>
                            </div>
                            <div>
                                <span class="font-medium text-blue-700">Circunstancia:</span>
                                <span class="text-blue-900">${visita.circunstancia}</span>
                            </div>
                            <div>
                                <span class="font-medium text-blue-700">Triage:</span>
                                <span class="px-2 py-1 text-xs font-semibold rounded-full
                                        ${visita.triage == 'Rojo' ? 'bg-red-100 text-red-800' :
                                            visita.triage == 'Amarillo' ? 'bg-yellow-100 text-yellow-800' :
                                            visita.triage == 'Verde' ? 'bg-green-100 text-green-800' :
                                            'bg-gray-100 text-gray-800'}">
                                        ${visita.triage}
                                </span>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
            <a href="visitas?accion=listar"
               class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-lg transition duration-300">
                ← Volver a Visitas
            </a>
        </div>

        <!-- Formulario de Atención Médica -->
        <form action="atenciones" method="post" class="space-y-6">
            <input type="hidden" name="accion" value="guardar">
            <c:if test="${not empty visita}">
                <input type="hidden" name="idVisita" value="${visita.idVisita}">
            </c:if>

            <!-- Sección 1: Información de Consulta -->
            <div class="border-l-4 border-indigo-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Información de la Consulta</h2>

                <div class="grid grid-cols-1 gap-4">
                    <!-- Médico -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Médico Tratante *</label>
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
                    </div>

                    <!-- Consulta Por -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Motivo de Consulta *
                        </label>
                        <input type="text" name="consultaPor"
                               placeholder="Ej: Control de rutina, Dolor abdominal, Fiebre, etc."
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                               required>
                    </div>
                </div>
            </div>

            <!-- Sección 2: Evaluación Médica -->
            <div class="border-l-4 border-blue-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Evaluación Médica</h2>

                <!-- Enfermedad Presente -->
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Enfermedad Actual o Síntomas Presentes *
                    </label>
                    <textarea name="presenteEnfermedad"
                              rows="4"
                              placeholder="Describa los síntomas, signos vitales, hallazgos físicos, duración de síntomas..."
                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                              required></textarea>
                    <p class="text-xs text-gray-500 mt-1">
                        Incluya: Síntomas principales, tiempo de evolución, factores aggravantes, etc.
                    </p>
                </div>

                <!-- Diagnóstico -->
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Diagnóstico *
                    </label>
                    <textarea name="diagnostico"
                              rows="3"
                              placeholder="Diagnóstico principal y diagnósticos diferenciales si aplica..."
                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                              required></textarea>
                    <p class="text-xs text-gray-500 mt-1">
                        Use terminología médica estándar. Ej: "Gastroenteritis aguda", "Hipertensión arterial", etc.
                    </p>
                </div>
            </div>

            <!-- Sección 3: Tratamiento -->
            <div class="border-l-4 border-green-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Plan de Tratamiento</h2>

                <!-- Tratamiento -->
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Tratamiento Indicado *
                    </label>
                    <textarea name="tratamiento"
                              rows="4"
                              placeholder="Medicamentos, dosis, frecuencia, duración, procedimientos, recomendaciones..."
                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                              required></textarea>
                    <p class="text-xs text-gray-500 mt-1">
                        Especifique: Medicamentos, dosis, frecuencia, terapias, reposo, dieta, etc.
                    </p>
                </div>

                <!-- Anotaciones Adicionales -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Anotaciones Adicionales
                    </label>
                    <textarea name="anotaciones"
                              rows="3"
                              placeholder="Observaciones, recomendaciones especiales, seguimiento requerido, referencias..."
                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"></textarea>
                    <p class="text-xs text-gray-500 mt-1">
                        Espacio para notas adicionales, seguimiento, referencias a especialistas, etc.
                    </p>
                </div>
            </div>

            <!-- Sección 4: Plantillas Rápidas (Opcional) -->
            <div class="border-l-4 border-yellow-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Plantillas Rápidas</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <button type="button"
                            onclick="aplicarPlantilla('gripe')"
                            class="bg-yellow-100 hover:bg-yellow-200 text-yellow-800 px-4 py-2 rounded-lg border border-yellow-300 text-sm transition duration-300">
                        Gripe Común
                    </button>
                    <button type="button"
                            onclick="aplicarPlantilla('control')"
                            class="bg-green-100 hover:bg-green-200 text-green-800 px-4 py-2 rounded-lg border border-green-300 text-sm transition duration-300">
                        Control Rutina
                    </button>
                </div>
            </div>

            <!-- Botones de Acción -->
            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                <a href="visitas?accion=listar"
                   class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg transition duration-300">
                    Cancelar
                </a>
                <button type="button"
                        onclick="guardarBorradorLocal()"
                        class="bg-yellow-500 hover:bg-yellow-600 text-white px-6 py-2 rounded-lg transition duration-300">
                    Guardar Borrador
                </button>
                <button type="submit"
                        class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2 rounded-lg transition duration-300 flex items-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                    Finalizar Atención
                </button>
            </div>
        </form>
    </div>
</main>

<!-- Scripts para funcionalidades adicionales -->
<script>
    // NOTA IMPORTANTE: Según las directrices de la plataforma, el almacenamiento persistente
    // (como guardar borradores) debe utilizar Firestore en lugar de localStorage.
    // La función a continuación utiliza localStorage solo para fines de simulación.
    // La función de notificación 'alert()' ha sido reemplazada por console.log().

    // Plantillas rápidas
    function aplicarPlantilla(tipo) {
        if (tipo === 'gripe') {
            document.querySelector('textarea[name="presenteEnfermedad"]').value =
                'Paciente presenta fiebre de 38°C, congestión nasal, tos productiva, malestar general. Síntomas iniciaron hace 3 días. No hay dificultad respiratoria.';
            document.querySelector('textarea[name="diagnostico"]').value =
                'Infección viral de vías respiratorias superiores (Gripe común)';
            document.querySelector('textarea[name="tratamiento"]').value =
                '1. Paracetamol 500mg cada 8 horas por 3 días\n2. Descongestionante nasal\n3. Reposo relativo\n4. Hidratación abundante\n5. Control en 48 horas si persiste fiebre';
        } else if (tipo === 'control') {
            document.querySelector('textarea[name="presenteEnfermedad"]').value =
                'Paciente asintomático. Control de rutina. Examen físico dentro de límites normales.';
            document.querySelector('textarea[name="diagnostico"]').value =
                'Paciente sano. Control de rutina sin hallazgos.';
            document.querySelector('textarea[name="tratamiento"]').value =
                '1. Continuar con estilo de vida saludable\n2. Control anual programado\n3. No se requiere medicación';
        }
    }

    // Guardar borrador localmente (Simulación de Borrador)
    function guardarBorradorLocal() {
        const datos = {
            consultaPor: document.querySelector('input[name="consultaPor"]').value,
            presenteEnfermedad: document.querySelector('textarea[name="presenteEnfermedad"]').value,
            diagnostico: document.querySelector('textarea[name="diagnostico"]').value,
            tratamiento: document.querySelector('textarea[name="tratamiento"]').value,
            anotaciones: document.querySelector('textarea[name="anotaciones"]').value
        };

        // Uso de localStorage solo para simulación. Debe ser reemplazado por Firestore.
        localStorage.setItem('borradorAtencion', JSON.stringify(datos));

        // Reemplazo de alert() por console.log() (se recomienda un modal personalizado en producción)
        console.log('Borrador guardado localmente. Utilice Firestore para persistencia real.');
    }

    // Cargar borrador si existe
    window.addEventListener('load', function() {
        const borrador = localStorage.getItem('borradorAtencion');
        if (borrador) {
            const datos = JSON.parse(borrador);
            document.querySelector('input[name="consultaPor"]').value = datos.consultaPor || '';
            document.querySelector('textarea[name="presenteEnfermedad"]').value = datos.presenteEnfermedad || '';
            document.querySelector('textarea[name="diagnostico"]').value = datos.diagnostico || '';
            document.querySelector('textarea[name="tratamiento"]').value = datos.tratamiento || '';
            document.querySelector('textarea[name="anotaciones"]').value = datos.anotaciones || '';
        }
    });
</script>

</body>
</html>
