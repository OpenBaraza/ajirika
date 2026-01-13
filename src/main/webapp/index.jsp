<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% boolean showToast = "true".equals(request.getParameter("success")); %>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Project Ajirika | Data CV Standard</title>  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body class="bg-white text-gray-800">
  <!-- Navigation Bar -->
  <jsp:include page="/includes/header.jsp" /> 

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
  <section id="home" class="relative overflow-hidden my-5">
    <div class="absolute inset-0 bg-gradient-to-br from-blue-5 via-purple-50 to-pink-50 opacity-50"></div>
    <div class="relative max-w-6xl mx-auto px-6 pb-8 pt-16">
      <div class="grid md:grid-cols-2 gap-12 items-center">
        <div class="animate-fade-in-up">
          <div class="inline-block mb-4 px-4 py-2 bg-blue-100 text-blue-700 rounded-full text-sm font-semibold animate-scale-in">
            Building the Future of Recruitment
          </div>
          <h1 class="text-5xl md:text-6xl font-bold mb-6 leading-tight">
            Project <span class="gradient-text-blue">Ajirika</span>
          </h1>
          <p class="text-2xl text-gray-800 font-semibold mb-4 leading-snug">
            Tired of rewriting your CV on every job portal?  
          </p>

          <p class="text-lg text-gray-600 mb-8 leading-relaxed">
            Ajirika introduces a universal, data-driven CV format that both <span class="font-medium text-gray-800">job seekers</span> and 
            <span class="font-medium text-gray-800">HR professionals</span> can use seamlessly.  
            Your profile becomes a reusable <a href="resume_guide.jsp" class="text-blue-700 font-semibold hover:underline">
              JSON CV
            </a> — standardized, shareable, 
            and readable by any job platform.
          </p>

          <p class="text-lg text-gray-600 mb-8 leading-relaxed">
            For applicants, it means applying once — anywhere.  
            For recruiters, it means receiving structured, consistent candidate data.  
            Together, we’re building a smarter, faster hiring ecosystem.
          </p>
          <button id="heroGetInvolvedBtn" class="btn-shimmer text-white py-3 px-8 rounded-lg font-semibold text-lg">
            Get Involved
          </button>
        </div>
        <!-- Ajirika Hero Illustration -->
        <div class="relative flex items-center justify-center">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-center w-full max-w-xl">
            <!-- CV Card -->
            <div class="ajirika-cv bg-white rounded-2xl p-6 shadow-lg">
              <div class="flex items-center gap-4">
                <div class="w-16 h-16 rounded-full bg-gradient-to-br from-blue-300 to-indigo-400 flex items-center justify-center text-white font-bold">
                  JD
                </div>
                <div>
                  <h3 class="text-lg font-semibold text-gray-800">John Doe</h3>
                  <p class="text-sm text-gray-500">Specialist · Nairobi, Kenya</p>
                </div>
              </div>

              <div class="mt-5 space-y-3">
                <div class="h-3 w-5/6 bg-gray-100 rounded-full"></div>
                <div class="h-3 w-3/4 bg-gray-100 rounded-full"></div>
                <div class="mt-4">
                  <div class="flex items-center gap-2">
                    <span class="inline-block w-12 text-xs text-gray-500">Skills</span>
                    <div class="flex gap-2 flex-wrap">
                      <span class="text-xs px-2 py-1 bg-blue-50 text-blue-700 rounded-md">Java</span>
                      <span class="text-xs px-2 py-1 bg-blue-50 text-blue-700 rounded-md">Html</span>
                      <span class="text-xs px-2 py-1 bg-blue-50 text-blue-700 rounded-md">Css</span>
                    </div>
                  </div>
                </div>
                <div class="mt-3">
                  <div class="h-2 bg-gray-100 rounded w-2/3"></div>
                  <div class="h-2 bg-gray-100 rounded w-1/2 mt-2"></div>
                </div>
              </div>
              <div class="mt-6 text-sm text-gray-400">Sample CV — human-readable fields</div>
            </div>

            <!-- JSON Card -->
            <div class="ajirika-json bg-white text-gray-800 rounded-2xl shadow-lg border border-gray-100 w-full md:w-[120%] p-0 m-0 text-left">
              <div class="flex items-center justify-between px-4 py-2 border-b border-gray-100">
                <div class="text-sm font-medium text-gray-700">Ajirika JSON Output</div>
                <div class="text-xs text-gray-500 px-2 py-1 bg-gray-100 rounded">v1.0</div>
              </div>

              <div class="text-sm leading-6 whitespace-pre text-left px-4 py-2">
            {
              <span class="text-gray-500">"name"</span>: "John Doe",
              <span class="text-gray-500">"title"</span>: "Specialist",
              <span class="text-gray-500">"location"</span>: "Nairobi, Kenya",
              <span class="text-gray-500">"skills"</span>: ["Java", "HTML", "Tailwind"]
            }
              </div>

              <div class="text-xs text-gray-400 px-4 py-2 border-t border-gray-100">
                Machine-readable — ready to export / share
              </div>
            </div>

          <!-- Connector Animation -->
          <svg class="absolute pointer-events-none hidden md:block" width="420" height="160" viewBox="0 0 420 160"
              style="left:50%; transform:translateX(-50%); top: calc(50% - 8px);">
            <defs>
              <linearGradient id="g1" x1="0" y1="0" x2="1" y2="0">
                <stop offset="0%" stop-color="#60A5FA" stop-opacity="0.95" />
                <stop offset="100%" stop-color="#A78BFA" stop-opacity="0.95" />
              </linearGradient>
            </defs>
            <g transform="translate(20,20)">
              <path d="M0 60 Q110 10 220 60" stroke="url(#g1)" stroke-width="3" fill="none" opacity="0.25" />
              <g>
                <circle class="ajirika-dot" cx="10" cy="60" r="5" fill="#60A5FA" />
                <circle class="ajirika-dot" cx="10" cy="60" r="4" fill="#A78BFA" />
                <circle class="ajirika-dot" cx="10" cy="60" r="3" fill="#C084FC" />
              </g>
              <g transform="translate(215,56) rotate(12)">
                <path d="M0 0 L12 6 L0 12 L3 6 Z" fill="#A78BFA" opacity="0.9" />
              </g>
            </g>
          </svg>

          <span class="sr-only">Illustration showing a CV transforming into a JSON CV format</span>
        </div>

    </div>
  </section>

  <!-- Problem Statements -->
  <section class="max-w-7xl mx-auto px-6 py-8">
    <div id="challenges" class="text-center mb-16 scroll-reveal">
      <h2 class="text-4xl font-bold mb-4">The <span class="gradient-text-blue">Challenges</span> We're Solving</h2>
      <p class="text-xl text-gray-600">Four key problems in the current recruitment ecosystem</p>
    </div>

    <div class="grid md:grid-cols-4 gap-6">
      <div class="card-hover bg-white rounded-2xl shadow-lg p-8 border border-gray-100 scroll-reveal">
        <!-- Reduced icon container height from h-48 to h-32 -->
        <div class="rounded-xl overflow-hidden mb-6 h-32 bg-gradient-to-br from-blue-50 to-blue-100 flex items-center justify-center p-6">
          <svg viewBox="0 0 200 160" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
            <!-- Document stack -->
            <rect x="30" y="40" width="70" height="90" rx="4" fill="#3b82f6" opacity="0.2"/>
            <rect x="40" y="50" width="70" height="90" rx="4" fill="#3b82f6" opacity="0.4"/>
            <rect x="50" y="60" width="70" height="90" rx="4" fill="#3b82f6" opacity="0.6"/>
            <!-- Main document -->
            <rect x="60" y="20" width="80" height="100" rx="4" fill="white" stroke="#3b82f6" stroke-width="2"/>
            <line x1="70" y1="35" x2="130" y2="35" stroke="#3b82f6" stroke-width="2"/>
            <line x1="70" y1="50" x2="120" y2="50" stroke="#94a3b8" stroke-width="2"/>
            <line x1="70" y1="60" x2="125" y2="60" stroke="#94a3b8" stroke-width="2"/>
            <line x1="70" y1="70" x2="115" y2="70" stroke="#94a3b8" stroke-width="2"/>
            <line x1="70" y1="85" x2="130" y2="85" stroke="#94a3b8" stroke-width="1.5"/>
            <line x1="70" y1="95" x2="125" y2="95" stroke="#94a3b8" stroke-width="1.5"/>
            <line x1="70" y1="105" x2="120" y2="105" stroke="#94a3b8" stroke-width="1.5"/>
            <!-- Circular arrows indicating repetition -->
            <path d="M 150 50 Q 170 30, 170 60" fill="none" stroke="#ef4444" stroke-width="3" stroke-linecap="round"/>
            <polygon points="168,62 172,62 170,67" fill="#ef4444"/>
            <path d="M 170 70 Q 170 100, 150 80" fill="none" stroke="#ef4444" stroke-width="3" stroke-linecap="round"/>
            <polygon points="152,82 148,82 150,77" fill="#ef4444"/>
          </svg>
        </div>
        <div class="flex items-start gap-4">
         
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
        <!-- Reduced icon container height from h-48 to h-32 -->
        <div class="rounded-xl overflow-hidden mb-6 h-32 bg-gradient-to-br from-purple-50 to-purple-100 flex items-center justify-center p-6">
          <svg viewBox="0 0 200 160" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
            <!-- Multiple disconnected platforms -->
            <rect x="20" y="20" width="50" height="50" rx="6" fill="#a855f7" opacity="0.8"/>
            <rect x="130" y="20" width="50" height="50" rx="6" fill="#a855f7" opacity="0.8"/>
            <rect x="20" y="90" width="50" height="50" rx="6" fill="#a855f7" opacity="0.8"/>
            <rect x="130" y="90" width="50" height="50" rx="6" fill="#a855f7" opacity="0.8"/>
            <!-- Question marks on platforms -->
            <text x="45" y="52" font-size="24" fill="white" text-anchor="middle" font-weight="bold">?</text>
            <text x="155" y="52" font-size="24" fill="white" text-anchor="middle" font-weight="bold">?</text>
            <text x="45" y="122" font-size="24" fill="white" text-anchor="middle" font-weight="bold">?</text>
            <text x="155" y="122" font-size="24" fill="white" text-anchor="middle" font-weight="bold">?</text>
            <!-- Central unified platform concept -->
            <circle cx="100" cy="80" r="25" fill="#8b5cf6" stroke="white" stroke-width="3"/>
            <text x="100" y="90" font-size="28" fill="white" text-anchor="middle" font-weight="bold">1</text>
            <!-- Connecting lines -->
            <line x1="70" y1="45" x2="80" y2="65" stroke="#cbd5e1" stroke-width="2" stroke-dasharray="4"/>
            <line x1="130" y1="45" x2="120" y2="65" stroke="#cbd5e1" stroke-width="2" stroke-dasharray="4"/>
            <line x1="70" y1="115" x2="80" y2="95" stroke="#cbd5e1" stroke-width="2" stroke-dasharray="4"/>
            <line x1="130" y1="115" x2="120" y2="95" stroke="#cbd5e1" stroke-width="2" stroke-dasharray="4"/>
          </svg>
        </div>
        <div class="flex items-start gap-4">
         
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
        <!-- Reduced icon container height from h-48 to h-32 -->
        <div class="rounded-xl overflow-hidden mb-6 h-32 bg-gradient-to-br from-green-50 to-green-100 flex items-center justify-center p-6">
          <svg viewBox="0 0 200 160" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
            <!-- Kenya map outline (simplified) -->
            <path d="M 100 30 L 120 40 L 130 60 L 125 80 L 130 100 L 120 120 L 100 130 L 80 120 L 70 100 L 75 80 L 70 60 L 80 40 Z" 
                  fill="#10b981" opacity="0.3" stroke="#10b981" stroke-width="2"/>
            <!-- HR professionals icons -->
            <circle cx="85" cy="60" r="8" fill="#059669"/>
            <path d="M 85 68 L 85 85 M 78 75 L 85 75 L 92 75" stroke="#059669" stroke-width="2" stroke-linecap="round"/>
            <circle cx="115" cy="70" r="8" fill="#059669"/>
            <path d="M 115 78 L 115 95 M 108 85 L 115 85 L 122 85" stroke="#059669" stroke-width="2" stroke-linecap="round"/>
            <circle cx="100" cy="95" r="8" fill="#059669"/>
            <path d="M 100 103 L 100 120 M 93 110 L 100 110 L 107 110" stroke="#059669" stroke-width="2" stroke-linecap="round"/>
            <!-- Connection lines -->
            <line x1="85" y1="68" x2="100" y2="87" stroke="#10b981" stroke-width="1.5" stroke-dasharray="3"/>
            <line x1="115" y1="78" x2="100" y2="87" stroke="#10b981" stroke-width="1.5" stroke-dasharray="3"/>
            <!-- Standards document -->
            <rect x="140" y="50" width="40" height="50" rx="3" fill="white" stroke="#10b981" stroke-width="2"/>
            <line x1="145" y1="60" x2="175" y2="60" stroke="#10b981" stroke-width="2"/>
            <line x1="145" y1="70" x2="170" y2="70" stroke="#94a3b8" stroke-width="1.5"/>
            <line x1="145" y1="78" x2="172" y2="78" stroke="#94a3b8" stroke-width="1.5"/>
            <line x1="145" y1="86" x2="168" y2="86" stroke="#94a3b8" stroke-width="1.5"/>
          </svg>
        </div>
        <div class="flex items-start gap-4">
          
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
        <!-- Reduced icon container height from h-48 to h-32 -->
        <div class="rounded-xl overflow-hidden mb-6 h-32 bg-gradient-to-br from-orange-50 to-orange-100 flex items-center justify-center p-6">
          <svg viewBox="0 0 200 160" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
            <!-- Central code/repository -->
            <rect x="70" y="50" width="60" height="60" rx="6" fill="#f97316" opacity="0.8"/>
            <text x="100" y="75" font-size="32" fill="white" text-anchor="middle" font-weight="bold">&lt;/&gt;</text>
            <text x="100" y="95" font-size="10" fill="white" text-anchor="middle" font-weight="bold">OPEN</text>
            <!-- Contributors around -->
            <circle cx="40" cy="40" r="12" fill="#ea580c" opacity="0.9"/>
            <circle cx="160" cy="40" r="12" fill="#ea580c" opacity="0.9"/>
            <circle cx="40" cy="120" r="12" fill="#ea580c" opacity="0.9"/>
            <circle cx="160" cy="120" r="12" fill="#ea580c" opacity="0.9"/>
            <circle cx="100" cy="20" r="12" fill="#ea580c" opacity="0.9"/>
            <circle cx="100" cy="140" r="12" fill="#ea580c" opacity="0.9"/>
            <!-- User icons in circles -->
            <circle cx="40" cy="37" r="4" fill="white"/>
            <path d="M 40 41 L 40 48" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="160" cy="37" r="4" fill="white"/>
            <path d="M 160 41 L 160 48" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="40" cy="117" r="4" fill="white"/>
            <path d="M 40 121 L 40 128" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="160" cy="117" r="4" fill="white"/>
            <path d="M 160 121 L 160 128" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="100" cy="17" r="4" fill="white"/>
            <path d="M 100 21 L 100 28" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
            <circle cx="100" cy="137" r="4" fill="white"/>
            <path d="M 100 141 L 100 148" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
            <!-- Connection lines -->
            <line x1="52" y1="40" x2="70" y2="60" stroke="#fb923c" stroke-width="2"/>
            <line x1="148" y1="40" x2="130" y2="60" stroke="#fb923c" stroke-width="2"/>
            <line x1="52" y1="120" x2="70" y2="100" stroke="#fb923c" stroke-width="2"/>
            <line x1="148" y1="120" x2="130" y2="100" stroke="#fb923c" stroke-width="2"/>
            <line x1="100" y1="32" x2="100" y2="50" stroke="#fb923c" stroke-width="2"/>
            <line x1="100" y1="128" x2="100" y2="110" stroke="#fb923c" stroke-width="2"/>
          </svg>
        </div>
        <div class="flex items-start gap-4">
         
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

  <!-- Action Items Section -->
  <section id="actions" class="max-w-7xl mx-auto px-6 py-8">
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
  <section id="next-steps" class="bg-gradient-to-br from-blue-50 to-purple-50 py-8">
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

    <!-- Job Seekers Section -->
  <section id="job-seekers" class="py-8 bg-white">
    <div class="max-w-7xl mx-auto px-6">
      <div class="scroll-reveal">
        <h2 class="text-4xl font-bold mb-6 text-center">Job
          <span class="gradient-text-blue"> Seekers</span>
        </h2>
        <p class="text-xl text-gray-600 mb-12 text-center leading-relaxed">
          Want to create an easy digitized CV?
        </p>
      </div>

      <div class="grid md:grid-cols-2 gap-12 items-center">
        <!-- Left Column: Text -->
        <div class="scroll-reveal">
          <p class="text-gray-700 leading-relaxed mb-8">
            Ajirika is a simple tool that helps you build your CV once and use it anywhere. No more filling out the same forms on every job site. Just create your CV inside Ajirika and it becomes a smart file that any employer can read. It’s like carrying your CV in your pocket, ready to share whenever you find a new job.
          </p>
          <a href="<%= request.getContextPath() %>/jbseekerlanding.jsp">
            <button
               id="jobSeekersJoinBtn"
               class="btn-shimmer text-white py-3 px-8 rounded-lg font-semibold text-lg">
               CREATE
            </button>
          </a>

        </div>
        <!-- Right Column: Image -->
        <div class="image-zoom rounded-2xl overflow-hidden shadow-2xl scroll-reveal">
          <img src="https://asianlinkconsultancy.com/wp-content/uploads/2023/04/960x0.jpg"
            alt="Person making job applications"
            class="w-full h-auto object-cover" />
        </div>
      </div>
    </div>
  </section>


  <!-- History Section -->
  <section id="history" class="bg-gradient-to-br from-gray-50 to-blue-50 py-8">
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
        <div class="mb-12 ml-8 scroll-reveal delay-100">
          <div class="absolute w-6 h-6 bg-blue-500 rounded-full -left-3.5 border-4 border-white timeline-dot"></div>
          <div class="bg-white rounded-xl shadow-lg p-6 card-hover">
            <h3 class="text-xl font-semibold mb-2 text-blue-600">11th December 2025</h3>
            <p class="text-gray-700 leading-relaxed">Soft launch for the Ajirika project in Parkland sports club.</p>
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

  <!-- Call to Action -->
  <section class="max-w-5xl mx-auto px-6 py-8">
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

  <jsp:include page="/includes/footer.jsp" />

  <!-- Modal -->
  <div id="hrModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50 transition-opacity duration-300">
    <div class="modal-content bg-white rounded-2xl shadow-2xl w-11/12 max-w-md p-8 relative">
      <button id="hrCloseBtn" class="absolute top-4 right-4 text-gray-400 hover:text-gray-800 text-2xl font-bold transition-colors">&times;</button>
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

  <!-- Registration Modal -->
  <div id="registrationModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50 transition-opacity duration-300">
    <div class="modal-content bg-white rounded-2xl shadow-2xl w-11/12 max-w-md p-8 relative">
      <button id="registrationCloseModal" class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 text-2xl font-bold">
        &times;
      </button>
      <h2 class="text-2xl font-bold mb-6 text-center gradient-text-blue">Event Registration</h2>
      <form id="registrationForm" class="space-y-4" action="addAttendee" method="post">
        
        <!-- Full Name -->
        <div>
          <label class="block mb-2 font-semibold text-gray-700">Full Name</label>
          <input 
            type="text" 
            id="fullName" 
            name="full_name" 
            class="w-full border-2 border-gray-200 rounded-lg p-3 focus:border-blue-500 focus:outline-none transition-colors" 
            placeholder="Your Name" 
            required>
          <p class="text-red-500 text-sm mt-1 hidden" data-error-for="fullName" data-error-type="required">
            Full name is required.
          </p>
        </div>

        <!-- Email -->
        <div>
          <label class="block mb-2 font-semibold text-gray-700">Email Address</label>
          <input 
            type="email" 
            id="email" 
            name="email_address" 
            class="w-full border-2 border-gray-200 rounded-lg p-3 focus:border-blue-500 focus:outline-none transition-colors" 
            placeholder="you@example.com" 
            required>
          <p class="text-red-500 text-sm mt-1 hidden" data-error-for="email" data-error-type="required">
            Email is required.
          </p>
          <p class="text-red-500 text-sm mt-1 hidden" data-error-for="email" data-error-type="format">
            Please enter a valid email address.
          </p>
          <p class="text-red-500 text-sm mt-1 hidden" data-error-for="email" data-error-type="taken">
            This email is already registered.
          </p>
        </div>

        <!-- Phone -->
        <div>
          <label class="block text-gray-700 font-semibold mb-1">Phone Number</label>
          <div class="flex">
            <select 
              id="countryCode" 
              name="country_code"
              class="border border-gray-300 rounded-l-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:outline-none bg-white w-1/3">
            </select>
            <input 
              type="tel" 
              id="phone" 
              name="phone_number" 
              required
              class="w-2/3 px-4 py-2 border border-gray-300 rounded-r-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
              placeholder="Enter phone number" />
          </div>
          <p class="text-red-500 text-sm mt-1 hidden" data-error-for="phone" data-error-type="required">
            Phone number is required.
          </p>
        </div>

        <!-- Submit Button -->
        <button 
          type="submit" 
          class="w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white py-3 rounded-lg font-semibold transition-all duration-300 hover:shadow-lg">
          Submit
        </button>
      </form>
    </div>
  </div>
  <script src="<%= request.getContextPath() %>/javascript/signup.js"></script>
  <script src="<%= request.getContextPath() %>/javascript/indexscript.js"></script>
  <script src="<%= request.getContextPath() %>/javascript/launchEvent.js"></script>
</body>
</html>
