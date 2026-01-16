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

<body class="bg-gray-100 font-[Space_Grotesk]">

  <!-- Header -->
  <jsp:include page="/includes/header.jsp" />

  <!-- Main Content -->
  <main class="max-w-5xl mx-auto px-6 py-16 mt-7">

    <!-- Title -->
    <h1 class="text-3xl font-bold text-gray-900 mb-2">
      Ajirika Launch Meeting
    </h1>

    <p class="text-gray-800 leading-relaxed mb-8">
      On the 11th of December 2025, we gathered HR professionals and software developers at
      Parklands Sports Club, Nairobi, for a conversation that's long overdue - fixing Kenya's broken job application process.
    </p>

    <!-- Image Carousel -->
    <div class="relative mb-12">

      <!-- Left Arrow -->
      <button
        id="leftArrow"
        onclick="scrollGallery(-1)"
        class="absolute left-2 top-1/2 -translate-y-1/2 z-20 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-gray-100 hidden"
        aria-label="Scroll left"
      >
        &#10094;
      </button>

      <!-- Carousel Container -->
      <div class="overflow-hidden">
        <div id="launchGallery" class="flex gap-4 transition-transform duration-500" style="transform: translateX(0);">
          
          <img src="${pageContext.request.contextPath}/images/launch_image%201.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%202.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%203.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%204.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%205.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%206.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%207.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">
          <img src="${pageContext.request.contextPath}/images/launch_image%208.jpg" alt="Ajirika Launch Meeting" class="w-56 h-40 sm:w-64 sm:h-48 md:w-72 md:h-56 lg:w-80 lg:h-64 object-cover rounded-lg shadow-sm flex-shrink-0 cursor-pointer hover:scale-105 transition-transform duration-300">

        </div>
      </div>

      <!-- Right Arrow -->
      <button
        id="rightArrow"
        onclick="scrollGallery(1)"
        class="absolute right-2 top-1/2 -translate-y-1/2 z-20 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-gray-100"
        aria-label="Scroll right"
      >
        &#10095;
      </button>

    </div>

    <!-- Challenge Section -->
    <h2 class="text-2xl font-semibold text-gray-900 mb-3">
      The Challenge We Discussed
    </h2>

    <p class="text-gray-700 leading-relaxed mb-8">
      The recruitment landscape is shifting. Paper CVs and email applications are
      giving way to online portals and Applicant Tracking Systems (ATS). While this
      helps employers manage volume, it has created a new burden for job seekers -
      filling out the same details, over and over, on every single portal.
    </p>

    <!-- What We Heard -->
    <h2 class="text-2xl font-semibold text-gray-900 mb-4">
      What We Heard
    </h2>

    <h3 class="text-lg font-semibold text-gray-900 mb-2">
      From HR Professionals
    </h3>

    <p class="text-gray-700 leading-relaxed mb-6">
      Manual screening is exhausting. Portals help, but they've introduced a new
      headache - AI-generated CVs that are polished but lack authenticity. The big
      question remains: how do you find the real candidate behind the keywords?
    </p>

    <h3 class="text-lg font-semibold text-gray-900 mb-2">
      From Developers
    </h3>

    <p class="text-gray-700 leading-relaxed mb-8">
      To build smarter, fairer AI-powered hiring tools, developers need clean,
      structured personal data. The current inconsistency across CV formats makes
      this nearly impossible.
    </p>

    <!-- Solution Section -->
    <h2 class="text-2xl font-semibold text-gray-900 mb-3">
      The Ajirika Solution
    </h2>

    <p class="text-gray-800 leading-relaxed">
      A universal, standardised CV format that benefits everyone - job seekers
      apply once, recruiters receive consistent data, and developers can build
      tools that actually work.
    </p>

  </main>

  <!-- Footer -->
  <jsp:include page="/includes/footer.jsp" />

  <script src="<%= request.getContextPath() %>/javascript/launchmeeting.js"></script>

  <!-- Lightbox Modal -->
  <div id="lightbox" class="fixed inset-0 bg-black bg-opacity-90 flex items-center justify-center hidden z-50">

    <!-- Left Arrow -->
    <button
      id="lightboxLeft"
      class="absolute left-5 top-1/2 -translate-y-1/2 z-50 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-gray-200"
    >
      &#10094;
    </button>

    <!-- Image -->
    <img id="lightboxImage" class="max-w-[90%] max-h-[90%] rounded-lg shadow-lg" />

    <!-- Right Arrow -->
    <button
      id="lightboxRight"
      class="absolute right-5 top-1/2 -translate-y-1/2 z-50 bg-white shadow-md rounded-full w-12 h-12 flex items-center justify-center hover:bg-gray-200"
    >
      &#10095;
    </button>

    <!-- Close Button -->
    <button
      onclick="closeLightbox()"
      class="absolute top-5 right-5 text-white text-3xl font-bold hover:text-gray-300"
    >
      &times;
    </button>

  </div>
</body>
</html>
