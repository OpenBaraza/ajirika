<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajirika | Login</title>
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

  <!-- LOGIN CONTAINER -->
  <div class="absolute top-0 right-0 h-full w-full md:w-2/3 
              bg-white bg-opacity-90 backdrop-blur-sm 
              flex items-center justify-center p-6 z-10 login-clip">

    <div class="w-full max-w-md">
      
      <h2 class="text-3xl md:text-4xl font-bold text-gray-800 text-center mb-6">
        Log in to your account
      </h2>

      <!-- Login Form -->
      <form method="POST" action="j_security_check" class="space-y-5">

        <div>
          <input type="text" name="j_username"
                 placeholder="Email Address" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-lg 
                        focus:ring-2 focus:ring-blue-500 focus:outline-none">
        </div>

        <div>
          <input type="password" name="j_password"
                 placeholder="Password" required
                 class="w-full px-4 py-3 border border-gray-300 rounded-lg 
                        focus:ring-2 focus:ring-blue-500 focus:outline-none">
        </div>

        <button type="submit"
                class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold
                       hover:bg-blue-700 transition">
          Login
        </button>

      </form>

      <p class="text-center text-gray-600 mt-6">
        Don't have an account?
        <a href="jbseekerlanding.jsp" class="text-blue-600 font-semibold hover:underline">
          Sign Up
        </a>
      </p>

    </div>

  </div>

</body>
</html>
