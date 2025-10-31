<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Blogs | Baraza HCM</title>
  <script src="https://cdn.tailwindcss.com"></script>
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

  <!-- Blogs Banner -->
  <section class="bg-blue-900 text-center py-16 text-white">
    <h5 class="text-green-400 uppercase font-semibold tracking-widest mb-2">Resources</h5>
    <h1 class="text-5xl font-bold mb-6">Blogs</h1>
    <a href="<%= request.getContextPath() %>/contact.jsp" class="inline-block border-2 border-green-500 text-green-500 px-6 py-2 rounded-md font-semibold hover:bg-green-500 hover:text-white transition">
      Talk To Us →
    </a>
  </section>

  <!-- Blog List Section -->
  <section class="py-16 px-6 lg:px-16 grid md:grid-cols-3 gap-8">
    <div class="border rounded-lg shadow-md p-6 hover:shadow-lg transition">
      <img src="<%= request.getContextPath() %>/assets/images/blog1.jpg" alt="Blog 1" class="rounded-lg mb-4">
      <h3 class="text-xl font-semibold mb-2">Blog Title 1</h3>
      <p class="text-gray-600 mb-4">Short blog description goes here. Keep it simple and clean.</p>
      <a href="#" class="text-blue-700 font-semibold hover:underline">Read More →</a>
    </div>

    <div class="border rounded-lg shadow-md p-6 hover:shadow-lg transition">
      <img src="<%= request.getContextPath() %>/assets/images/blog2.jpg" alt="Blog 2" class="rounded-lg mb-4">
      <h3 class="text-xl font-semibold mb-2">Blog Title 2</h3>
      <p class="text-gray-600 mb-4">Another short blog description here for consistency.</p>
      <a href="#" class="text-blue-700 font-semibold hover:underline">Read More →</a>
    </div>

    <div class="border rounded-lg shadow-md p-6 hover:shadow-lg transition">
      <img src="<%= request.getContextPath() %>/assets/images/blog3.jpg" alt="Blog 3" class="rounded-lg mb-4">
      <h3 class="text-xl font-semibold mb-2">Blog Title 3</h3>
      <p class="text-gray-600 mb-4">Short snippet about the blog article or news item.</p>
      <a href="#" class="text-blue-700 font-semibold hover:underline">Read More →</a>
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
  <footer class="px-6 md:px-16 lg:px-24 py-10 bg-[#162441]">
  <div class="max-w-7xl mx-auto">
    <div class="border-b border-gray-600 pb-10">
      
      <!-- Left section -->
      <div>
        <div class="flex items-center space-x-3 mb-4">
          <img src="https://www.hcm.co.ke/wp-content/uploads/2024/11/baraza-hcm-dewcis-co-brand-dark.png" alt="Baraza HCM Logo" class="h-16">
        </div>
        <h3 class="text-white font-semibold">Dew CIS Solutions Limited</h3>
        <p class="mt-2 text-sm text-white">
          Haven Court, Unit C2, Waiyaki Way,<br>
          Westlands, Nairobi Kenya.
        </p>

        <p class="mt-4 text-sm text-white leading-relaxed">
          <span class="block">+254 (20) 224 3097 / +254 (20) 222 7100</span>
          <span class="block">+254 (738) 819 505 / +254 (726) 209 214</span>
          <span class="block">Email: <a href="mailto:info@hcm.co.ke" class="hover:text-blue-500 hover:underline">info@hcm.co.ke</a></span>
        </p>
      </div>
    </div>

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