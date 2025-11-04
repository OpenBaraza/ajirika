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
        <a href="index.jsp" class="flex items-center gap-2 group">
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
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg max-h-[90vh] overflow-hidden relative md:max-w-md">
      <div class="max-h-[calc(90vh-2rem)] overflow-y-auto p-6 md:p-8">
        <button id="closeSignup" class="absolute top-3 right-3 text-gray-500 hover:text-gray-800 text-2xl">&times;</button>
        <h2 class="text-2xl font-bold text-center text-gray-800 mb-6">Create Account</h2>
        <form class="space-y-5">
           <div>
              <label class="block text-gray-700 mb-1">First Name</label>
              <input type="text" name="firstName" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">Middle Name</label>
              <input type="text" name="middleName" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">Last Name</label>
              <input type="text" name="lastName" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">Phone Number</label>
              <input type="tel" name="phone" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none" />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">Email Address</label>
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
  </div>

  <jsp:include page="/includes/footer.jsp" />

    <!-- Bottom section -->
    <div class="flex flex-col md:flex-row justify-between items-center mt-8 text-sm space-y-4 md:space-y-0">
      <p class="text-center md:text-left text-white">
        © <script>document.write(new Date().getFullYear());</script> Project Ajirika –
        <a href="#" class="hover:text-blue-400 hover:underline">Privacy Policy</a> –
        <a href="#" class="hover:text-blue-400 hover:underline">Terms of Use</a>
      </p>
      
      <!-- Social Icons -->
      <div class="flex space-x-3">
        <!-- Facebook -->
        <a href="#" class="bg-gray-200 text-[#162441] rounded-md p-2 hover:bg-[#5bc0de] hover:text-white transition">
          <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 320 512" class="h-4 w-4">
            <path d="M279.14 288l14.22-92.66h-88.91v-60.13c0-25.35 12.42-50.06 52.24-50.06H295V6.26S270.43 0 246.36 0c-73.22 0-121.09 44.38-121.09 124.72v70.62H56.89V288h68.38v224h100.17V288z"/>
          </svg>
        </a>

        <!-- X (Twitter) -->
        <a href="#" class="bg-gray-200 text-[#162441] rounded-md p-2 hover:bg-black hover:text-white transition">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 1227" fill="currentColor" class="h-4 w-4">
            <path d="M714.163 519.284 1160.89 0H1055.3L667.137 450.887 359.333 0H0l466.317 682.222L0 1226.37h105.584l409.921-476.373L840.667 1226.37H1200L714.137 519.284h.026ZM565.083 693.88l-47.466-67.934L144.02 80.089h162.314l305.138 436.744 47.466 67.934 395.144 564.144H891.769L565.083 693.88Z"/>
          </svg>
        </a>

        <!-- LinkedIn -->
        <a href="#" class="bg-gray-200 text-[#162441] rounded-md p-2 hover:bg-blue-700 hover:text-white transition">
          <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 448 512" class="h-4 w-4">
            <path d="M100.28 448H7.4V148.9h92.88zm-46.44-338C24.28 110 0 85.7 0 56.5A56.52 56.52 0 0 1 56.5 0C87.1 0 112 24.9 112 55.5s-24.9 54.5-58.16 54.5zM447.9 448h-92.68V302.4c0-34.7-12.4-58.4-43.3-58.4-23.6 0-37.6 15.8-43.8 31.1-2.3 5.5-2.8 13.1-2.8 20.8V448h-92.78s1.2-239.6 0-264.1h92.78v37.4c-.2.3-.5.7-.7 1h.7v-1c12.3-19 34.4-46.2 83.7-46.2 61.2 0 107.1 40 107.1 125.9z"/>
          </svg>
        </a>

        <!-- YouTube -->
        <a href="#" class="bg-gray-200 text-[#162441] rounded-md p-2 hover:bg-[#5bc0de] hover:text-red-500 transition">
          <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 576 512" class="h-4 w-4">
            <path d="M549.65 124.08c-6.28-23.7-24.86-42.28-48.56-48.56C458.4 64 288 64 288 64s-170.4 0-213.09 11.52c-23.7 6.28-42.28 24.86-48.56 48.56C16.8 166.77 16.8 256 16.8 256s0 89.23 9.55 131.92c6.28 23.7 24.86 42.28 48.56 48.56C117.6 448 288 448 288 448s170.4 0 213.09-11.52c23.7-6.28 42.28-24.86 48.56-48.56C559.2 345.23 559.2 256 559.2 256s0-89.23-9.55-131.92zM232 338.55V173.45L374.6 256z"/>
          </svg>
        </a>
      </div>
    </div>
    </div>
  </footer>
  <script src="<%= request.getContextPath() %>/javascript/jbseekerlandingscript.js"></script>
</body>
</html>