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
  <nav id="navbar" class="navbar fixed top-0 left-0 right-0 z-50 bg-white shadow-sm">
    <div class="max-w-7xl mx-auto px-6 py-4 flex items center justify-between">
        <!-- Logo -->
        <a href="#home" class="flex items-center gap-2 group">
          <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center transform group-hover:scale-110 transition-transform">
            <span class="text-white font-bold text-xl">A</span>
          </div>
          <span class="text-xl font-bold gradient-text-blue">Project Ajirika</span>
        </a>
        <!-- Log in and Sign up buttons -->
        <div class="flex items-center space-x-4">
          <button id="openLoginModal" 
           class="text-gray-700 font-semibold hover:text-blue-600 transition">
           Log in
         </button>

         <button id="openSignupModal" 
           class="bg-blue-600 text-white font-semibold px-5 py-2 rounded-lg hover:bg-blue-700 transition">
           Sign Up
         </button>
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
        <h3 class="text-2xl font-semibold mb-3 text-blue-600">Create Your Profile</h3>
        <p class="text-gray-600 leading-relaxed">Sign up and enter your personal details, education, and work experience into the Ajirika system.</p>
      </div>

      <div class="p-6 bg-gray-50 rounded-xl shadow hover:shadow-md transition">
        <div class="w-16 h-16 bg-blue-100 text-blue-600 rounded-full mx-auto flex items-center justify-center mb-4 text-2xl font-bold">2</div>
        <h3 class="text-2xl font-semibold mb-3 text-blue-600">Build Your Digital CV</h3>
        <p class="text-gray-600 leading-relaxed">Our CV builder generates a standardized JSON CV — a digital format that’s machine-readable and easy to update.</p>
      </div>

      <div class="p-6 bg-gray-50 rounded-xl shadow hover:shadow-md transition">
        <div class="w-16 h-16 bg-blue-100 text-blue-600 rounded-full mx-auto flex items-center justify-center mb-4 text-2xl font-bold">3</div>
        <h3 class="text-2xl font-semibold mb-3 text-blue-600">Share or Export Anywhere</h3>
        <p class="text-gray-600 leading-relaxed">Download your CV or share your Ajirika profile link — compatible with any recruiter platform that supports our standard.</p>
      </div>
    </div>
  </section>

  <!-- ====== LOGIN MODAL ====== -->
  <div id="loginModal" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 hidden z-50">
    <div class="bg-white rounded-xl shadow-lg p-8 w-full max-w-md relative">
      <button id="closeLogin" class="absolute top-3 right-3 text-gray-500 hover:text-gray-800 text-2xl">&times;</button>
      <h2 class="text-2xl font-bold text-center text-gray-800 mb-6">Log In</h2>
      <form class="space-y-5">
        <div>
          <label class="block text-gray-700 mb-1">Email</label>
          <input type="email" name="email" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>
        <div>
          <label class="block text-gray-700 mb-1">Password</label>
          <input type="password" name="password" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>
        <button type="submit" class="w-full bg-blue-600 text-white font-semibold py-2 rounded-lg hover:bg-blue-700 transition">Log In</button>
      </form>
      <p class="text-center text-gray-600 mt-4">
        Don’t have an account?
        <a href="#" id="openSignupFromLogin" class="text-blue-600 hover:underline font-medium">Sign Up</a>
      </p>
    </div>
  </div>

  <!-- ====== SIGNUP MODAL ====== -->
  <div id="signupModal" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 hidden z-50">
    <div class="bg-white rounded-xl shadow-lg p-8 w-full max-w-md relative">
      <button id="closeSignup" class="absolute top-3 right-3 text-gray-500 hover:text-gray-800 text-2xl">&times;</button>
      <h2 class="text-2xl font-bold text-center text-gray-800 mb-6">Create Account</h2>
      <form class="space-y-5">
        <div>
          <label class="block text-gray-700 mb-1">Email</label>
          <input type="email" name="email" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>
        <div>
          <label class="block text-gray-700 mb-1">Password</label>
          <input type="password" name="password" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>
        <div>
          <label class="block text-gray-700 mb-1">Confirm Password</label>
          <input type="password" name="confirmPassword" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>
        <button type="submit" class="w-full bg-blue-600 text-white font-semibold py-2 rounded-lg hover:bg-blue-700 transition">Create Account</button>
      </form>
      <p class="text-center text-gray-600 mt-4">
        Already have an account?
        <a href="#" id="openLoginFromSignup" class="text-blue-600 hover:underline font-medium">Log In</a>
      </p>
    </div>
  </div>

  <jsp:include page="/includes/footer.jsp" />

  <!-- ====== MODAL SCRIPT ====== -->
  <script>
    const loginModal = document.getElementById('loginModal');
    const signupModal = document.getElementById('signupModal');

    document.getElementById('openLoginModal').addEventListener('click', () => loginModal.classList.remove('hidden'));
    document.getElementById('openSignupModal').addEventListener('click', () => signupModal.classList.remove('hidden'));

    document.getElementById('closeLogin').addEventListener('click', () => loginModal.classList.add('hidden'));
    document.getElementById('closeSignup').addEventListener('click', () => signupModal.classList.add('hidden'));

    document.getElementById('openSignupFromLogin').addEventListener('click', (e) => {
      e.preventDefault();
      loginModal.classList.add('hidden');
      signupModal.classList.remove('hidden');
    });

    document.getElementById('openLoginFromSignup').addEventListener('click', (e) => {
      e.preventDefault();
      signupModal.classList.add('hidden');
      loginModal.classList.remove('hidden');
    });

    // Close when clicking outside modal
    [loginModal, signupModal].forEach(modal => {
      modal.addEventListener('click', (e) => {
        if (e.target === modal) modal.classList.add('hidden');
      });
    });
  </script>
  
</body>
</html>