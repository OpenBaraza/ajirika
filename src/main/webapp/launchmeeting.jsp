<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ajirika | Launch Meeting</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body class="bg-gray-50 font-[Space_Grotesk]">

  <!-- Header -->
  <jsp:include page="/includes/header.jsp" />

  <!-- Main Content -->
  <main class="max-w-5xl mx-auto px-6 py-16 mt-7">

    <!-- Title -->
    <h1 class="text-5xl md:text-6xl font-bold mb-6 leading-tight scroll-reveal text-center">
      Ajirika <span class="gradient-text-blue">Launch</span> Meeting
    </h1>

    <p class="text-gray-700 leading-relaxed mb-10 scroll-reveal text-center max-w-3xl mx-auto">
      On the 11th of December 2025, we gathered HR professionals and software developers at
      Parklands Sports Club, Nairobi, for a conversation that's long overdue - fixing Kenya's broken job application process.
    </p>

    <!-- Image Carousel -->
    <div class="relative mb-14 scroll-reveal">

      <!-- Left Arrow -->
      <button
        id="leftArrow"
        onclick="scrollGallery(-1)"
        class="absolute left-2 top-1/2 -translate-y-1/2 z-20 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 hidden text-blue-900"
        aria-label="Scroll left"
      >
        &#10094;
      </button>

      <!-- Carousel Container -->
      <div class="overflow-hidden">
        <div id="launchGallery" class="flex gap-4 transition-transform duration-500" style="transform: translateX(0);">
          <img src="${pageContext.request.contextPath}/images/launch_image%201.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%202.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%203.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%204.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%205.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%206.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%207.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%208.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-md flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
        </div>
      </div>

      <!-- Right Arrow -->
      <button
        id="rightArrow"
        onclick="scrollGallery(1)"
        class="absolute right-2 top-1/2 -translate-y-1/2 z-20 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 text-blue-900"
        aria-label="Scroll right"
      >
        &#10095;
      </button>

    </div>

    <!-- Launch Section -->
    <h2 class="text-4xl font-bold mb-4 scroll-reveal text-center">
      <span class="gradient-text-blue">Launch</span>
    </h2>

    <p class="text-gray-700 leading-relaxed mb-10 scroll-reveal text-center max-w-3xl mx-auto">
      HR professionals and software developers were invited to discuss the main challenges currently affecting the job application process. The goal of this session was to openly identify pain points from both the hiring and technical perspectives, and to explore opportunities for building better, fairer recruitment tools.
    </p>

    <h3 class="text-2xl font-bold mb-4 scroll-reveal text-center">
      Key 
      <span class="gradient-text-blue">Challenges</span> 
      Identified
    </h3>
    <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-10 scroll-reveal max-w-3xl mx-auto">
      <li class="text-gray-700 leading-relaxed mb-10 max-w-3xl mx-auto"><span class="gradient-text-blue font-bold">Too many CVs submitted:</span> Employers receive an overwhelming number of applications for a single role, making it difficult to review each one thoroughly and fairly within a reasonable time.</li>
      <li class="mb-10"><span class="gradient-text-blue font-bold">Difficulty extracting important information from CVs:</span> CVs are structured differently depending on the applicant, making it hard for recruiters to quickly identify critical details such as skills, experience, and qualifications.</li>
      <li class="mb-10"><span class="gradient-text-blue font-bold">Unqualified applicants due to unclear job descriptions:</span> Poorly defined or vague job descriptions lead to many applicants applying without meeting the minimum requirements, increasing screening workload.</li>
      <li class="mb-10"><span class="gradient-text-blue font-bold">AI-generated CVs that lack authenticity:</span> The rise of AI tools has led to CVs that are polished but exaggerated, making it difficult to distinguish genuine experience from artificially enhanced content.</li>
      <li class="mb-10"><span class="gradient-text-blue font-bold">Gig economy considerations:</span> Traditional recruitment processes struggle to accommodate candidates seeking one-time, freelance, or part-time opportunities, which are increasingly common.</li>
      <li class="mb-10"><span class="gradient-text-blue font-bold">Incomplete biodata:</span> Missing or inconsistent personal information makes it difficult to properly understand and evaluate applicants, especially during early screening stages.</li>
      <li class="mb-10"><span class="gradient-text-blue font-bold">Poor representation of experience, achievements, and skills:</span> Many candidates struggle to clearly articulate their accomplishments and competencies using standard CV formats.</li>
      <li class="mb-10"><span class="gradient-text-blue font-bold">Difficulty documenting attitude and character:</span> Soft skills such as integrity, teamwork, and work ethic are hard to capture in a CV and are often overstated or misrepresented.</li>
    </ul>
    <!-- Initial Team section -->
    <h2 class="text-4xl font-bold mb-4 scroll-reveal text-center">
      Initial <span class="gradient-text-blue">Team</span>
    </h2>

    <p class="text-gray-700 leading-relaxed mb-8 scroll-reveal text-center max-w-3xl mx-auto">
      The project was initiated and is currently being developed by a core team made up of our developers, who are actively involved in designing, building, and refining the solution. This team brings together technical expertise and firsthand understanding of the challenges within the recruitment ecosystem.
    </p>

    <p class="text-gray-700 leading-relaxed mb-8 scroll-reveal text-center max-w-3xl mx-auto">Beyond development, the team collaborates closely with HR professionals to ensure the solution addresses real-world hiring needs, balances technical feasibility with usability, and remains practical for both employers and job seekers.</p>

    <!-- Inception Section -->
    <h2 class="text-4xl font-bold mb-4 scroll-reveal text-center">
      <span class="gradient-text-blue">Inception</span>
    </h2>

    <p class="text-gray-700 leading-relaxed mb-8 scroll-reveal text-center max-w-3xl mx-auto">
      Before shortlisting candidates, employers must first determine who actually qualifies for a role. This initial qualification stage is often the most difficult and time-consuming part of recruitment.
    </p>
    <p class="text-gray-700 leading-relaxed mb-8 scroll-reveal text-center max-w-3xl mx-auto">
      Applications submitted via email further complicate the process, as they lack structure and make it difficult to filter, compare, or analyze candidate information efficiently.
    </p>
    <p class="text-gray-700 leading-relaxed mb-8 scroll-reveal text-center max-w-3xl mx-auto">
      To address these challenges, the goal is to create a solution that is accessible to all job applicants and employers, one that simplifies applications, standardizes data, and improves the quality of information shared between both parties.
    </p>

    <h3 class="text-2xl font-bold mb-4 scroll-reveal text-center">
      Potential 
      <span class="gradient-text-blue">Challenges</span> 
      and
      <span class="gradient-text-blue">Mitigations</span>
    </h3>

    <ul class="list-disc list-inside text-gray-700 leading-relaxed mb-10 scroll-reveal max-w-3xl mx-auto">
      <li class="mb-10">There was a risk of the project stalling before completion. This was addressed by creating a public <span class="gradient-text-blue"><a href="https://github.com/OpenBaraza/ajirika">GitHub repository</a></span> and inviting developers to contribute, ensuring transparency, collaboration, and long-term sustainability.</li>

  </main>

  <!-- Footer -->
  <jsp:include page="/includes/footer.jsp" />

  <script src="<%= request.getContextPath() %>/javascript/launchmeeting.js"></script>

  <!-- Lightbox Modal -->
  <div id="lightbox" class="fixed inset-0 bg-black bg-opacity-90 flex items-center justify-center hidden z-50">
    <button id="lightboxLeft" class="absolute left-5 top-1/2 -translate-y-1/2 z-50 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 text-blue-900">&#10094;</button>
    <img id="lightboxImage" class="max-w-[90%] max-h-[90%] rounded-lg shadow-lg" />
    <button id="lightboxRight" class="absolute right-5 top-1/2 -translate-y-1/2 z-50 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-blue-100 text-blue-900">&#10095;</button>
    <button onclick="closeLightbox()" class="absolute top-5 right-5 text-white text-3xl font-bold hover:text-gray-300">&times;</button>
  </div>
</body>
</html>
