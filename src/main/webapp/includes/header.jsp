<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<header class="w-full">
  <nav id="navbar"
       class="navbar fixed top-0 left-0 right-0 z-50"
       role="navigation"
       aria-label="Main navigation">

    <div class="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">

      <!-- Logo -->
      <a href="${pageContext.request.contextPath}/#home"
         class="flex items-center gap-2 group"
         aria-label="Project Ajirika home">
        <div
          class="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center transform group-hover:scale-110 transition-transform">
          <span class="text-white font-bold text-xl">A</span>
        </div>
        <span class="text-xl font-bold gradient-text-blue">Project Ajirika</span>
      </a>

      <!-- Desktop Navigation -->
      <div class="hidden md:flex items-center gap-8">
        <a href="${pageContext.request.contextPath}/#home" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Home</a>
        <a href="${pageContext.request.contextPath}/#challenges" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Challenges</a>
        <a href="${pageContext.request.contextPath}/#history" class="nav-link text-gray-700 hover:text-blue-600 font-medium">History</a>
        <a href="${pageContext.request.contextPath}/#actions" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Actions</a>
        <a href="${pageContext.request.contextPath}/#next-steps" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Next Steps</a>
        <a href="${pageContext.request.contextPath}/resume_guide.jsp" class="nav-link text-gray-700 hover:text-blue-600 font-medium">JSON CV</a>
        <a href="${pageContext.request.contextPath}/processCV.jsp" class="nav-link text-gray-700 hover:text-blue-600 font-medium">Process CV</a>
      </div>

      <!-- Mobile Menu Button -->
      <button id="mobileMenuBtn"
              class="md:hidden text-gray-700 hover:text-blue-600 transition-colors"
              aria-label="Toggle navigation menu"
              aria-expanded="false">
        <svg id="menuIcon" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M4 6h16M4 12h16M4 18h16"></path>
        </svg>
        <svg id="closeIcon" class="w-6 h-6 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>
    </div>

    <!-- Mobile Menu -->
    <div id="mobileMenu" class="hidden md:hidden mobile-menu mt-4 pb-4">
      <div class="flex flex-col gap-4">
        <a href="${pageContext.request.contextPath}/#home" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Home</a>
        <a href="${pageContext.request.contextPath}/#challenges" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Challenges</a>
        <a href="${pageContext.request.contextPath}/#history" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">History</a>
        <a href="${pageContext.request.contextPath}/#actions" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Actions</a>
        <a href="${pageContext.request.contextPath}/#next-steps" class="text-gray-700 hover:text-blue-600 font-medium py-2 border-b border-gray-100">Next Steps</a>
        <a href="${pageContext.request.contextPath}/resume_guide.jsp" class="text-gray-700 hover:text-blue-600 font-medium py-2">JSON CV</a>
        <a href="${pageContext.request.contextPath}/processCV.jsp" class="text-gray-700 hover:text-blue-600 font-medium py-2">Process CV</a>
      </div>
    </div>

  </nav>
</header>