<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    // Redirigir automáticamente al login
    response.sendRedirect("login");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Control de Pacientes - Clínica</title>
    <meta http-equiv="refresh" content="0;url=login">
</head>
<body>
<p>Redirigiendo al sistema...</p>
</body>
</html>