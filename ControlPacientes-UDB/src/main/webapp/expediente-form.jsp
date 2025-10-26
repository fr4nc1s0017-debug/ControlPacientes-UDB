<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- El título cambia dinámicamente según la acción -->
    <title>Nuevo Expediente - Clínica (Simulación)</title>
    <!-- Carga de Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html { font-family: 'Inter', sans-serif; }
        .container { max-width: 1200px; margin: auto; }
        /* Ajuste para corregir el tamaño de fuente en el h1 del navbar */
        .nav-h1 { font-size: 1.5rem; } /* text-2xl */
    </style>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Barra de Navegación -->
<nav class="bg-indigo-700 p-4 text-white shadow-lg">
    <div class="container mx-auto flex justify-between items-center">
        <!-- Corregido el error tipográfico: text-2x1 a text-2xl -->
        <h1 class="text-2xl font-bold nav-h1">Control de Pacientes</h1>
        <div class="space-x-4">
            <a href="dashboard.jsp" class="hover:text-indigo-200 font-semibold">Dashboard</a>
            <a href="reporteVisitas.jsp" class="hover:text-indigo-200">Reporte de Visitas</a>
            <a href="#" class="hover:text-indigo-200">Agenda Médica</a>
            <a href="#" class="hover:text-indigo-200">Recepción</a>
            <!-- Opcional: resaltar la sección de Expedientes si fuera el menú principal -->
        </div>
    </div>
</nav>

<!-- Contenido Principal -->
<main class="container mx-auto p-6">
    <div class="bg-white rounded-xl shadow-lg p-6">

        <!-- Título -->
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800">Nuevo Expediente</h1>
            <a href="expedientes?accion=listar"
               class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-lg transition duration-300">
                ← Volver a Lista
            </a>
        </div>

        <!-- Formulario -->
        <form action="expedientes" method="post" class="space-y-6">
            <input type="hidden" name="accion" value="guardar">

            <!-- Sección 1: Datos Personales -->
            <div class="border-l-4 border-indigo-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Datos Personales</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Nombre -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nombre Completo *</label>
                        <input type="text" name="nombre" value=""
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                               required placeholder="Ej: Juan Pérez">
                    </div>

                    <!-- Sexo -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Sexo *</label>
                        <select name="sexo"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                                required>
                            <option value="" selected>Seleccionar...</option>
                            <option value="M">Masculino</option>
                            <option value="F">Femenino</option>
                        </select>
                    </div>

                    <!-- Fecha Nacimiento -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Fecha de Nacimiento *</label>
                        <input type="date" name="fechaNacimiento" value=""
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                               required>
                    </div>
                </div>
            </div>

            <!-- Sección 2: Documentos del Paciente -->
            <div class="border-l-4 border-blue-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Documentos del Paciente</h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Tipo Documento -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tipo de Documento</label>
                        <select name="tipoDocumento"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
                            <option value="" selected>Seleccionar...</option>
                            <option value="DUI">DUI</option>
                            <option value="Pasaporte">Pasaporte</option>
                            <option value="Licencia">Licencia</option>
                        </select>
                    </div>

                    <!-- Número Documento -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Número de Documento</label>
                        <input type="text" name="numeroDocumento" value=""
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                               placeholder="Ej: 1234 56789 0101">
                    </div>
                </div>
            </div>

            <!-- Sección 3: Datos del Responsable (Opcional) -->
            <div class="border-l-4 border-green-500 pl-4">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">
                    Datos del Responsable
                    <span class="text-sm text-gray-500 font-normal">(Opcional)</span>
                </h2>

                <div class="space-y-4">
                    <!-- Nombre del responsable -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nombre del Responsable</label>
                        <input type="text" name="nombreResponsable" value=""
                               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                               placeholder="Solo si es menor o dependiente">
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- Documento de identidad -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Tipo de Documento</label>
                            <select name="tipoDocumentoResponsable"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                <option value="" selected>Seleccionar...</option>
                                <option value="DUI">DUI</option>
                                <option value="Pasaporte">Pasaporte</option>
                            </select>
                        </div>

                        <!-- Número Documento del Responsable -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Número de Documento</label>
                            <input type="text" name="numeroDocumentoResponsable" value=""
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Botones de Acción -->
            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
                <a href="expedientes?accion=listar"
                   class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg transition duration-300">
                    Cancelar
                </a>
                <button type="submit"
                        class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2 rounded-lg transition duration-300">
                    Guardar Expediente
                </button>
            </div>
        </form>
    </div>
</main>

</body>
</html>
