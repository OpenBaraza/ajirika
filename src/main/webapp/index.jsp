<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% boolean showToast = "true".equals(request.getParameter("success")); %>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Project Ajirika - Data CV Standard</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    * {
      font-family: 'Space Grotesk', sans-serif;
    }

    /* Animations */
    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
      }
      to {
        opacity: 1;
      }
    }

    @keyframes slideInLeft {
      from {
        opacity: 0;
        transform: translateX(-30px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }

    @keyframes slideInRight {
      from {
        opacity: 0;
        transform: translateX(30px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }

    @keyframes scaleIn {
      from {
        opacity: 0;
        transform: scale(0.9);
      }
      to {
        opacity: 1;
        transform: scale(1);
      }
    }

    @keyframes float {
      0%, 100% {
        transform: translateY(0px);
      }
      50% {
        transform: translateY(-10px);
      }
    }

    @keyframes shimmer {
      0% {
        background-position: -1000px 0;
      }
      100% {
        background-position: 1000px 0;
      }
    }

    .animate-fade-in-up {
      animation: fadeInUp 0.6s ease-out forwards;
      opacity: 0;
    }

    .animate-fade-in {
      animation: fadeIn 0.8s ease-out forwards;
      opacity: 0;
    }

    .animate-slide-in-left {
      animation: slideInLeft 0.6s ease-out forwards;
      opacity: 0;
    }

    .animate-slide-in-right {
      animation: slideInRight 0.6s ease-out forwards;
      opacity: 0;
    }

    .animate-scale-in {
      animation: scaleIn 0.5s ease-out forwards;
      opacity: 0;
    }

    .animate-float {
      animation: float 3s ease-in-out infinite;
    }

    .delay-100 { animation-delay: 0.1s; }
    .delay-200 { animation-delay: 0.2s; }
    .delay-300 { animation-delay: 0.3s; }
    .delay-400 { animation-delay: 0.4s; }
    .delay-500 { animation-delay: 0.5s; }
    .delay-600 { animation-delay: 0.6s; }

    /* Gradient text */
    .gradient-text {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .gradient-text-blue {
      background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    /* Card hover effects */
    .card-hover {
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .card-hover:hover {
      transform: translateY(-8px);
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    }

    /* Button shimmer effect */
    .btn-shimmer {
      background: linear-gradient(90deg, #3b82f6 0%, #2563eb 50%, #3b82f6 100%);
      background-size: 200% 100%;
      transition: all 0.3s ease;
    }

    .btn-shimmer:hover {
      background-position: 100% 0;
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
    }

    /* Timeline dot pulse */
    @keyframes pulse-dot {
      0%, 100% {
        box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.7);
      }
      50% {
        box-shadow: 0 0 0 10px rgba(59, 130, 246, 0);
      }
    }

    .timeline-dot {
      animation: pulse-dot 2s infinite;
    }

    /* Scroll reveal */
    .scroll-reveal {
      opacity: 0;
      transform: translateY(30px);
      transition: all 0.6s ease-out;
    }

    .scroll-reveal.revealed {
      opacity: 1;
      transform: translateY(0);
    }

    /* Modal animation */
    .modal-content {
      animation: scaleIn 0.3s ease-out;
    }

    /* Smooth scrolling */
    html {
      scroll-behavior: smooth;
    }

    /* Image hover zoom */
    .image-zoom {
      overflow: hidden;
    }

    .image-zoom img {
      transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .image-zoom:hover img {
      transform: scale(1.1);
    }

    /* Navbar styles */
    .navbar {
      transition: all 0.3s ease;
    }

    .navbar-scrolled {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }

    .nav-link {
      position: relative;
      transition: color 0.3s ease;
    }

    .nav-link::after {
      content: '';
      position: absolute;
      bottom: -4px;
      left: 0;
      width: 0;
      height: 2px;
      background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
      transition: width 0.3s ease;
    }

    .nav-link:hover::after {
      width: 100%;
    }

    /* Mobile menu animation */
    @keyframes slideDown {
      from {
        opacity: 0;
        transform: translateY(-10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .mobile-menu {
      animation: slideDown 0.3s ease-out;
    }
  </style>
</head>

<body class="bg-white text-gray-800">
  <!-- Navigation Bar -->
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

  <!-- Toast Notification -->
  <div id="toast" class="fixed top-4 right-4 bg-gradient-to-r from-green-500 to-emerald-600 text-white px-6 py-3 rounded-lg shadow-lg transition-all duration-500 z-50 <%= showToast ? "opacity-100 translate-y-0" : "opacity-0 -translate-y-4" %>">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
      </svg>
      Form submitted successfully!
    </div>
  </div>

  <!-- Hero Section -->
  <section id="home" class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 opacity-50"></div>
    <div class="relative max-w-7xl mx-auto px-6 py-20">
      <div class="grid md:grid-cols-2 gap-12 items-center">
        <div class="animate-fade-in-up">
          <div class="inline-block mb-4 px-4 py-2 bg-blue-100 text-blue-700 rounded-full text-sm font-semibold animate-scale-in">
            Building the Future of Recruitment
          </div>
          <h1 class="text-5xl md:text-6xl font-bold mb-6 leading-tight">
            Project <span class="gradient-text-blue">Ajirika</span>
          </h1>
          <p class="text-xl text-gray-600 mb-8 leading-relaxed">
            Building a Standard for the Data CV
          </p>
          <p class="text-lg text-gray-600 mb-8 leading-relaxed">
            We are rethinking how job seekers and employers connect. Instead of filling the same details over and over again,
            imagine a world where your CV is a structured data file you can carry anywhere - readable by any job portal.
          </p>
          <button id="heroGetInvolvedBtn" class="btn-shimmer text-white py-3 px-8 rounded-lg font-semibold text-lg">
            Get Involved
          </button>
        </div>
          <div class="image-zoom rounded-2xl overflow-hidden shadow-2xl">
            <img src="/ajirika/images/hero-cv-standard.jpg" alt="CV Standard Illustration" class="w-full h-auto" />
          
        </div>
      </div>
    </div>
  </section>

  <!-- Problem Statements -->
  <section class="max-w-7xl mx-auto px-6 py-20">
    <div id="challenges" class="text-center mb-16 scroll-reveal">
      <h2 class="text-4xl font-bold mb-4">The <span class="gradient-text-blue">Challenges</span> We're Solving</h2>
      <p class="text-xl text-gray-600">Four key problems in the current recruitment ecosystem</p>
    </div>

    <div class="grid md:grid-cols-2 gap-8">
      <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border border-gray-100 scroll-reveal">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-48">
          <img src="/ajirika/images/problem-repetitive.jpg" alt="Repetitive Resume Entry" class="w-full h-full object-cover" />
        </div>
        <div class="flex items-start gap-4">
          <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl flex items-center justify-center text-white font-bold text-xl">
            1
          </div>
          <div>
            <h3 class="text-2xl font-semibold mb-3 text-blue-600">
              Repetitive Resume Entry
            </h3>
            <p class="text-gray-600 leading-relaxed">
              Applicants fill the same data for every job portal. We want to create a
              <strong>standard, readable JSON CV file</strong> that applicants can reuse everywhere.
            </p>
          </div>
        </div>
      </div>

      <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border border-gray-100 scroll-reveal delay-100">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-48">
          <img src="/ajirika/images/problem-platform.jpg" alt="No Standardized CV Platform" class="w-full h-full object-cover" />
        </div>
        <div class="flex items-start gap-4">
          <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl flex items-center justify-center text-white font-bold text-xl">
            2
          </div>
          <div>
            <h3 class="text-2xl font-semibold mb-3 text-purple-600">
              No Standardized CV Platform
            </h3>
            <p class="text-gray-600 leading-relaxed">
              We are building a <strong>unified platform</strong> for applicants to update their CVs, export in a
              <strong>standard data format</strong>, and easily share across job portals.
            </p>
          </div>
        </div>
      </div>

      <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border border-gray-100 scroll-reveal delay-200">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-48">
          <img src="/ajirika/images/problem-hr-standard.jpg" alt="HR Standardization in Kenya" class="w-full h-full object-cover" />
        </div>
        <div class="flex items-start gap-4">
          <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-green-500 to-green-600 rounded-xl flex items-center justify-center text-white font-bold text-xl">
            3
          </div>
          <div>
            <h3 class="text-2xl font-semibold mb-3 text-green-600">
              HR Standardization in Kenya
            </h3>
            <p class="text-gray-600 leading-relaxed">
              We aim to <strong>collaborate with the HR community in Kenya</strong> to define and standardize key CV terms -
              ensuring interoperability and local relevance.
            </p>
          </div>
        </div>
      </div>

      <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border border-gray-100 scroll-reveal delay-300">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-48">
          <img src="/ajirika/images/problem-opensource.jpg" alt="Open Source Ecosystem" class="w-full h-full object-cover" />
        </div>
        <div class="flex items-start gap-4">
          <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl flex items-center justify-center text-white font-bold text-xl">
            4
          </div>
          <div>
            <h3 class="text-2xl font-semibold mb-3 text-orange-600">
              Need for an Open Source Ecosystem
            </h3>
            <p class="text-gray-600 leading-relaxed">
              Project Ajirika will be <strong>open source</strong>, inviting developers, HR professionals, and designers to
              continuously evolve the CV standard together.
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- History Section -->
  <section id="history" class="bg-gradient-to-br from-gray-50 to-blue-50 py-20">
    <div class="max-w-5xl mx-auto px-6">
      <div class="text-center mb-16 scroll-reveal">
        <h2 class="text-4xl font-bold mb-4">Project <span class="gradient-text-blue">History</span></h2>
        <p class="text-xl text-gray-600">A chronological overview of Project Ajirika's journey and milestones</p>
      </div>

      <!-- Timeline Graphic -->
      <div class="relative border-l-4 border-blue-500 ml-4">
        <div class="mb-12 ml-8 scroll-reveal">
          <div class="absolute w-6 h-6 bg-blue-500 rounded-full -left-3.5 border-4 border-white timeline-dot"></div>
          <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
            <h3 class="text-xl font-semibold mb-2 text-blue-600">October 2025</h3>
            <p class="text-gray-700 leading-relaxed">Initial concept meeting held to explore the idea of a standardized data CV format.</p>
          </div>
        </div>
        <div class="mb-12 ml-8 scroll-reveal delay-100">
          <div class="absolute w-6 h-6 bg-blue-500 rounded-full -left-3.5 border-4 border-white timeline-dot"></div>
          <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
            <h3 class="text-xl font-semibold mb-2 text-blue-600">October 2025</h3>
            <p class="text-gray-700 leading-relaxed">Brainstorming and drafting of the problem statement and project goals.</p>
          </div>
        </div>
        <div class="ml-8 scroll-reveal delay-200">
          <div class="absolute w-6 h-6 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full -left-3.5 border-4 border-white timeline-dot"></div>
          <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
            <h3 class="text-xl font-semibold mb-2 text-purple-600">Ongoing</h3>
            <p class="text-gray-700 leading-relaxed">Research phase to understand global standards and similar projects like JSON Resume and HR Open Standards.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Action Items Section -->
  <section id="actions" class="max-w-7xl mx-auto px-6 py-20">
    <div class="text-center mb-16 scroll-reveal">
      <h2 class="text-4xl font-bold mb-4">Current <span class="gradient-text-blue">Action Items</span></h2>
      <p class="text-xl text-gray-600">The steps currently underway to drive Project Ajirika forward</p>
    </div>

    <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
      <div class="card-hover bg-white rounded-2xl shadow-lg p-6 text-center border-t-4 border-blue-500 scroll-reveal">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-40">
          <img src="/ajirika/images/action-research.jpg" alt="Research CV Standards" class="w-full h-full object-cover" />
        </div>
        <h3 class="font-semibold text-xl mb-3 text-blue-600">Research CV Standards</h3>
        <p class="text-gray-600 leading-relaxed">Conduct detailed research on Kenyan CV data formats and standards.</p>
      </div>

      <div class="card-hover bg-white rounded-2xl shadow-lg p-6 text-center border-t-4 border-green-500 scroll-reveal delay-100">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-40">
          <img src="/ajirika/images/action-community.jpg" alt="HR Community Engagement" class="w-full h-full object-cover" />
        </div>
        <h3 class="font-semibold text-xl mb-3 text-green-600">HR Community Engagement</h3>
        <p class="text-gray-600 leading-relaxed">Engage the HR community in Kenya to discuss CV standardization and metadata.</p>
      </div>

      <div class="card-hover bg-white rounded-2xl shadow-lg p-6 text-center border-t-4 border-yellow-500 scroll-reveal delay-200">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-40">
          <img src="/ajirika/images/action-document.jpg" alt="Document Challenges" class="w-full h-full object-cover" />
        </div>
        <h3 class="font-semibold text-xl mb-3 text-yellow-600">Document Challenges</h3>
        <p class="text-gray-600 leading-relaxed">Document challenges faced by Kenyan job seekers and HR professionals.</p>
      </div>

      <div class="card-hover bg-white rounded-2xl shadow-lg p-6 text-center border-t-4 border-purple-500 scroll-reveal delay-300">
        <div class="image-zoom rounded-xl overflow-hidden mb-6 h-40">
          <img src="/ajirika/images/action-opensource.jpg" alt="Open Source Setup" class="w-full h-full object-cover" />
        </div>
        <h3 class="font-semibold text-xl mb-3 text-purple-600">Open Source Setup</h3>
        <p class="text-gray-600 leading-relaxed">Lay groundwork for the GitHub repository to collaborate on schema design.</p>
      </div>
    </div>
  </section>

  <!-- Next Steps Section -->
  <section id="next-steps" class="bg-gradient-to-br from-blue-50 to-purple-50 py-20">
    <div class="max-w-7xl mx-auto px-6">
      <div class="text-center mb-16 scroll-reveal">
        <h2 class="text-4xl font-bold mb-4">Next <span class="gradient-text-blue">Steps</span></h2>
        <p class="text-xl text-gray-600">Our roadmap for the next phase of Project Ajirika's evolution</p>
      </div>

      <div class="grid md:grid-cols-3 gap-8">
        <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border-t-4 border-green-500 scroll-reveal">
          <div class="image-zoom rounded-xl overflow-hidden mb-6 h-48">
            <img src="/ajirika/images/next-survey.jpg" alt="Survey Adoption" class="w-full h-full object-cover" />
          </div>
          <h3 class="text-2xl font-semibold mb-4 text-green-600">Survey Adoption</h3>
          <p class="text-gray-700 leading-relaxed">
            Assess how existing standards like JSON Resume and HR Open Standards are used in Kenya - and whether local HR
            systems and job portals support data import/export.
          </p>
        </div>

        <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border-t-4 border-blue-500 scroll-reveal delay-100">
          <div class="image-zoom rounded-xl overflow-hidden mb-6 h-48">
            <img src="/ajirika/images/next-schema.jpg" alt="Define Core Schema" class="w-full h-full object-cover" />
          </div>
          <h3 class="text-2xl font-semibold mb-4 text-blue-600">Define Core Schema</h3>
          <p class="text-gray-700 leading-relaxed">
            Define the <strong>minimum viable schema</strong> for CV data - distinguishing between core, optional, and
            extended fields to ensure broad compatibility.
          </p>
        </div>

        <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border-t-4 border-yellow-500 scroll-reveal delay-200">
          <div class="image-zoom rounded-xl overflow-hidden mb-6 h-48">
            <img src="/ajirika/images/next-local.jpg" alt="Local Customization" class="w-full h-full object-cover" />
          </div>
          <h3 class="text-2xl font-semibold mb-4 text-yellow-600">Local Customization</h3>
          <p class="text-gray-700 leading-relaxed">
            Incorporate <strong>Kenyan education and certification standards</strong> to make the schema locally relevant
            while maintaining global interoperability.
          </p>
        </div>
      </div>
    </div>
  </section>

  <!-- Call to Action -->
  <section class="max-w-5xl mx-auto px-6 py-20">
    <div class="bg-gradient-to-br from-blue-600 to-purple-600 rounded-3xl shadow-2xl p-12 text-center text-white scroll-reveal">
      <h2 class="text-4xl font-bold mb-6">Join the Conversation</h2>
      <p class="text-xl mb-8 leading-relaxed opacity-90">
        We are looking for HR professionals, developers, and community builders who believe in creating a more efficient
        and transparent hiring ecosystem. Let's shape the future of recruitment - together.
      </p>
      <div class="flex flex-col sm:flex-row justify-center gap-4">
        <button id="ctaJoinBtn" class="bg-white text-blue-600 hover:bg-gray-100 py-3 px-8 rounded-lg font-semibold text-lg transition-all duration-300 hover:scale-105 hover:shadow-xl">
          Join the Community
        </button>
        <button class="bg-gray-900 hover:bg-gray-800 text-white py-3 px-8 rounded-lg font-semibold text-lg transition-all duration-300 hover:scale-105 hover:shadow-xl">
          <a href="https://github.com/OpenBaraza/ajirika" target="_blank" class="flex items-center gap-2">
            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
            </svg>
            Contribute on GitHub
          </a>
        </button>
      </div>
    </div>
  </section>

  <!-- Footer -->
  <footer class="bg-gray-900 text-gray-400 text-center py-8">
    <p class="text-sm">
      © <script>document.write(new Date().getFullYear());</script> Project Ajirika - Open Source CV Standard Initiative
    </p>
  </footer>

  <!-- Modal -->
  <div id="hrModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50 transition-opacity duration-300">
    <div class="modal-content bg-white rounded-2xl shadow-2xl w-11/12 max-w-md p-8 relative">
      <button id="closeModal" class="absolute top-4 right-4 text-gray-400 hover:text-gray-800 text-2xl font-bold transition-colors">&times;</button>
      <h2 class="text-2xl font-bold mb-6 text-center gradient-text-blue">Join the Community</h2>
      <form action="submitForm" method="post" class="space-y-4">
        <div>
          <label class="block mb-2 font-semibold text-gray-700">Role</label>
          <select name="role" class="w-full border-2 border-gray-200 rounded-lg p-3 focus:border-blue-500 focus:outline-none transition-colors" required>
            <option value="developer">Developer</option>
            <option value="hr">HR Personnel</option>
          </select>
        </div>
        <div>
          <label class="block mb-2 font-semibold text-gray-700">Full Name</label>
          <input type="text" name="name" class="w-full border-2 border-gray-200 rounded-lg p-3 focus:border-blue-500 focus:outline-none transition-colors" placeholder="Your Name" required>
        </div>
        <div>
          <label class="block mb-2 font-semibold text-gray-700">Email Address</label>
          <input type="email" name="email" class="w-full border-2 border-gray-200 rounded-lg p-3 focus:border-blue-500 focus:outline-none transition-colors" placeholder="you@example.com" required>
        </div>
        <div>
          <label class="block mb-2 font-semibold text-gray-700">Comments</label>
          <textarea name="comment" class="w-full border-2 border-gray-200 rounded-lg p-3 focus:border-blue-500 focus:outline-none transition-colors" rows="4" placeholder="Your message"></textarea>
        </div>
        <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white py-3 rounded-lg font-semibold transition-all duration-300 hover:shadow-lg">Submit</button>
      </form>
    </div>
  </div>

  <script>
    // Navbar scroll effect and mobile menu functionality
    const navbar = document.getElementById('navbar');
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const mobileMenu = document.getElementById('mobileMenu');
   
    const heroGetInvolvedBtn = document.getElementById('heroGetInvolvedBtn');
    const ctaJoinBtn = document.getElementById('ctaJoinBtn');
    const modal = document.getElementById('hrModal');
    const toast = document.getElementById('toast');
    const mobileLinks = mobileMenu.querySelectorAll('a');
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed');
        }
      });
    }, observerOptions);

    document.querySelectorAll('.scroll-reveal').forEach(el => {
      observer.observe(el);
    });

    window.addEventListener('scroll', () => {
      const currentScroll = window.pageYOffset;
      
      if (currentScroll > 50) {
        navbar.classList.add('navbar-scrolled');
      } else {
        navbar.classList.remove('navbar-scrolled');
      }
      
    });

    mobileMenuBtn.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });

    mobileLinks.forEach(link => {
      link.addEventListener('click', () => {
        mobileMenu.classList.add('hidden');
      });
    });

   

    heroGetInvolvedBtn.addEventListener('click', () => {
      modal.classList.remove('hidden');
    });

    ctaJoinBtn.addEventListener('click', () => {
      modal.classList.remove('hidden');
    });

    const closeBtn = document.getElementById('closeModal');

    closeBtn.addEventListener('click', () => {
      modal.classList.add('hidden');
    });

    window.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.add('hidden');
      }
    });

    if (toast.classList.contains('opacity-100')) {
      setTimeout(() => {
        toast.classList.remove('opacity-100', 'translate-y-0');
        toast.classList.add('opacity-0', '-translate-y-4');
      }, 3000);
    }
  </script>
</body>

</html>
