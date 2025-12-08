<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajirika | Log Out</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body class="min-h-screen relative">
  <!-- Full-screen background image -->
  <div class="absolute inset-0">
    <img src="https://asianlinkconsultancy.com/wp-content/uploads/2023/04/960x0.jpg" 
         class="w-full h-screen md:h-full md:w-auto object-cover" 
         alt="Background">
    <!-- Dark overlay -->
    <div class="absolute inset-0 bg-black bg-opacity-50"></div>
  </div>

  <!-- LOGOUT CONTAINER -->
  <div class="absolute top-0 right-0 h-full w-full md:w-2/3 
              bg-white bg-opacity-90 backdrop-blur-sm 
              flex items-center justify-center p-6 z-10 login-clip">

    <div class="w-full max-w-md">
      
      <h2 class="text-2xl md:text-3xl font-bold text-gray-800 text-center mb-6">
        You have been logged out
      </h2>

        <div class="rounded-xl shadow-md p-6 text-center">
            <p class="text-gray-600 mb-6">
            Your session has ended. Please log in again to continue.
            </p>
            <a href="profile.jsp" 
            class="inline-block w-full bg-blue-600 text-white py-3 rounded-lg font-semibold
                    hover:bg-blue-700 transition focus:outline-none focus:ring-2 focus:ring-blue-500">
            Back to Login
            </a>
      </div>
    </div>

  </div>

</body>
</html>
