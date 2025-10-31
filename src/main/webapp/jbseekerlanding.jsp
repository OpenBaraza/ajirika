<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <title>Project Ajirika | Landing Page</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="font-sans text-gray-800">

  <!-- Header -->
    <nav id="navbar" class="navbar fixed top-0 left-0 right-0 z-50 bg-white">
    <div class="max-w-7xl mx-auto px-6 py-4">
      <div class="flex items-center justify-between">
        <!-- Logo -->
        <a href="#home" class="flex items-center gap-2 group">
          <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center transform group-hover:scale-110 transition-transform">
            <span class="text-white font-bold text-xl">A</span>
          </div>
          <span class="text-xl font-bold gradient-text-blue">Project Ajirika</span>
        </a>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center gap-8">
          <a href="#home" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Home</a>
          <a href="#challenges" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Challenges</a>
          <a href="#history" class="nav-link text-gray-700 hover:text-blue-600 font-medium">History</a>
          <a href="#actions" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Actions</a>
          <a href="#next-steps" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Next Steps</a>
        
        </div>

        <!-- Mobile Menu Button -->
        <button id="mobileMenuBtn" class="md:hidden text-gray-700 hover:text-blue-600 transition-colors">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
        </button>
      </div>

      <!-- Mobile Menu -->
      <div id="mobileMenu" class="hidden md:hidden mobile-menu mt-4 pb-4">
        <div class="flex flex-col gap-4">
          <a href="#home" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Home</a>
          <a href="#challenges" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Challenges</a>
          <a href="#history" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">History</a>
          <a href="#actions" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Actions</a>
          <a href="#next-steps" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Next Steps</a>
          
        </div>
      </div>
    </div>
  </nav>

  <!-- Hero Section -->
  <section id="home" class="pt-32 pb-20 bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 text-center">
    <div class="max-w-3xl mx-auto px-6 animate-fade-in-up">
      <h1 class="text-5xl md:text-6xl font-bold mb-6 text-gray-900 leading-tight">
        Find Jobs Smarter with <span class="text-blue-600">Ajirika</span>
      </h1>

      <p class="text-lg text-gray-700 mb-8">
        Ajirika is a simple tool that helps you build your CV once and use it anywhere. No more filling out the same forms on every job site.
        Just create your CV inside Ajirika and it becomes a smart file that any employer can read. It’s like carrying your CV in your pocket, ready to share whenever you find a new job.
      </p>
    </div>
  </section>

  <!-- How It Works -->
  <section id="how-it-works" class="py-16 px-6 lg:px-20 bg-white animate-fade-in-up">
    <div class="max-w-6xl mx-auto text-center mb-12">
      <h2 class="text-4xl font-bold mb-4">How It <span class="gradient-text-blue">Works</span></h2>
      <p class="text-xl text-gray-600">Ajirika makes building and sharing your CV effortless; all in a structured digital format.</p>
    </div>

    <div class="grid md:grid-cols-3 gap-8 text-center">
      <div class="p-6 bg-gray-50 rounded-xl shadow hover:shadow-md transition">
        <div class="w-16 h-16 bg-blue-100 text-blue-600 rounded-full mx-auto flex items-center justify-center mb-4 text-2xl font-bold">1</div>
        <h3 class="font-semibold text-xl mb-3 text-blue-600">Create Your Profile</h3>
        <p class="text-gray-600 leading-relaxed">Sign up and enter your personal details, education, and work experience into the Ajirika system.</p>
      </div>

      <div class="p-6 bg-gray-50 rounded-xl shadow hover:shadow-md transition">
        <div class="w-16 h-16 bg-blue-100 text-blue-600 rounded-full mx-auto flex items-center justify-center mb-4 text-2xl font-bold">2</div>
        <h3 class="font-semibold text-xl mb-3 text-blue-600">Build Your Digital CV</h3>
        <p class="text-gray-600 leading-relaxed">Our CV builder generates a standardized JSON CV; a digital format that’s machine-readable and easy to update.</p>
      </div>

      <div class="p-6 bg-gray-50 rounded-xl shadow hover:shadow-md transition">
        <div class="w-16 h-16 bg-blue-100 text-blue-600 rounded-full mx-auto flex items-center justify-center mb-4 text-2xl font-bold">3</div>
        <h3 class="font-semibold text-xl mb-3 text-blue-600">Share or Export Anywhere</h3>
        <p class="text-gray-600 leading-relaxed">Download your CV or share your Ajirika profile link compatible with any recruiter platform that supports our standard.</p>
      </div>
    </div>
  </section>

  <jsp:include page="/includes/footer.jsp" />
</body>
</html>